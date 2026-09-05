import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Contrato de acceso a datos de autenticación. La implementación vive en
/// `data/repositories/auth_repository_impl.dart` y opera 100% en local
/// (Drift + almacenamiento seguro), sin dependencia de red.
abstract interface class AuthRepository {
  /// Autentica a un usuario con correo + contraseña usando Supabase Auth.
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  /// Registra un nuevo empleado en Supabase Auth, crea/actualiza su perfil y
  /// guarda el PIN de 4 dígitos.
  Future<Either<Failure, UserEntity>> registerEmployee({
    required String fullName,
    required String email,
    required String password,
    required String pin,
  });

  /// Autentica a un usuario validando usuario + PIN de 4 dígitos (modo local).
  Future<Either<Failure, UserEntity>> loginWithPin({
    required String username,
    required String pin,
  });

  /// Autentica usando biometría del dispositivo, para el usuario que ya
  /// tiene la sesión recordada (cambio rápido / recordar usuario).
  Future<Either<Failure, UserEntity>> loginWithBiometrics({required String userId});

  /// Verifica si el dispositivo soporta biometría y el usuario la tiene
  /// habilitada.
  Future<Either<Failure, bool>> canUseBiometrics({required String userId});

  /// Lista de usuarios activos, usada en la pantalla de cambio rápido.
  Future<Either<Failure, List<UserEntity>>> getActiveUsers();

  /// Verifica si el usuario local tiene un PIN configurado.
  Future<Either<Failure, bool>> userHasPin(String userId);

  /// Configura el PIN de un usuario recién autenticado que aún no tiene PIN.
  Future<Either<Failure, UserEntity>> setupPin({required String pin});

  /// Cambia el PIN de un usuario, validando el PIN actual primero.
  Future<Either<Failure, Unit>> changePin({
    required String userId,
    required String currentPin,
    required String newPin,
  });

  /// Flujo de recuperación: restablece el PIN validando la clave maestra
  /// del propietario/administrador.
  Future<Either<Failure, Unit>> recoverPin({
    required String username,
    required String ownerMasterPin,
    required String newPin,
  });

  /// Usuario actualmente en sesión (o `null`), leído desde almacenamiento
  /// seguro/local.
  Future<Either<Failure, UserEntity?>> getCurrentSession();

  /// Persiste la sesión activa localmente.
  Future<Either<Failure, Unit>> persistSession(UserEntity user);

  Future<Either<Failure, Unit>> logout();

  /// Nombre de usuario recordado (checkbox "Recordar usuario").
  Future<Either<Failure, String?>> getRememberedUsername();
  Future<Either<Failure, Unit>> setRememberedUsername(String? username);
}
