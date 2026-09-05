import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/users_table.dart';
import '../../domain/entities/user_entity.dart';

/// Traduce entre la fila cruda de Drift ([UserRow]) y la entidad de
/// dominio ([UserEntity]), manteniendo los detalles de persistencia
/// (hash/salt del PIN) fuera del dominio.
extension UserModelMapper on UserRow {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      authUserId: authUserId,
      fullName: fullName,
      username: username,
      email: email ?? '',
      role: UserRoleEntity.values[role.index],
      biometricEnabled: biometricEnabled,
      isActive: isActive,
      avatarPath: avatarPath,
    );
  }
}

extension UserRoleEntityMapper on UserRoleEntity {
  UserRole toTableEnum() => UserRole.values[index];
}
