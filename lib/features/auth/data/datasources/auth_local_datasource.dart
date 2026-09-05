import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/users_table.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/pin_hasher.dart';

abstract interface class AuthLocalDataSource {
  Future<UserRow> loginWithPin({required String username, required String pin});
  Future<UserRow> loginWithBiometrics({required String userId});
  Future<bool> canUseBiometrics({required String userId});
  Future<List<UserRow>> getActiveUsers();
  Future<UserRow?> findUserByUsername(String username);
  Future<void> changePin({required String userId, required String currentPin, required String newPin});
  Future<void> recoverPin({required String username, required String ownerMasterPin, required String newPin});
  Future<UserRow?> getCurrentSession();
  Future<void> persistSession(String userId);
  Future<void> logout();
  String? getRememberedUsername();
  Future<void> setRememberedUsername(String? username);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required AppDatabase database,
    required FlutterSecureStorage secureStorage,
    required Box<dynamic> preferencesBox,
    LocalAuthentication? localAuth,
  })  : _db = database,
        _secureStorage = secureStorage,
        _prefs = preferencesBox,
        _localAuth = localAuth ?? LocalAuthentication();

  static const String _sessionUserIdKey = '${AppConstants.secureStorageKeyPrefix}session_user_id';

  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;
  final Box<dynamic> _prefs;
  final LocalAuthentication _localAuth;

  Future<UserRow> _findByUsername(String username) async {
    final UserRow? user = await (_db.select(_db.users)
          ..where((tbl) => tbl.username.equals(username) & tbl.isActive.equals(true)))
        .getSingleOrNull();
    if (user == null) {
      throw const AuthException('Usuario no encontrado o inactivo.');
    }
    return user;
  }

  @override
  Future<UserRow> loginWithPin({required String username, required String pin}) async {
    final UserRow user = await _findByUsername(username);
    final bool valid = PinHasher.verify(pin, user.pinSalt, user.pinHash);
    if (!valid) {
      throw const AuthException('PIN incorrecto.');
    }
    return user;
  }

  @override
  Future<UserRow> loginWithBiometrics({required String userId}) async {
    final UserRow? user = await (_db.select(_db.users)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (user == null || !user.biometricEnabled) {
      throw const AuthException('La biometría no está habilitada para este usuario.');
    }
    final bool canCheck = await _localAuth.canCheckBiometrics;
    if (!canCheck) {
      throw const AuthException('Este dispositivo no soporta autenticación biométrica.');
    }
    final bool authenticated = await _localAuth.authenticate(
      localizedReason: 'Confirma tu identidad para iniciar sesión en Aura POS',
      options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
    );
    if (!authenticated) {
      throw const AuthException('Autenticación biométrica cancelada o fallida.');
    }
    return user;
  }

  @override
  Future<bool> canUseBiometrics({required String userId}) async {
    final UserRow? user = await (_db.select(_db.users)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (user == null || !user.biometricEnabled) return false;
    return _localAuth.canCheckBiometrics;
  }

  @override
  Future<List<UserRow>> getActiveUsers() {
    return (_db.select(_db.users)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
        .get();
  }

  @override
  Future<UserRow?> findUserByUsername(String username) {
    return (_db.select(_db.users)
          ..where((tbl) => tbl.username.equals(username)))
        .getSingleOrNull();
  }

  @override
  Future<void> changePin({required String userId, required String currentPin, required String newPin}) async {
    final UserRow? user = await (_db.select(_db.users)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (user == null) {
      throw const NotFoundException('Usuario no encontrado.');
    }
    if (!PinHasher.verify(currentPin, user.pinSalt, user.pinHash)) {
      throw const AuthException('El PIN actual es incorrecto.');
    }
    final String newSalt = PinHasher.generateSalt();
    final String newHash = PinHasher.hash(newPin, newSalt);
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(
        pinHash: Value(newHash),
        pinSalt: Value(newSalt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> recoverPin({required String username, required String ownerMasterPin, required String newPin}) async {
    final UserRow target = await _findByUsername(username);

    // Busca un propietario/administrador cuyo PIN maestro coincida, como
    // mecanismo de verificación de identidad sin depender de red.
    final List<UserRow> supervisors = await (_db.select(_db.users)
          ..where((tbl) => tbl.isActive.equals(true) & tbl.role.equalsValue(UserRole.owner)))
        .get();
    final List<UserRow> admins = await (_db.select(_db.users)
          ..where((tbl) => tbl.isActive.equals(true) & tbl.role.equalsValue(UserRole.admin)))
        .get();

    final bool verifiedBySupervisor = [...supervisors, ...admins]
        .any((u) => PinHasher.verify(ownerMasterPin, u.pinSalt, u.pinHash));

    if (!verifiedBySupervisor) {
      throw const AuthException('El PIN maestro de verificación es incorrecto.');
    }

    final String newSalt = PinHasher.generateSalt();
    final String newHash = PinHasher.hash(newPin, newSalt);
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(target.id))).write(
      UsersCompanion(
        pinHash: Value(newHash),
        pinSalt: Value(newSalt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<UserRow?> getCurrentSession() async {
    final String? userId = await _secureStorage.read(key: _sessionUserIdKey);
    if (userId == null) return null;
    return (_db.select(_db.users)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
  }

  @override
  Future<void> persistSession(String userId) async {
    await _secureStorage.write(key: _sessionUserIdKey, value: userId);
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: _sessionUserIdKey);
  }

  @override
  String? getRememberedUsername() {
    return _prefs.get(PreferenceKeys.rememberedUsername) as String?;
  }

  @override
  Future<void> setRememberedUsername(String? username) async {
    if (username == null) {
      await _prefs.delete(PreferenceKeys.rememberedUsername);
    } else {
      await _prefs.put(PreferenceKeys.rememberedUsername, username);
    }
  }
}
