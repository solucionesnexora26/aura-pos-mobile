import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

enum ProductUnitTypeEntity { unit, weightKg, weightG, weightLb }

extension ProductUnitTypeEntityX on ProductUnitTypeEntity {
  String get label => switch (this) {
        ProductUnitTypeEntity.unit => 'Unidad',
        ProductUnitTypeEntity.weightKg => 'Peso (kg)',
        ProductUnitTypeEntity.weightG => 'Peso (g)',
        ProductUnitTypeEntity.weightLb => 'Peso (lb)',
      };

  bool get isByWeight =>
      this == ProductUnitTypeEntity.weightKg ||
      this == ProductUnitTypeEntity.weightG ||
      this == ProductUnitTypeEntity.weightLb;
}

@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required String colorHex,
    String? iconName,
    required int sortOrder,
    required bool isActive,
  }) = _CategoryEntity;
}

@freezed
class BrandEntity with _$BrandEntity {
  const factory BrandEntity({
    required String id,
    required String name,
  }) = _BrandEntity;
}

@freezed
class SupplierEntity with _$SupplierEntity {
  const factory SupplierEntity({
    required String id,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    required bool isActive,
  }) = _SupplierEntity;
}

@freezed
class ProductVariantEntity with _$ProductVariantEntity {
  const factory ProductVariantEntity({
    required String id,
    required String productId,
    required String name,
    String? sku,
    String? barcode,
    required double priceDelta,
    required double stockQuantity,
    required bool isActive,
  }) = _ProductVariantEntity;
}

@freezed
class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required String id,
    required String name,
    String? description,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? supplierId,
    required double price,
    required double cost,
    required double taxRate,
    required ProductUnitTypeEntity unitType,
    required bool trackStock,
    required double stockQuantity,
    required double lowStockThreshold,
    required bool hasVariants,
    required bool isFavorite,
    required bool isActive,
    String? imagePath,
    CategoryEntity? category,
    BrandEntity? brand,
    SupplierEntity? supplier,
    @Default([]) List<ProductVariantEntity> variants,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProductEntity;

  const ProductEntity._();

  bool get isLowStock => trackStock && stockQuantity <= lowStockThreshold;
  bool get isOutOfStock => trackStock && stockQuantity <= 0;

  /// Precio efectivo para una variante dada (o precio base si no hay).
  double priceForVariant(ProductVariantEntity? variant) =>
      price + (variant?.priceDelta ?? 0);
}
