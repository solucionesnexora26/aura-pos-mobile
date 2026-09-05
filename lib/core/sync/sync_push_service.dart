import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../database/tables/sales_tables.dart';
import '../database/tables/system_tables.dart';
import 'device_id_service.dart';

/// Resultado de un ciclo de push.
class SyncPushResult {
  const SyncPushResult({required this.pushed, required this.failed});
  final int pushed;
  final int failed;

  int get total => pushed + failed;
}

/// Sube la cola offline (`sync_queue_items`) a Supabase con el rol anon
/// identificado como TPV activo. Cada ítem se rehidrata y se upserta en la
/// tabla correspondiente; al terminar se marca synced o failed (con retry).
class SyncPushService {
  SyncPushService({
    required SupabaseClient client,
    required AppDatabase db,
    required DeviceIdService deviceIdService,
  })  : _client = client,
        _db = db,
        _deviceIdService = deviceIdService;

  final SupabaseClient _client;
  final AppDatabase _db;
  final DeviceIdService _deviceIdService;

  /// Previene ejecuciones simultáneas de [pushAll].
  bool _pushing = false;

  /// Procesa todos los ítems pendientes (status pending o failed con retries
  /// disponibles) en orden FIFO. Es seguro llamarla varias veces: si ya hay
  /// un push en curso, la segunda llamada retorna inmediatamente.
  Future<SyncPushResult> pushAll() async {
    if (_pushing) {
      debugPrint('[SYNC_PUSH] pushAll skipped: already running');
      return const SyncPushResult(pushed: 0, failed: 0);
    }
    _pushing = true;
    try {
      debugPrint('[SYNC_PUSH] pushAll started');
      final String? tpvId = await _deviceIdService.getTpvId();
      debugPrint('[SYNC_PUSH] tpvId=$tpvId');
      if (tpvId == null || tpvId.isEmpty) {
        debugPrint('[SYNC_PUSH][ERROR] no TPV linked');
        return const SyncPushResult(pushed: 0, failed: 0);
      }

      final rows = await (_db.select(_db.syncQueueItems)
            ..where((t) => t.status.isInValues(
                  [SyncStatus.pending, SyncStatus.failed],
                ))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();
      debugPrint('[SYNC_PUSH] pending rows=${rows.length}');

      int pushed = 0;
      int failed = 0;
      for (final row in rows) {
        debugPrint('[SYNC_PUSH] processing operation: ${row.id} entity=${row.entityTable} entityId=${row.entityId} status=${row.status} retry=${row.retryCount}');
        final ok = await _processRow(row, tpvId);
        if (ok) {
          pushed++;
          await _markSynced(row);
          debugPrint('[SYNC_PUSH] operation synced: ${row.id}');
        } else {
          failed++;
          debugPrint('[SYNC_PUSH] operation failed: ${row.id}');
        }
      }
      debugPrint('[SYNC_PUSH] pushAll completed pushed=$pushed failed=$failed');
      return SyncPushResult(pushed: pushed, failed: failed);
    } finally {
      _pushing = false;
    }
  }

  Future<bool> _processRow(SyncQueueRow row, String tpvId) async {
    try {
      debugPrint('[SYNC_PUSH] _processRow started: ${row.id} table=${row.entityTable}');
      final Map<String, dynamic> payload =
          (jsonDecode(row.payloadJson) as Map).cast<String, dynamic>();
      if (row.operation == SyncOperation.delete) {
        await _deleteRemote(row.entityTable, row.entityId);
        return true;
      }
      switch (row.entityTable) {
        case 'customers':
          final customerId = payload['id']?.toString() ?? row.entityId;
          final isDeleted = payload['deleted_at'] != null ||
              payload['is_active'] == false;
          if (isDeleted) {
            debugPrint('[SYNC_PUSH] deleting customer via RPC: $customerId');
            final result = await _client.rpc<dynamic>(
              'delete_customer_from_tpv',
              params: {'p_customer_id': customerId},
            );
            debugPrint('[SYNC_PUSH] customer delete RPC OK: $result');
            return true;
          }
          debugPrint('[SYNC_PUSH] upserting customers: $customerId');
          await _client.from('customers').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] customers upsert OK');
        case 'categories':
          debugPrint('[SYNC_PUSH] upserting categories: ${payload['id']}');
          await _client.from('categories').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] categories upsert OK');
        case 'brands':
          debugPrint('[SYNC_PUSH] upserting brands: ${payload['id']}');
          await _client.from('brands').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] brands upsert OK');
        case 'suppliers':
          debugPrint('[SYNC_PUSH] upserting suppliers: ${payload['id']}');
          await _client.from('suppliers').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] suppliers upsert OK');
        case 'products':
          debugPrint('[SYNC_PUSH] upserting products: ${payload['id']}');
          await _client.from('products').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] products upsert OK');
        case 'product_variants':
          debugPrint('[SYNC_PUSH] upserting product_variants: ${payload['id']}');
          await _client.from('product_variants').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] product_variants upsert OK');
        case 'sales':
          debugPrint('[SYNC_PUSH] _pushSale called for operation: ${row.id}');
          await _pushSale(payload, tpvId);
          debugPrint('[SYNC_PUSH] _pushSale completed for operation: ${row.id}');
        case 'cash_registers':
          debugPrint('[SYNC_PUSH] _pushCashRegister called: ${payload['register']?['id']}');
          await _pushCashRegister(payload, tpvId);
          debugPrint('[SYNC_PUSH] _pushCashRegister completed');
        case 'cash_movements':
          debugPrint('[SYNC_PUSH] upserting cash_movements: ${payload['id']}');
          await _client.from('cash_movements').upsert(
            [_withTpv(payload, tpvId, hasTpvColumn: false)],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] cash_movements upsert OK');
        case 'inventory_movements':
          debugPrint('[SYNC_PUSH] upserting inventory_movements: ${payload['id']}');
          await _client.from('inventory_movements').upsert(
            [payload],
            onConflict: 'id',
          );
          debugPrint('[SYNC_PUSH] inventory_movements upsert OK');
        default:
          // Tabla no soportada: no reintentar.
          debugPrint('[SYNC_PUSH] unsupported table, marking synced: ${row.entityTable}');
          await (_db.update(_db.syncQueueItems)
                ..where((t) => t.id.equals(row.id)))
              .write(const SyncQueueItemsCompanion(
            status: Value(SyncStatus.synced),
          ));
          return true;
      }
      return true;
    } catch (e, st) {
      debugPrint('[SYNC_PUSH][ERROR] operation=${row.id} entity=${row.entityTable} entityId=${row.entityId}');
      debugPrint('[SYNC_PUSH][ERROR] exception=$e');
      debugPrint('[SYNC_PUSH][ERROR] stack=$st');
      await _markFailed(row, error: e.toString());
      return false;
    }
  }

  Future<void> _deleteRemote(String entityTable, String entityId) async {
    switch (entityTable) {
      case 'customers':
        await _client.rpc<dynamic>(
          'delete_customer_from_tpv',
          params: {'p_customer_id': entityId},
        );
      case 'products':
        await _client.from('products').update({
          'is_deleted': true,
          'is_active': false,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }).eq('id', entityId);
      case 'product_variants':
        await _client.from('product_variants').update({
          'is_active': false,
        }).eq('id', entityId);
      default:
        await _client.from(entityTable).delete().eq('id', entityId);
    }
  }

  Future<void> _pushSale(Map<String, dynamic> payload, String tpvId) async {
    final Map<String, dynamic> sale =
        (payload['sale'] as Map).cast<String, dynamic>();
    final String saleId = sale['id'].toString();
    debugPrint('[SYNC_PUSH] _pushSale started: $saleId');
    final List<Map<String, dynamic>> items = (payload['items'] as List? ?? [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
    final List<Map<String, dynamic>> payments =
        (payload['payments'] as List? ?? [])
            .map((e) => (e as Map).cast<String, dynamic>())
            .toList();

    // 1) Cabecera de la venta (con tpv_id del dispositivo activo)
    debugPrint('[SYNC_PUSH] inserting sales: $saleId');
    await _client.from('sales').upsert(
      [_withTpv(sale, tpvId, hasTpvColumn: true)],
      onConflict: 'id',
    );
    debugPrint('[SYNC_PUSH] sales upsert OK: $saleId');
    // 2) Ítems
    if (items.isNotEmpty) {
      debugPrint('[SYNC_PUSH] inserting sale_items: ${items.map((i) => i['id']).join(',')}');
      await _client.from('sale_items').upsert(items, onConflict: 'id');
      debugPrint('[SYNC_PUSH] sale_items upsert OK');
    }
    // 3) Pagos
    if (payments.isNotEmpty) {
      debugPrint('[SYNC_PUSH] inserting payments: ${payments.map((p) => p['id']).join(',')}');
      await _client.from('payments').upsert(payments, onConflict: 'id');
      debugPrint('[SYNC_PUSH] payments upsert OK');
    }

    // 3b) Si la venta incluye un pago con método "Crédito" (code 6), se
    //     registra la deuda vía RPC: marca is_credit=true, valida el cupo y
    //     suma el total al credit_balance del cliente. El RPC es idempotente
    //     (0034), por lo que un reintento del push no duplica el balance.
    final isCredit = payments.any(
      (p) => p['method'] == PaymentMethod.credit.index,
    );
    final creditCustomerId = sale['customer_id']?.toString();
    if (isCredit) {
      debugPrint('[SYNC_PUSH] credit sale detected: $saleId customer=$creditCustomerId');
      if (creditCustomerId == null || creditCustomerId.isEmpty) {
        debugPrint('[SYNC_PUSH][WARN] credit sale without customer_id: $saleId');
      } else {
        await _client.rpc<dynamic>(
          'register_credit_sale',
          params: {'p_sale_id': saleId, 'p_customer_id': creditCustomerId},
        );
        debugPrint('[SYNC_PUSH] register_credit_sale OK: $saleId');
      }
    }

    // 4) Descuento atómico de inventario vía RPC (idempotente, concurrente-safe).
    //    Se ejecuta después de que la venta, ítems y pagos existen en Supabase.
    try {
      debugPrint('[SYNC_PUSH] calling apply_sale_inventory RPC: $saleId');
      await _client.rpc<dynamic>(
        'apply_sale_inventory',
        params: {'p_sale_id': sale['id']},
      );
      debugPrint('[SYNC_PUSH] inventory RPC OK: $saleId');
    } catch (e, st) {
      debugPrint('[SYNC_PUSH][ERROR] apply_sale_inventory failed for sale=$saleId: $e');
      debugPrint('[SYNC_PUSH][ERROR] stack: $st');
      // Si la RPC falla (p. ej. producto ya no existe), la venta ya quedó
      // registrada. El inventario se puede ajustar manualmente.
    }
    debugPrint('[SYNC_PUSH] _pushSale completed: $saleId');
  }

  Future<void> _pushCashRegister(
      Map<String, dynamic> payload, String tpvId) async {
    final Map<String, dynamic> register =
        (payload['register'] as Map).cast<String, dynamic>();
    final List<Map<String, dynamic>> movements =
        (payload['movements'] as List? ?? [])
            .map((e) => (e as Map).cast<String, dynamic>())
            .toList();

    await _client.from('cash_registers').upsert(
        [_withTpv(register, tpvId, hasTpvColumn: true)],
        onConflict: 'id');
    if (movements.isNotEmpty) {
      await _client.from('cash_movements').upsert(movements, onConflict: 'id');
    }
  }

  /// Inyecta el `tpv_id` del dispositivo en el payload de las tablas que lo
  /// requieren para el RLS (sales, cash_registers).
  Map<String, dynamic> _withTpv(Map<String, dynamic> payload, String tpvId,
      {required bool hasTpvColumn}) {
    if (!hasTpvColumn) return payload;
    payload['tpv_id'] = tpvId;
    return payload;
  }

  Future<void> _markSynced(SyncQueueRow row) async {
    await (_db.update(_db.syncQueueItems)..where((t) => t.id.equals(row.id)))
        .write(SyncQueueItemsCompanion(
      status: const Value(SyncStatus.synced),
      lastError: const Value(null),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> _markFailed(SyncQueueRow row, {String? error}) async {
    final message = error == null || error.isEmpty
        ? 'Error de red'
        : (error.length > 500 ? error.substring(0, 500) : error);
    final recoverable = _isRecoverableError(error);
    final nextRetry = row.retryCount + 1;
    // Errores no recuperables (p. ej. UUID inválido, FK inexistente) pasan
    // directamente a failed. Recuperables (red/timeout) reintentan hasta 5.
    final SyncStatus nextStatus = !recoverable || nextRetry >= 5
        ? SyncStatus.failed
        : SyncStatus.pending;
    await (_db.update(_db.syncQueueItems)..where((t) => t.id.equals(row.id)))
        .write(SyncQueueItemsCompanion(
      status: Value(nextStatus),
      retryCount: Value(nextRetry),
      lastError: Value(message),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Determina si un error justifica reintentar la operación.
  bool _isRecoverableError(String? error) {
    if (error == null || error.isEmpty) return true;
    final lower = error.toLowerCase();
    // Errores de esquema/datos: no recuperables.
    if (lower.contains('invalid input syntax for type uuid')) return false;
    if (lower.contains('foreign key constraint')) return false;
    if (lower.contains('violates not-null constraint')) return false;
    if (lower.contains('violates check constraint')) return false;
    if (lower.contains('duplicate key value')) return false;
    if (lower.contains('row-level security')) return false;
    if (lower.contains('permission denied')) return false;
    if (lower.contains('format_exception')) return false;
    if (lower.contains('argumenterror')) return false;
    // Lo demás (socket, timeout, dns, 5xx, etc.) se considera recuperable.
    return true;
  }
}
