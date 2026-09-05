import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'users_table.dart';

enum CashRegisterStatus { open, closed }

enum CashMovementType { income, expense, saleCash, openingFloat, closingCount, withdrawal, deposit }

@DataClassName('CashRegisterRow')
class CashRegisters extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get shiftLabel => text().nullable()();
  RealColumn get openingAmount => real()();
  RealColumn get expectedClosingAmount => real().nullable()();
  RealColumn get countedClosingAmount => real().nullable()();
  RealColumn get difference => real().nullable()();
  IntColumn get status => intEnum<CashRegisterStatus>().withDefault(const Constant(0))();
  DateTimeColumn get openedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CashMovementRow')
class CashMovements extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get cashRegisterId => text().references(CashRegisters, #id)();
  TextColumn get saleId => text().nullable()();
  IntColumn get type => intEnum<CashMovementType>()();
  RealColumn get amount => real()();
  IntColumn get method => integer().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
