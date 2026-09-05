import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/inventory_entity.dart';

// ─── Repositorio ──────────────────────────────────────────────────────────────

abstract interface class InventoryRepository {
  Future<Either<Failure, InventoryMovementEntity>> registerMovement({
    required String productId,
    String? variantId,
    required InventoryMovementTypeEntity type,
    required double quantity,
    required String userId,
    String? reason,
    String? referenceId,
  });

  Future<Either<Failure, List<InventoryMovementEntity>>> getKardex({
    required String productId,
    String? variantId,
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, List<InventoryMovementEntity>>> getRecentMovements({
    int limit = 50,
    DateTime? from,
  });

  Stream<List<InventoryMovementEntity>> watchRecentMovements({int limit = 30});
}

// ─── Params ───────────────────────────────────────────────────────────────────

class RegisterMovementParams {
  const RegisterMovementParams({
    required this.productId,
    required this.type,
    required this.quantity,
    required this.userId,
    this.variantId,
    this.reason,
    this.referenceId,
  });
  final String productId;
  final String? variantId;
  final InventoryMovementTypeEntity type;
  final double quantity;
  final String userId;
  final String? reason;
  final String? referenceId;
}

class GetKardexParams {
  const GetKardexParams({
    required this.productId,
    this.variantId,
    this.from,
    this.to,
  });
  final String productId;
  final String? variantId;
  final DateTime? from;
  final DateTime? to;
}

// ─── UseCases ─────────────────────────────────────────────────────────────────

class RegisterInventoryMovementUseCase
    implements UseCase<InventoryMovementEntity, RegisterMovementParams> {
  const RegisterInventoryMovementUseCase(this._repo);
  final InventoryRepository _repo;

  @override
  Future<Either<Failure, InventoryMovementEntity>> call(
      RegisterMovementParams params) async {
    if (params.quantity <= 0) {
      return const Left(ValidationFailure('La cantidad debe ser mayor a cero.'));
    }
    return _repo.registerMovement(
      productId: params.productId,
      variantId: params.variantId,
      type: params.type,
      quantity: params.quantity,
      userId: params.userId,
      reason: params.reason,
      referenceId: params.referenceId,
    );
  }
}

class GetKardexUseCase
    implements UseCase<List<InventoryMovementEntity>, GetKardexParams> {
  const GetKardexUseCase(this._repo);
  final InventoryRepository _repo;

  @override
  Future<Either<Failure, List<InventoryMovementEntity>>> call(
      GetKardexParams params) {
    return _repo.getKardex(
      productId: params.productId,
      variantId: params.variantId,
      from: params.from,
      to: params.to,
    );
  }
}

class GetRecentMovementsUseCase
    implements UseCase<List<InventoryMovementEntity>, NoParams> {
  const GetRecentMovementsUseCase(this._repo);
  final InventoryRepository _repo;

  @override
  Future<Either<Failure, List<InventoryMovementEntity>>> call(NoParams params) {
    return _repo.getRecentMovements();
  }
}
