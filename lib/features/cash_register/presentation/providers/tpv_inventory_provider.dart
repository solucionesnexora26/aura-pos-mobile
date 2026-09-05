import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/products_table.dart';
import '../../../../core/di/providers.dart';

/// Fila de inventario local del TPV (para pantallas de cotejo / cierre de ruta).
class TpvInventoryItem {
  const TpvInventoryItem({
    required this.productId,
    this.productName,
    required this.stock,
  });

  final String productId;
  final String? productName;
  final double stock;
}

/// Inventario disponible del TPV vinculado (stock por vehículo).
final tpvInventoryProvider = StreamProvider<List<TpvInventoryItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.tpvInventory)
        ..orderBy([(t) => OrderingTerm.asc(t.productId)]))
      .watch()
      .asyncMap((rows) async {
    final productMap = <String, String>{};
    final products = await db.select(db.products).get();
    for (final p in products) {
      productMap[p.id] = p.name;
    }
    return rows
        .map((r) => TpvInventoryItem(
              productId: r.productId,
              productName: productMap[r.productId],
              stock: r.stock,
            ))
        .toList();
  });
});

/// Producto o variante con su stock total local (para el cotejo).
class StockItem {
  const StockItem({
    required this.id,
    required this.name,
    required this.stock,
  });

  final String id;
  final String name;
  final double stock;
}

/// Lista de todos los productos controlados con su stock actual en el TPV.
/// Los productos con inventario por TPV usan ese stock; el resto usa el global.
final currentTpvStockProvider = StreamProvider<List<StockItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.products)
        ..where((t) => t.trackStock.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .watch()
      .asyncMap((products) async {
    final inventory = await db.select(db.tpvInventory).get();
    final stockByProduct = <String, double>{};
    for (final i in inventory) {
      // Solo productos (sin variantes) para simplificar la vista de cotejo.
      if (i.variantId == null) stockByProduct[i.productId] = i.stock;
    }
    return products
        .map((p) => StockItem(
              id: p.id,
              name: p.name,
              stock: stockByProduct[p.id] ?? p.stockQuantity,
            ))
        .where((s) => s.stock > 0)
        .toList();
  });
});
