import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'products_table.dart';
import 'users_table.dart';

enum InventoryMovementType { entry, exit, adjustment, transfer, saleDeduction, saleReturn }

@DataClassName('InventoryMovementRow')
class InventoryMovements extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get variantId => text().nullable().references(ProductVariants, #id)();
  IntColumn get type => intEnum<InventoryMovementType>()();
  RealColumn get quantity => real()(); // siempre positiva; el signo lo determina [type]
  RealColumn get stockBefore => real()();
  RealColumn get stockAfter => real()();
  TextColumn get reason => text().nullable()();
  TextColumn get referenceId => text().nullable()(); // ej. saleId cuando type = saleDeduction
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
