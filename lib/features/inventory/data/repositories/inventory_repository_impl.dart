import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/inventory_tables.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

// ─── Mapper ───────────────────────────────────────────────────────────────────

extension InventoryMovementMapper on InventoryMovementRow {
  InventoryMovementEntity toEntity({String? productName, String? userName}) =>
      InventoryMovementEntity(
        id: id,
        productId: productId,
        variantId: variantId,
        type: InventoryMovementTypeEntity.values[type.index],
        quantity: quantity,
        stockBefore: stockBefore,
        stockAfter: stockAfter,
        reason: reason,
        referenceId: referenceId,
        userId: userId,
        createdAt: createdAt,
        productName: productName,
        userName: userName,
      );
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

class InventoryRepositoryImpl implements InventoryRepository {
  const InventoryRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<Either<Failure, InventoryMovementEntity>> registerMovement({
    required String productId,
    String? variantId,
    required InventoryMovementTypeEntity type,
    required double quantity,
    required String userId,
    String? reason,
    String? referenceId,
  }) async {
    try {
      // Leer stock actual
      final productRow = await (_db.select(_db.products)
            ..where((tbl) => tbl.id.equals(productId)))
          .getSingleOrNull();
      if (productRow == null) {
        return const Left(NotFoundFailure('Producto no encontrado.'));
      }

      final double stockBefore = variantId != null
          ? (await (_db.select(_db.productVariants)
                        ..where((tbl) => tbl.id.equals(variantId)))
                      .getSingleOrNull())
                  ?.stockQuantity ??
              0
          : productRow.stockQuantity;

      final double delta = type.isPositive ? quantity : -quantity;
      final double stockAfter = stockBefore + delta;

      // Actualizar stock
      if (variantId != null) {
        await (_db.update(_db.productVariants)
              ..where((tbl) => tbl.id.equals(variantId)))
            .write(ProductVariantsCompanion(
          stockQuantity: Value(stockAfter),
        ));
      } else {
        await (_db.update(_db.products)
              ..where((tbl) => tbl.id.equals(productId)))
            .write(ProductsCompanion(
          stockQuantity: Value(stockAfter),
          updatedAt: Value(DateTime.now()),
        ));
      }

      // Registrar movimiento
      final id = const Uuid().v4();
      await _db.into(_db.inventoryMovements).insert(
            InventoryMovementsCompanion.insert(
              id: Value(id),
              productId: productId,
              variantId: Value(variantId),
              type: InventoryMovementType.values[type.index],
              quantity: quantity,
              stockBefore: stockBefore,
              stockAfter: stockAfter,
              reason: Value(reason),
              referenceId: Value(referenceId),
              userId: userId,
            ),
          );

      final row = await (_db.select(_db.inventoryMovements)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingle();
      // Encolar el movimiento para el push.
      await SyncQueueService(_db)
          .enqueueInventoryMovement(SyncSerializers.inventoryMovement(row));
      return Right(row.toEntity(productName: productRow.name));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventoryMovementEntity>>> getKardex({
    required String productId,
    String? variantId,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final query = _db.select(_db.inventoryMovements);
      query.where((tbl) {
        Expression<bool> cond = tbl.productId.equals(productId);
        if (variantId != null) {
          cond = cond & tbl.variantId.equals(variantId);
        }
        if (from != null) {
          cond = cond & tbl.createdAt.isBiggerOrEqualValue(from);
        }
        if (to != null) {
          cond = cond & tbl.createdAt.isSmallerOrEqualValue(to);
        }
        return cond;
      });
      query.orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
      final rows = await query.get();

      final productRow = await (_db.select(_db.products)
            ..where((tbl) => tbl.id.equals(productId)))
          .getSingleOrNull();

      return Right(
        rows.map((r) => r.toEntity(productName: productRow?.name)).toList(),
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventoryMovementEntity>>> getRecentMovements({
    int limit = 50,
    DateTime? from,
  }) async {
    try {
      final query = _db.select(_db.inventoryMovements);
      if (from != null) {
        query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(from));
      }
      query
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(limit);
      final rows = await query.get();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<List<InventoryMovementEntity>> watchRecentMovements({int limit = 30}) {
    return (_db.select(_db.inventoryMovements)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }
}
