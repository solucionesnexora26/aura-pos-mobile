import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/users_table.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/pin_hasher.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
    required AppDatabase database,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _db = database;

  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final AppDatabase _db;

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      final String authUserId = response.user!.id;
      final profile = await _remoteDataSource.fetchProfile(authUserId);
      if (profile == null) {
        await _remoteDataSource.signOut();
        return const Left(AuthFailure('No se encontró el perfil del empleado.'));
      }

      final user = await _persistProfileLocally(profile, pin: null);
      await _localDataSource.persistSession(user.id);

      // While the authenticated session is active, pull all profiles
      // to ensure local DB has fresh data (bypasses RLS). This is
      // especially important for PIN hashes changed from the web admin.
      try {
        final profiles = await _remoteDataSource.pullAllProfilesAuthenticated();
        for (final p in profiles) {
          await _persistProfileLocally(p, pin: null);
        }
        debugPrint('[AUTH] loginWithEmailPassword: ${profiles.length} profiles synced with auth session');
      } catch (e) {
        debugPrint('[AUTH][WARN] loginWithEmailPassword: profiles sync failed: $e');
        // Non-critical: proceed even if profiles sync fails.
      }

      // Si el perfil aún no tiene PIN (p. ej. registro con confirmación de
      // email), mantenemos la sesión de Supabase activa para que setupPin
      // pueda actualizar el perfil remoto.
      final hasRemotePin = profile.pinHash != null && profile.pinHash!.isNotEmpty;
      if (hasRemotePin) {
        await _remoteDataSource.signOut(); // Mantiene sync en rol anon.
      }
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerEmployee({
    required String fullName,
    required String email,
    required String password,
    required String pin,
  }) async {
    try {
      final AuthResponse response = await _remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      // Si Supabase requiere confirmación por correo, la sesión será null.
      // En ese caso no se puede configurar el PIN todavía.
      if (response.session == null) {
        return const Left(
          AuthFailure(
            'Revisa tu correo electrónico y confirma la cuenta antes de iniciar sesión.',
          ),
        );
      }

      final String authUserId = response.user!.id;
      RemoteProfile? profile;
      for (var i = 0; i < 5; i++) {
        profile = await _remoteDataSource.fetchProfile(authUserId);
        if (profile != null) break;
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }
      if (profile == null) {
        await _remoteDataSource.signOut();
        return const Left(AuthFailure('No se pudo crear el perfil del empleado.'));
      }

      final salt = PinHasher.generateSalt();
      final hash = PinHasher.hash(pin, salt);
      await _remoteDataSource.updateProfilePin(
        profileId: profile.id,
        pinHash: hash,
        pinSalt: salt,
      );

      final user = await _persistProfileLocally(profile, pin: pin);
      await _localDataSource.persistSession(user.id);
      await _remoteDataSource.signOut();
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithPin({
    required String username,
    required String pin,
  }) async {
    try {
      // 1) Verificación local (offline-first).
      try {
        final UserRow user = await _localDataSource.loginWithPin(
          username: username,
          pin: pin,
        );
        return Right(user.toEntity());
      } on AuthException catch (_) {
        // El PIN local no coincide. El PIN pudo cambiarse desde la web admin
        // (profiles.pin_hash remoto) y la copia local estar desactualizada;
        // sin red, se conserva el comportamiento offline (PIN incorrecto).
      }

      // 2) Reconciliación remota: re-verifica el PIN contra el perfil actual
      //    de Supabase. Si coincide, actualiza el hash/salt local para que
      //    futuros desbloqueos offline funcionen con el PIN nuevo.
      final UserRow? localUser = await _localDataSource.findUserByUsername(username);
      if (localUser == null) {
        debugPrint('[AUTH_PIN] Reconciliación: usuario local no encontrado: $username');
        return const Left(AuthFailure('PIN incorrecto.'));
      }
      debugPrint('[AUTH_PIN] Reconciliación: id=${localUser.id} '
          'authUserId=${localUser.authUserId}');
      // [Diagnóstico] Estado del TPV de este dispositivo: si no es un TPV
      // activo, la RLS anónima sobre `profiles` devuelve vacío.
      try {
        final tpv = await _remoteDataSource.fetchThisDeviceTpv();
        debugPrint('[AUTH_PIN] Reconciliación: TPV dispositivo=$tpv');
      } catch (e) {
        debugPrint('[AUTH_PIN][ERROR] Reconciliación: tpv diag: $e');
      }

      RemoteProfile? profile;
      bool verifiedRemotely = false;
      try {
        // 1) RPC security definer: obtiene el perfil activo sin depender del
        //    estado del TPV (bypass de RLS). La verificación del PIN se hace
        //    localmente con PinHasher.verify (soporta formatos ':' y '::').
        profile = await _remoteDataSource.verifyPinRemotely(
          username: username,
          pin: pin,
        );
        if (profile != null) {
          verifiedRemotely = PinHasher.verify(
            pin,
            profile.pinSalt ?? '',
            profile.pinHash ?? '',
          );
          debugPrint('[AUTH_PIN] Reconciliación: RPC ok profile=${profile.id} '
              'verifiedRemotely=$verifiedRemotely');
        } else {
          // 2) Respaldo: lectura anónima de profiles (solo con TPV activo).
          profile = await _remoteDataSource.fetchProfileById(localUser.id);
          if (profile == null && localUser.authUserId != null) {
            profile = await _remoteDataSource.fetchProfile(localUser.authUserId!);
          }
          verifiedRemotely =
              profile != null &&
              PinHasher.verify(pin, profile.pinSalt ?? '', profile.pinHash ?? '');
        }
        debugPrint(
          '[AUTH_PIN] Reconciliación: profile=${profile?.id} '
          'verifiedRemotely=$verifiedRemotely pinHash=${profile?.pinHash ?? 'null'}',
        );
      } catch (e, st) {
        debugPrint('[AUTH_PIN][ERROR] Reconciliación falló: $e');
        debugPrint('[AUTH_PIN][ERROR] stack: $st');
        // Sin conexión: la reconciliación remota no es posible y se vuelve al
        // comportamiento offline (solo vale el PIN local).
        return const Left(AuthFailure('PIN incorrecto.'));
      }

      if (!verifiedRemotely || profile == null) {
        return const Left(AuthFailure('PIN incorrecto.'));
      }

      // PIN correcto en el backend: refrescar la copia local del usuario
      // (incluye pin_hash/pin_salt actualizados) y devolverlo.
      final UserEntity user = await _persistProfileLocally(profile, pin: null);
      await _localDataSource.persistSession(user.id);
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithBiometrics({required String userId}) async {
    try {
      final UserRow user = await _localDataSource.loginWithBiometrics(userId: userId);
      return Right(user.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> canUseBiometrics({required String userId}) async {
    try {
      final bool result = await _localDataSource.canUseBiometrics(userId: userId);
      return Right(result);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getActiveUsers() async {
    try {
      final List<UserRow> users = await _localDataSource.getActiveUsers();
      return Right(users.map((u) => u.toEntity()).toList());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> userHasPin(String userId) async {
    try {
      final UserRow? user = await (_db.select(_db.users)
            ..where((tbl) => tbl.id.equals(userId)))
          .getSingleOrNull();
      if (user == null) return const Right(false);
      return Right(user.pinHash.isNotEmpty && user.pinSalt.isNotEmpty);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> setupPin({required String pin}) async {
    try {
      final sessionUser = await _localDataSource.getCurrentSession();
      if (sessionUser == null) {
        return const Left(AuthFailure('No hay una sesión activa.'));
      }

      final salt = PinHasher.generateSalt();
      final hash = PinHasher.hash(pin, salt);
      await _remoteDataSource.updateProfilePin(
        profileId: sessionUser.id,
        pinHash: hash,
        pinSalt: salt,
      );

      final user = await _persistProfileLocally(
        RemoteProfile(
          id: sessionUser.id,
          authUserId: sessionUser.authUserId ?? '',
          fullName: sessionUser.fullName,
          username: sessionUser.username,
          email: sessionUser.email ?? '',
          role: sessionUser.role.index,
          biometricEnabled: sessionUser.biometricEnabled,
          isActive: sessionUser.isActive,
          pinHash: hash,
          pinSalt: salt,
        ),
        pin: pin,
      );
      await _remoteDataSource.signOut();
      return Right(user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePin({
    required String userId,
    required String currentPin,
    required String newPin,
  }) async {
    try {
      await _localDataSource.changePin(
        userId: userId,
        currentPin: currentPin,
        newPin: newPin,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> recoverPin({
    required String username,
    required String ownerMasterPin,
    required String newPin,
  }) async {
    try {
      await _localDataSource.recoverPin(
        username: username,
        ownerMasterPin: ownerMasterPin,
        newPin: newPin,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentSession() async {
    try {
      final UserRow? user = await _localDataSource.getCurrentSession();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> persistSession(UserEntity user) async {
    try {
      await _localDataSource.persistSession(user.id);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remoteDataSource.signOut();
      await _localDataSource.logout();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getRememberedUsername() async {
    try {
      return Right(_localDataSource.getRememberedUsername());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setRememberedUsername(String? username) async {
    try {
      await _localDataSource.setRememberedUsername(username);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  /// Guarda o actualiza el perfil remoto en la tabla local [users].
  /// Si [pin] no es null, genera hash/salt nuevos.
  Future<UserEntity> _persistProfileLocally(RemoteProfile profile, {String? pin}) async {
    final existing = await (_db.select(_db.users)
          ..where((tbl) => tbl.id.equals(profile.id)))
        .getSingleOrNull();

    final String pinHash;
    final String pinSalt;
    if (pin != null && pin.isNotEmpty) {
      pinSalt = PinHasher.generateSalt();
      pinHash = PinHasher.hash(pin, pinSalt);
    } else {
      pinSalt = profile.pinSalt ?? '';
      pinHash = profile.pinHash ?? '';
    }

    final companion = UsersCompanion(
      id: Value(profile.id),
      authUserId: Value(profile.authUserId),
      fullName: Value(profile.fullName),
      username: Value(profile.username),
      email: Value(profile.email),
      pinHash: Value(pinHash),
      pinSalt: Value(pinSalt),
      role: Value(UserRole.values[profile.role]),
      biometricEnabled: Value(profile.biometricEnabled),
      isActive: Value(profile.isActive),
      avatarPath: Value(profile.avatarUrl),
      updatedAt: Value(DateTime.now()),
    );

    if (existing == null) {
      await _db.into(_db.users).insert(companion);
    } else {
      await (_db.update(_db.users)..where((tbl) => tbl.id.equals(profile.id))).write(companion);
    }

    return (await (_db.select(_db.users)..where((tbl) => tbl.id.equals(profile.id))).getSingle())
        .toEntity();
  }
}
