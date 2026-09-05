import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

enum UserRoleEntity { owner, admin, cashier, waiter }

extension UserRoleEntityX on UserRoleEntity {
  String get label => switch (this) {
        UserRoleEntity.owner => 'Propietario',
        UserRoleEntity.admin => 'Administrador',
        UserRoleEntity.cashier => 'Cajero',
        UserRoleEntity.waiter => 'Mesero',
      };

  /// Roles habilitados para realizar acciones críticas protegidas por PIN
  /// (anular venta, abrir/cerrar caja, editar precios, etc.).
  bool get canPerformCriticalActions =>
      this == UserRoleEntity.owner || this == UserRoleEntity.admin;
}

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String fullName,
    required String username,
    required String email,
    required UserRoleEntity role,
    required bool biometricEnabled,
    required bool isActive,
    String? avatarPath,
    String? authUserId,
  }) = _UserEntity;
}
