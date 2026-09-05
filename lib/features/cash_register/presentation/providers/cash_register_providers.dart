import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/cash_register_tables.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/sync_push_service.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../../../core/sync/sync_serializers.dart';

// ─── Entidades ────────────────────────────────────────────────────────────────

class CashRegisterEntity {
  const CashRegisterEntity({
    required this.id,
    required this.userId,
    this.shiftLabel,
    required this.openingAmount,
    this.expectedClosingAmount,
    this.countedClosingAmount,
    this.difference,
    required this.status,
    required this.openedAt,
    this.closedAt,
    this.note,
    this.movements = const [],
  });

  final String id;
  final String userId;
  final String? shiftLabel;
  final double openingAmount;
  final double? expectedClosingAmount;
  final double? countedClosingAmount;
  final double? difference;
  final CashRegisterStatus status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? note;
  final List<CashMovementRow> movements;

  bool get isOpen => status == CashRegisterStatus.open;
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

class CashRegisterRepositoryImpl {
  const CashRegisterRepositoryImpl(this._db, {SyncPushService? pushService})
      : _pushService = pushService;
  final AppDatabase _db;
  final SyncPushService? _pushService;

  Future<Either<Failure, CashRegisterEntity>> openRegister({
    required String userId,
    required double openingAmount,
    String? shiftLabel,
  }) async {
    try {
      // Verificar que no haya ya una caja abierta (prevenir duplicados).
      final existing = await (_db.select(_db.cashRegisters)
            ..where((tbl) => tbl.status.equalsValue(CashRegisterStatus.open))
            ..limit(1))
          .getSingleOrNull();
      if (existing != null) {
        return const Left(UnexpectedFailure('Ya existe una caja abierta. Ciérla antes de abrir otra.'));
      }

      final id = const Uuid().v4();
      // Transacción atómica: caja + movimiento inicial juntos.
      await _db.transaction(() async {
        await _db.into(_db.cashRegisters).insert(
              CashRegistersCompanion.insert(
                id: Value(id),
                userId: userId,
                shiftLabel: Value(shiftLabel),
                openingAmount: openingAmount,
                status: const Value(CashRegisterStatus.open),
              ),
            );
        await _db.into(_db.cashMovements).insert(
              CashMovementsCompanion.insert(
                id: Value(const Uuid().v4()),
                cashRegisterId: id,
                type: CashMovementType.openingFloat,
                amount: openingAmount,
                description: const Value('Monto inicial de apertura'),
                userId: userId,
              ),
            );
      });

      final row = await (_db.select(_db.cashRegisters)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();
      await SyncQueueService(_db).enqueueCashRegister(
        register: SyncSerializers.cashRegister(row),
        movements: (await _getMovements(id)).map((e) => SyncSerializers.cashMovement(e)).toList(),
      );
      unawaited(_pushService?.pushAll().catchError((Object e) {
        debugPrint('[CASH_REGISTER] immediate push after open failed: $e');
      }));
      return Right(_rowToEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, CashRegisterEntity>> closeRegister({
    required String registerId,
    required double countedAmount,
    required double expectedAmount,
    String? note,
  }) async {
    try {
      // Verificar que la caja esté abierta (prevenir cierre doble).
      final existing = await (_db.select(_db.cashRegisters)
            ..where((tbl) => tbl.id.equals(registerId)))
          .getSingleOrNull();
      if (existing == null) {
        return const Left(NotFoundFailure('Caja no encontrada.'));
      }
      if (existing.status == CashRegisterStatus.closed) {
        return const Left(UnexpectedFailure('Esta caja ya fue cerrada.'));
      }

      final diff = countedAmount - expectedAmount;
      await (_db.update(_db.cashRegisters)
            ..where((tbl) => tbl.id.equals(registerId)))
          .write(CashRegistersCompanion(
        status: const Value(CashRegisterStatus.closed),
        expectedClosingAmount: Value(expectedAmount),
        countedClosingAmount: Value(countedAmount),
        difference: Value(diff),
        closedAt: Value(DateTime.now()),
        note: Value(note),
      ));
      final row = await (_db.select(_db.cashRegisters)
            ..where((tbl) => tbl.id.equals(registerId)))
          .getSingle();
      await SyncQueueService(_db).enqueueCashRegister(
        register: SyncSerializers.cashRegister(row),
      );
      unawaited(_pushService?.pushAll().catchError((Object e) {
        debugPrint('[CASH_REGISTER] immediate push after close failed: $e');
      }));
      return Right(_rowToEntity(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, CashRegisterEntity?>> getOpenRegister() async {
    try {
      final row = await (_db.select(_db.cashRegisters)
            ..where((tbl) => tbl.status.equalsValue(CashRegisterStatus.open))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.openedAt)])
            ..limit(1))
          .getSingleOrNull();
      if (row == null) return const Right(null);
      final movements = await _getMovements(row.id);
      return Right(_rowToEntity(row, movements: movements));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> addMovement({
    required String registerId,
    required CashMovementType type,
    required double amount,
    required String userId,
    String? description,
    String? saleId,
    int? method,
  }) async {
    try {
      // Verificar que la caja esté abierta antes de agregar movimiento.
      final register = await (_db.select(_db.cashRegisters)
            ..where((tbl) => tbl.id.equals(registerId)))
          .getSingleOrNull();
      if (register == null) {
        return const Left(NotFoundFailure('Caja no encontrada.'));
      }
      if (register.status == CashRegisterStatus.closed) {
        return const Left(UnexpectedFailure('No se pueden agregar movimientos a una caja cerrada.'));
      }

      final movementId = const Uuid().v4();
      await _db.into(_db.cashMovements).insert(
            CashMovementsCompanion.insert(
              id: Value(movementId),
              cashRegisterId: registerId,
              saleId: Value(saleId),
              type: type,
              amount: amount,
              method: Value(method),
              description: Value(description),
              userId: userId,
            ),
          );
      final movementRow = await (_db.select(_db.cashMovements)
            ..where((tbl) => tbl.id.equals(movementId)))
          .getSingle();
      await SyncQueueService(_db).enqueueCashMovement(
        SyncSerializers.cashMovement(movementRow),
      );
      // Push inmediato para que la web refleje el movimiento al instante.
      unawaited(_pushService?.pushAll().catchError((Object e) {
        debugPrint('[CASH_REGISTER] immediate push after addMovement failed: $e');
      }));
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<List<CashMovementRow>> _getMovements(String registerId) async {
    return (_db.select(_db.cashMovements)
          ..where((tbl) => tbl.cashRegisterId.equals(registerId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<Either<Failure, List<CashRegisterEntity>>> getHistory({int limit = 30}) async {
    try {
      final rows = await (_db.select(_db.cashRegisters)
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.openedAt)])
            ..limit(limit))
          .get();
      final entities = await Future.wait(
        rows.map((r) async => _rowToEntity(r, movements: await _getMovements(r.id))),
      );
      return Right(entities);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Stream<CashRegisterEntity?> watchOpenRegister() {
    return (_db.select(_db.cashRegisters)
          ..where((tbl) => tbl.status.equalsValue(CashRegisterStatus.open))
          ..limit(1))
        .watch()
        .asyncMap((rows) async {
      if (rows.isEmpty) return null;
      final movements = await _getMovements(rows.first.id);
      return _rowToEntity(rows.first, movements: movements);
    });
  }

  CashRegisterEntity _rowToEntity(CashRegisterRow row,
      {List<CashMovementRow> movements = const []}) =>
      CashRegisterEntity(
        id: row.id,
        userId: row.userId,
        shiftLabel: row.shiftLabel,
        openingAmount: row.openingAmount,
        expectedClosingAmount: row.expectedClosingAmount,
        countedClosingAmount: row.countedClosingAmount,
        difference: row.difference,
        status: row.status,
        openedAt: row.openedAt,
        closedAt: row.closedAt,
        note: row.note,
        movements: movements,
      );
}

// ─── Providers ────────────────────────────────────────────────────────────────

final Provider<CashRegisterRepositoryImpl> cashRegisterRepositoryProvider =
    Provider<CashRegisterRepositoryImpl>((ref) => CashRegisterRepositoryImpl(
          ref.watch(appDatabaseProvider),
          pushService: ref.watch(syncPushServiceProvider),
        ));

final StreamProvider<CashRegisterEntity?> openCashRegisterProvider =
    StreamProvider<CashRegisterEntity?>((ref) {
  return ref.watch(cashRegisterRepositoryProvider).watchOpenRegister();
});

final FutureProvider<List<CashRegisterEntity>> cashRegisterHistoryProvider =
    FutureProvider<List<CashRegisterEntity>>((ref) async {
  final result = await ref.watch(cashRegisterRepositoryProvider).getHistory();
  return result.fold((_) => [], (list) => list);
});
