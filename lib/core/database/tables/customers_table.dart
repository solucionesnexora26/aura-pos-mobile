import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

enum CustomerType { occasional, frequent, credit }

@DataClassName('CustomerRow')
class Customers extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get fullName => text().withLength(min: 1, max: 150)();
  TextColumn get documentId => text().nullable().unique()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get type => intEnum<CustomerType>().withDefault(const Constant(0))();
  RealColumn get creditLimit => real().withDefault(const Constant(0))();
  RealColumn get creditBalance => real().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().withDefault(Constant(DateTime.fromMillisecondsSinceEpoch(0)))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
