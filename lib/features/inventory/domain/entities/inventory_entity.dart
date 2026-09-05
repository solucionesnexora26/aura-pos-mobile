import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_entity.freezed.dart';

enum InventoryMovementTypeEntity {
  entry,
  exit,
  adjustment,
  transfer,
  saleDeduction,
  saleReturn,
}

extension InventoryMovementTypeEntityX on InventoryMovementTypeEntity {
  String get label => switch (this) {
        InventoryMovementTypeEntity.entry => 'Entrada',
        InventoryMovementTypeEntity.exit => 'Salida',
        InventoryMovementTypeEntity.adjustment => 'Ajuste',
        InventoryMovementTypeEntity.transfer => 'Transferencia',
        InventoryMovementTypeEntity.saleDeduction => 'Venta',
        InventoryMovementTypeEntity.saleReturn => 'Devolución',
      };

  bool get isPositive =>
      this == InventoryMovementTypeEntity.entry ||
      this == InventoryMovementTypeEntity.saleReturn ||
      this == InventoryMovementTypeEntity.adjustment;
}

@freezed
class InventoryMovementEntity with _$InventoryMovementEntity {
  const factory InventoryMovementEntity({
    required String id,
    required String productId,
    String? variantId,
    required InventoryMovementTypeEntity type,
    required double quantity,
    required double stockBefore,
    required double stockAfter,
    String? reason,
    String? referenceId,
    required String userId,
    required DateTime createdAt,
    // Datos denormalizados para mostrar en el Kardex sin join
    String? productName,
    String? userName,
  }) = _InventoryMovementEntity;
}
