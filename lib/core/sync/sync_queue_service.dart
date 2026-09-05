import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/tables/system_tables.dart';
import 'sync_serializers.dart';

/// Escribe operaciones offline en `sync_queue_items` para que [SyncPushService]
/// las suba a Supabase cuando haya conectividad. Toda escritura local de
/// entidades con respaldo remoto pasa por aquí (sales, caja, inventario).
class SyncQueueService {
  SyncQueueService(this._db);
  final AppDatabase _db;

  /// Encola una operación de cualquier entidad. [payload] debe ser un mapa
  /// con los nombres de columnas exactos de Supabase (snake_case).
  Future<void> enqueue({
    required String entityTable,
    required String entityId,
    required SyncOperation operation,
    required Map<String, dynamic> payload,
  }) async {
    await _db.into(_db.syncQueueItems).insert(
          SyncQueueItemsCompanion.insert(
            id: Value(const Uuid().v4()),
            entityTable: entityTable,
            entityId: entityId,
            operation: operation,
            payloadJson: jsonEncode(payload),
            status: const Value(SyncStatus.pending),
          ),
        );
  }

  /// Encola un cliente (create/update/delete). Puede editarse tanto en el TPV
  /// como en la web; el push hace upsert por `id` (last-write-wins).
  Future<void> enqueueCustomer(Map<String, dynamic> customer) async {
    final id = customer['id'].toString();
    // Keep only the latest local snapshot. Otherwise an old active snapshot
    // can be uploaded after a newer local deletion and resurrect the client.
    await (_db.delete(_db.syncQueueItems)
          ..where((t) =>
              t.entityTable.equals('customers') &
              t.entityId.equals(id) &
              t.status.isInValues([SyncStatus.pending, SyncStatus.failed])))
        .go();
    return enqueue(
      entityTable: 'customers',
      entityId: id,
      operation: SyncOperation.create,
      payload: customer,
    );
  }

  /// Encola una operación de catálogo (producto, variante, categoría, marca o
  /// proveedor). [entityTable] es el nombre de la tabla en Supabase.
  Future<void> enqueueCatalog(
    String entityTable,
    Map<String, dynamic> payload,
  ) {
    return enqueue(
      entityTable: entityTable,
      entityId: payload['id'].toString(),
      operation: SyncOperation.create,
      payload: payload,
    );
  }

  Future<void> enqueueDelete(String entityTable, String entityId) {
    return enqueue(
      entityTable: entityTable,
      entityId: entityId,
      operation: SyncOperation.delete,
      payload: {'id': entityId},
    );
  }

  /// Encola TODO el catálogo local para subirlo a Supabase. Se usa al
  /// sincronizar (upsert idempotente por id) para que el catálogo creado
  /// offline en el TPV llegue a la web. No depende de tener TPV vinculado.
  ///
  /// Usa `batch` para insertar todos los items en una sola transacción SQLite
  /// (mucho más rápido que N inserts individuales).
  Future<int> enqueueAllCatalog() async {
    final categories = await _db.select(_db.categories).get();
    final brands = await _db.select(_db.brands).get();
    final suppliers = await _db.select(_db.suppliers).get();
    final products = await _db.select(_db.products).get();
    final variants = await _db.select(_db.productVariants).get();

    int count = 0;
    await _db.batch((batch) {
      for (final row in categories) {
        batch.insert(
            _db.syncQueueItems,
            SyncQueueItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              entityTable: 'categories',
              entityId: row.id,
              operation: SyncOperation.create,
              payloadJson: jsonEncode(SyncSerializers.category(row)),
              status: const Value(SyncStatus.pending),
            ));
        count++;
      }
      for (final row in brands) {
        batch.insert(
            _db.syncQueueItems,
            SyncQueueItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              entityTable: 'brands',
              entityId: row.id,
              operation: SyncOperation.create,
              payloadJson: jsonEncode(SyncSerializers.brand(row)),
              status: const Value(SyncStatus.pending),
            ));
        count++;
      }
      for (final row in suppliers) {
        batch.insert(
            _db.syncQueueItems,
            SyncQueueItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              entityTable: 'suppliers',
              entityId: row.id,
              operation: SyncOperation.create,
              payloadJson: jsonEncode(SyncSerializers.supplier(row)),
              status: const Value(SyncStatus.pending),
            ));
        count++;
      }
      for (final row in products) {
        batch.insert(
            _db.syncQueueItems,
            SyncQueueItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              entityTable: 'products',
              entityId: row.id,
              operation: SyncOperation.create,
              payloadJson: jsonEncode(SyncSerializers.product(row)),
              status: const Value(SyncStatus.pending),
            ));
        count++;
      }
      for (final row in variants) {
        batch.insert(
            _db.syncQueueItems,
            SyncQueueItemsCompanion.insert(
              id: Value(const Uuid().v4()),
              entityTable: 'product_variants',
              entityId: row.id,
              operation: SyncOperation.create,
              payloadJson: jsonEncode(SyncSerializers.productVariant(row)),
              status: const Value(SyncStatus.pending),
            ));
        count++;
      }
    });
    return count;
  }

  /// Encola una venta completa: la cabecera + sus ítems + sus pagos. El push
  /// la rehidrata y hace upsert de las tres tablas en orden.
  Future<void> enqueueSale({
    required Map<String, dynamic> sale,
    required List<Map<String, dynamic>> items,
    required List<Map<String, dynamic>> payments,
  }) {
    return enqueue(
      entityTable: 'sales',
      entityId: sale['id'].toString(),
      operation: SyncOperation.create,
      payload: {
        'sale': sale,
        'items': items,
        'payments': payments,
      },
    );
  }

  /// Encola una caja completa con sus movimientos (apertura/cierre).
  Future<void> enqueueCashRegister({
    required Map<String, dynamic> register,
    List<Map<String, dynamic>> movements = const [],
  }) {
    return enqueue(
      entityTable: 'cash_registers',
      entityId: register['id'].toString(),
      operation: SyncOperation.create,
      payload: {
        'register': register,
        'movements': movements,
      },
    );
  }

  /// Encola un movimiento de caja individual (ingreso/egreso/saleCash, etc.)
  Future<void> enqueueCashMovement(Map<String, dynamic> movement) {
    return enqueue(
      entityTable: 'cash_movements',
      entityId: movement['id'].toString(),
      operation: SyncOperation.create,
      payload: movement,
    );
  }

  /// Encola un movimiento de inventario (Kardex).
  Future<void> enqueueInventoryMovement(Map<String, dynamic> movement) {
    return enqueue(
      entityTable: 'inventory_movements',
      entityId: movement['id'].toString(),
      operation: SyncOperation.create,
      payload: movement,
    );
  }
}
