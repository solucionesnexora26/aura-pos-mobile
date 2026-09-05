import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Roles de usuario dentro de la aplicación.
enum UserRole { owner, admin, cashier, waiter }

@DataClassName('UserRow')
class Users extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get authUserId => text().nullable().unique()();
  TextColumn get fullName => text().withLength(min: 1, max: 120)();
  TextColumn get username => text().unique()();
  TextColumn get email => text().nullable().unique()();
  TextColumn get pinHash => text()(); // hash SHA-256 + salt del PIN de 4 dígitos
  TextColumn get pinSalt => text()();
  IntColumn get role => intEnum<UserRole>()();
  BoolColumn get biometricEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get avatarPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
