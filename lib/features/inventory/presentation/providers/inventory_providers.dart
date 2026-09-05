import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepositoryImpl(ref.watch(appDatabaseProvider)) as InventoryRepository,
);

final Provider<RegisterInventoryMovementUseCase>
    registerInventoryMovementUseCaseProvider =
    Provider((ref) => RegisterInventoryMovementUseCase(
        ref.watch(inventoryRepositoryProvider)));

final Provider<GetKardexUseCase> getKardexUseCaseProvider =
    Provider((ref) => GetKardexUseCase(ref.watch(inventoryRepositoryProvider)));

final Provider<GetRecentMovementsUseCase> getRecentMovementsUseCaseProvider =
    Provider((ref) =>
        GetRecentMovementsUseCase(ref.watch(inventoryRepositoryProvider)));

/// Stream de movimientos recientes, usado en dashboard e inventario.
final StreamProvider<List<InventoryMovementEntity>> recentMovementsStreamProvider =
    StreamProvider<List<InventoryMovementEntity>>((ref) {
  return ref.watch(inventoryRepositoryProvider).watchRecentMovements();
});

/// Kardex de un producto específico.
final FutureProviderFamily<List<InventoryMovementEntity>, String>
    productKardexProvider =
    FutureProviderFamily<List<InventoryMovementEntity>, String>(
        (ref, productId) async {
  final result = await ref
      .watch(getKardexUseCaseProvider)
      .call(GetKardexParams(productId: productId));
  return result.fold((_) => [], (list) => list);
});
