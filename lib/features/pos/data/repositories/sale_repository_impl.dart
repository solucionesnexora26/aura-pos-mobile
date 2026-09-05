import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/sales_tables.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/device_id_service.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../../../core/utils/validators.dart';
import '../../../pos/domain/entities/cart_entity.dart';

// ─── Entidad de venta (dominio) ───────────────────────────────────────────────

class SaleEntity {
  const SaleEntity({
    required this.id,
    required this.ticketNumber,
    this.ticketLabel,
    this.customerId,
    required this.userId,
    this.employeeName,
    this.cashRegisterId,
    this.tpvName,
    required this.status,
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.total,
    required this.changeGiven,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    required this.items,
    required this.payments,
  });

  final String id;
  final String ticketNumber;
  final String? ticketLabel;
  final String? customerId;
  final String userId;
  final String? employeeName;
  final String? cashRegisterId;
  final String? tpvName;
  final SaleStatus status;
  final double subtotal;
  final double discountTotal;
  final double taxTotal;
  final double total;
  final double changeGiven;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final List<SaleItemRow> items;
  final List<PaymentRow> payments;
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

abstract interface class SaleRepository {
  Future<Either<Failure, SaleEntity>> createOpenSale(CartState cart, String userId, String? cashRegisterId);
  Future<Either<Failure, SaleEntity>> updateOpenSale(String saleId, CartState cart);
  Future<Either<Failure, SaleEntity>> completeSale({
    required String saleId,
    required CartState cart,
    required List<({PaymentMethod method, double amount, String? reference})> payments,
    required double changeGiven,
    required String userId,
  });
  Future<Either<Failure, SaleEntity>> getSaleById(String id);
  Future<Either<Failure, List<SaleEntity>>> getOpenSales();
  Future<Either<Failure, List<SaleEntity>>> getSalesByDate({required DateTime from, required DateTime to});
  Future<Either<Failure, List<SaleEntity>>> getReceiptsByDate({required DateTime from, required DateTime to});
  Future<Either<Failure, Unit>> cancelSale(String saleId);
  Stream<List<SaleEntity>> watchOpenSales();
  Future<Either<Failure, String>> generateTicketNumber();
  Future<int> migrateLegacyDevUserSales(String validUserId);
}

// ─── Implementación ───────────────────────────────────────────────────────────

class SaleRepositoryImpl implements SaleRepository {
  const SaleRepositoryImpl(this._db, this._deviceIdService);
  final AppDatabase _db;
  final DeviceIdService _deviceIdService;

  Future<SaleEntity> _buildEntity(SaleRow row) async {
    final items = await (_db.select(_db.saleItems)
          ..where((tbl) => tbl.saleId.equals(row.id)))
        .get();
    final payments = await (_db.select(_db.payments)
          ..where((tbl) => tbl.saleId.equals(row.id)))
        .get();

    String? employeeName;
    try {
      final user = await (_db.select(_db.users)
            ..where((tbl) => tbl.id.equals(row.userId)))
          .getSingleOrNull();
      employeeName = user?.fullName;
    } catch (_) {}

    final tpvName = await _deviceIdService.getTpvName();

    return SaleEntity(
      id: row.id,
      ticketNumber: row.ticketNumber,
      ticketLabel: row.ticketLabel,
      customerId: row.customerId,
      userId: row.userId,
      employeeName: employeeName,
      cashRegisterId: row.cashRegisterId,
      tpvName: tpvName,
      status: row.status,
      subtotal: row.subtotal,
      discountTotal: row.discountTotal,
      taxTotal: row.taxTotal,
      total: row.total,
      changeGiven: row.changeGiven,
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      paidAt: row.paidAt,
      items: items,
      payments: payments,
    );
  }

  @override
  Future<Either<Failure, String>> generateTicketNumber() async {
    try {
      // 1) Device code: últimos 3 caracteres del activation_code del TPV.
      final activationCode = await _deviceIdService.getActivationCode();
      final deviceCode = (activationCode != null && activationCode.length >= 3)
          ? activationCode.substring(activationCode.length - 3).toUpperCase()
          : null;

      // 2) Fecha: YYMM.
      final now = DateTime.now();
      final yymm =
          '${(now.year % 100).toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}';

      // 3) Secuencia diaria: se almacena en AppSettings y se incrementa.
      final seqKey = 'ticket_seq_${now.year}${now.month}${now.day}';
      final existing = await (_db.select(_db.appSettings)
            ..where((tbl) => tbl.key.equals(seqKey)))
          .getSingleOrNull();
      final currentSeq = existing != null ? (int.tryParse(existing.value) ?? 0) : 0;
      final nextSeq = currentSeq + 1;
      await _db.into(_db.appSettings).insert(
            AppSettingsCompanion.insert(
              key: seqKey,
              value: nextSeq.toString(),
            ),
            mode: InsertMode.insertOrReplace,
          );

      final seq = nextSeq.toString().padLeft(4, '0');

      if (deviceCode != null) {
        return Right('$deviceCode-$yymm-$seq');
      }

      // Fallback: sin TPV vinculado, usar formato genérico.
      return Right('POS-$yymm-$seq');
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> createOpenSale(
      CartState cart, String userId, String? cashRegisterId) async {
    if (!_isValidUserId(userId)) {
      return const Left(ValidationFailure(
        'La sesión del empleado no es válida. Inicie sesión nuevamente.',
      ));
    }
    try {
      final ticketResult = await generateTicketNumber();
      final ticketNumber = ticketResult.getOrElse((_) => const Uuid().v4().substring(0, 6));
      final saleId = const Uuid().v4();

      await _db.transaction(() async {
        await _db.into(_db.sales).insert(SalesCompanion.insert(
          id: Value(saleId),
          ticketNumber: ticketNumber,
          ticketLabel: Value(cart.openSaleLabel),
          customerId: Value(cart.customer?.id),
          userId: userId,
          cashRegisterId: Value(cashRegisterId),
          status: Value(SaleStatus.open),
          subtotal: Value(cart.subtotal),
          discountTotal: Value(cart.discountTotal),
          taxTotal: Value(cart.taxTotal),
          total: Value(cart.total),
          changeGiven: Value(0),
          note: Value(cart.note),
        ));
        await _insertItems(saleId, cart.items);
      });

      final row = await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(saleId))).getSingle();
      return Right(await _buildEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> updateOpenSale(String saleId, CartState cart) async {
    try {
      await _db.transaction(() async {
        await (_db.update(_db.sales)..where((tbl) => tbl.id.equals(saleId))).write(
          SalesCompanion(
            customerId: Value(cart.customer?.id),
            ticketLabel: Value(cart.openSaleLabel),
            subtotal: Value(cart.subtotal),
            discountTotal: Value(cart.discountTotal),
            taxTotal: Value(cart.taxTotal),
            total: Value(cart.total),
            note: Value(cart.note),
            updatedAt: Value(DateTime.now()),
          ),
        );
        // Re-insertar ítems (delete + insert)
        await (_db.delete(_db.saleItems)..where((tbl) => tbl.saleId.equals(saleId))).go();
        await _insertItems(saleId, cart.items);
      });
      final row = await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(saleId))).getSingle();
      return Right(await _buildEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> completeSale({
    required String saleId,
    required CartState cart,
    required List<({PaymentMethod method, double amount, String? reference})> payments,
    required double changeGiven,
    required String userId,
  }) async {
    if (!_isValidUserId(userId)) {
      return const Left(ValidationFailure(
        'La sesión del empleado no es válida. Inicie sesión nuevamente.',
      ));
    }
    try {
      await _db.transaction(() async {
        final now = DateTime.now();
        await (_db.update(_db.sales)..where((tbl) => tbl.id.equals(saleId))).write(
          SalesCompanion(
            customerId: Value(cart.customer?.id),
            status: const Value(SaleStatus.paid),
            subtotal: Value(cart.subtotal),
            discountTotal: Value(cart.discountTotal),
            taxTotal: Value(cart.taxTotal),
            total: Value(cart.total),
            changeGiven: Value(changeGiven),
            note: Value(cart.note),
            updatedAt: Value(now),
            paidAt: Value(now),
          ),
        );
        // Ítems actualizados
        await (_db.delete(_db.saleItems)..where((tbl) => tbl.saleId.equals(saleId))).go();
        await _insertItems(saleId, cart.items);

        // Registrar pagos
        for (final p in payments) {
          await _db.into(_db.payments).insert(PaymentsCompanion.insert(
            id: Value(const Uuid().v4()),
            saleId: saleId,
            method: p.method,
            amount: p.amount,
            reference: Value(p.reference),
          ));
        }
      });
      final row = await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(saleId))).getSingle();
      await _enqueueSale(saleId);
      return Right(await _buildEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  /// Encola el snapshot completo de la venta (cabecera + ítems + pagos) en la
  /// cola offline para subirlo a Supabase cuando haya conectividad.
  Future<void> _enqueueSale(String saleId) async {
    debugPrint('[SYNC_QUEUE] _enqueueSale started for sale: $saleId');
    final saleRow =
        await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(saleId))).getSingle();
    final items = await (_db.select(_db.saleItems)
          ..where((tbl) => tbl.saleId.equals(saleId)))
        .get();
    final payments = await (_db.select(_db.payments)
          ..where((tbl) => tbl.saleId.equals(saleId)))
        .get();
    debugPrint('[SYNC_QUEUE] sale queued: $saleId (items=${items.length}, payments=${payments.length})');
    await SyncQueueService(_db).enqueueSale(
      sale: SyncSerializers.sale(saleRow),
      items: items.map((e) => SyncSerializers.saleItem(e)).toList(),
      payments: payments.map((e) => SyncSerializers.payment(e)).toList(),
    );
    debugPrint('[SYNC_QUEUE] _enqueueSale completed for sale: $saleId');
  }

  /// Devuelve `true` si [userId] es `null`/vacío o un UUID válido.
  /// Un empleado es obligatorio para crear ventas sincronizables, por lo que
  /// un string no vacío que no sea UUID se rechaza.
  bool _isValidUserId(String? userId) {
    return Validators.isValidUuid(userId, allowEmpty: true);
  }

  /// Migra ventas locales creadas con IDs de desarrollo no UUID (p. ej.
  /// 'dev-001') al [validUserId] del empleado autenticado.
  /// Solo toca ventas cuyo user_id no sea UUID; no modifica ventas ya
  /// sincronizadas ni ventas de otros empleados reales.
  @override
  Future<int> migrateLegacyDevUserSales(String validUserId) async {
    if (!Validators.isValidUuid(validUserId)) return 0;
    final allSales = await _db.select(_db.sales).get();
    int migrated = 0;
    for (final sale in allSales) {
      if (Validators.isValidUuid(sale.userId)) continue;
      await (_db.update(_db.sales)..where((tbl) => tbl.id.equals(sale.id))).write(
        SalesCompanion(
          userId: Value(validUserId),
          updatedAt: Value(DateTime.now()),
        ),
      );
      migrated++;
    }
    return migrated;
  }

  Future<void> _insertItems(String saleId, List<CartItemEntity> items) async {
    for (final item in items) {
      await _db.into(_db.saleItems).insert(SaleItemsCompanion.insert(
        id: Value(const Uuid().v4()),
        saleId: saleId,
        productId: item.product.id,
        variantId: Value(item.variant?.id),
        productNameSnapshot: item.displayName,
        unitPrice: item.unitPrice,
        quantity: item.quantity,
        discount: Value(item.discount),
        taxRate: Value(item.taxRate),
        lineTotal: item.lineTotal,
        note: Value(item.note),
      ));
    }
  }

  @override
  Future<Either<Failure, SaleEntity>> getSaleById(String id) async {
    try {
      final row = await (_db.select(_db.sales)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (row == null) return const Left(NotFoundFailure('Venta no encontrada.'));
      return Right(await _buildEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaleEntity>>> getOpenSales() async {
    try {
      final rows = await (_db.select(_db.sales)
            ..where((tbl) => tbl.status.equalsValue(SaleStatus.open))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
          .get();
      return Right(await Future.wait(rows.map(_buildEntity)));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaleEntity>>> getSalesByDate({required DateTime from, required DateTime to}) async {
    try {
      final rows = await (_db.select(_db.sales)
            ..where((tbl) =>
                tbl.createdAt.isBiggerOrEqualValue(from) &
                tbl.createdAt.isSmallerOrEqualValue(to) &
                tbl.status.equalsValue(SaleStatus.paid))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
          .get();
      return Right(await Future.wait(rows.map(_buildEntity)));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SaleEntity>>> getReceiptsByDate({required DateTime from, required DateTime to}) async {
    try {
      final rows = await (_db.select(_db.sales)
            ..where((tbl) =>
                tbl.createdAt.isBiggerOrEqualValue(from) &
                tbl.createdAt.isSmallerOrEqualValue(to) &
                tbl.status
                    .isInValues([SaleStatus.paid, SaleStatus.cancelled, SaleStatus.refunded]))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
          .get();
      return Right(await Future.wait(rows.map(_buildEntity)));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelSale(String saleId) async {
    try {
      await (_db.update(_db.sales)..where((tbl) => tbl.id.equals(saleId))).write(
        SalesCompanion(
          status: const Value(SaleStatus.cancelled),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<List<SaleEntity>> watchOpenSales() {
    return (_db.select(_db.sales)
          ..where((tbl) => tbl.status.equalsValue(SaleStatus.open))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch()
        .asyncMap((rows) => Future.wait(rows.map(_buildEntity)));
  }
}
