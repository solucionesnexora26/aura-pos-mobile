import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/products_table.dart';
import '../../domain/entities/product_entity.dart';

extension CategoryMapper on CategoryRow {
  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        colorHex: colorHex,
        iconName: iconName,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

extension CategoryEntityMapper on CategoryEntity {
  CategoriesCompanion toCompanion() => CategoriesCompanion.insert(
        id: Value(id),
        name: name,
        colorHex: Value(colorHex),
        iconName: Value(iconName),
        sortOrder: Value(sortOrder),
        isActive: Value(isActive),
      );
}

extension BrandMapper on BrandRow {
  BrandEntity toEntity() => BrandEntity(id: id, name: name);
}

extension SupplierMapper on SupplierRow {
  SupplierEntity toEntity() => SupplierEntity(
        id: id,
        name: name,
        contactName: contactName,
        phone: phone,
        email: email,
        address: address,
        isActive: isActive,
      );
}

extension ProductVariantMapper on ProductVariantRow {
  ProductVariantEntity toEntity() => ProductVariantEntity(
        id: id,
        productId: productId,
        name: name,
        sku: sku,
        barcode: barcode,
        priceDelta: priceDelta,
        stockQuantity: stockQuantity,
        isActive: isActive,
      );
}

extension ProductMapper on ProductRow {
  ProductEntity toEntity({
    CategoryEntity? category,
    BrandEntity? brand,
    SupplierEntity? supplier,
    List<ProductVariantEntity> variants = const [],
  }) =>
      ProductEntity(
        id: id,
        name: name,
        description: description,
        sku: sku,
        barcode: barcode,
        categoryId: categoryId,
        brandId: brandId,
        supplierId: supplierId,
        price: price,
        cost: cost,
        taxRate: taxRate,
        unitType: ProductUnitTypeEntity.values[unitType.index],
        trackStock: trackStock,
        stockQuantity: stockQuantity,
        lowStockThreshold: lowStockThreshold,
        hasVariants: hasVariants,
        isFavorite: isFavorite,
        isActive: isActive,
        imagePath: imagePath,
        category: category,
        brand: brand,
        supplier: supplier,
        variants: variants,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension ProductEntityMapper on ProductEntity {
  ProductsCompanion toCompanion() => ProductsCompanion(
        id: Value(id),
        name: Value(name),
        description: Value(description),
        sku: Value(sku),
        barcode: Value(barcode),
        categoryId: Value(categoryId),
        brandId: Value(brandId),
        supplierId: Value(supplierId),
        price: Value(price),
        cost: Value(cost),
        taxRate: Value(taxRate),
        unitType: Value(ProductUnitType.values[unitType.index]),
        trackStock: Value(trackStock),
        stockQuantity: Value(stockQuantity),
        lowStockThreshold: Value(lowStockThreshold),
        hasVariants: Value(hasVariants),
        isFavorite: Value(isFavorite),
        isActive: Value(isActive),
        imagePath: Value(imagePath),
        updatedAt: Value(DateTime.now()),
      );
}

extension ProductVariantEntityMapper on ProductVariantEntity {
  ProductVariantsCompanion toCompanion() => ProductVariantsCompanion(
        id: Value(id),
        productId: Value(productId),
        name: Value(name),
        sku: Value(sku),
        barcode: Value(barcode),
        priceDelta: Value(priceDelta),
        stockQuantity: Value(stockQuantity),
        isActive: Value(isActive),
      );
}
