import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'catalog_tables.dart';

/// Unidad de venta del producto: por unidad entera o por peso (kg/g/lb).
enum ProductUnitType { unit, weightKg, weightG, weightLb }

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  TextColumn get description => text().nullable()();
  TextColumn get sku => text().nullable().unique()();
  TextColumn get barcode => text().nullable().unique()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get brandId => text().nullable().references(Brands, #id)();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  RealColumn get price => real()();
  RealColumn get cost => real().withDefault(const Constant(0))();
  RealColumn get taxRate => real().withDefault(const Constant(0))(); // porcentaje ej. 19.0
  IntColumn get unitType => intEnum<ProductUnitType>().withDefault(const Constant(0))();
  BoolColumn get trackStock => boolean().withDefault(const Constant(true))();
  RealColumn get stockQuantity => real().withDefault(const Constant(0))();
  RealColumn get lowStockThreshold => real().withDefault(const Constant(5))();
  BoolColumn get hasVariants => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProductVariantRow')
class ProductVariants extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)(); // ej. "Talla M / Rojo"
  TextColumn get sku => text().nullable().unique()();
  TextColumn get barcode => text().nullable().unique()();
  RealColumn get priceDelta => real().withDefault(const Constant(0))(); // ajuste sobre precio base
  RealColumn get stockQuantity => real().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
