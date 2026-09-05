import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'products_table.dart';

/// Inventario local del TPV vinculado.
///
/// Se descarga desde Supabase vía la RPC `get_tpv_inventory()` (filtrada por el
/// TPV activo) durante el sync y alimenta el stock disponible en el POS. Es la
/// fuente de verdad del inventario del vehículo repartidor.
@DataClassName('TpvInventoryRow')
class TpvInventory extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get variantId => text().nullable().references(ProductVariants, #id)();
  RealColumn get stock => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
