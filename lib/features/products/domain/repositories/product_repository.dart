import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

abstract interface class ProductRepository {
  // ── Productos ──────────────────────────────────────────────────────────────
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? categoryId,
    String? searchQuery,
    bool onlyFavorites = false,
    bool onlyActive = true,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(String barcode);
  Future<Either<Failure, ProductEntity>> createProduct(ProductEntity product);
  Future<Either<Failure, ProductEntity>> updateProduct(ProductEntity product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
  Future<Either<Failure, Unit>> toggleFavorite(String productId);
  Future<Either<Failure, Unit>> updateStock(String productId, double newQuantity, {String? variantId});

  // ── Categorías ─────────────────────────────────────────────────────────────
  Future<Either<Failure, List<CategoryEntity>>> getCategories({bool onlyActive = true});
  Future<Either<Failure, CategoryEntity>> createCategory(CategoryEntity category);
  Future<Either<Failure, CategoryEntity>> updateCategory(CategoryEntity category);
  Future<Either<Failure, Unit>> deleteCategory(String id);

  // ── Marcas ─────────────────────────────────────────────────────────────────
  Future<Either<Failure, List<BrandEntity>>> getBrands();
  Future<Either<Failure, BrandEntity>> createBrand(BrandEntity brand);

  // ── Proveedores ────────────────────────────────────────────────────────────
  Future<Either<Failure, List<SupplierEntity>>> getSuppliers({bool onlyActive = true});
  Future<Either<Failure, SupplierEntity>> createSupplier(SupplierEntity supplier);
  Future<Either<Failure, SupplierEntity>> updateSupplier(SupplierEntity supplier);

  // ── Variantes ──────────────────────────────────────────────────────────────
  Future<Either<Failure, List<ProductVariantEntity>>> getVariantsByProduct(String productId);
  Future<Either<Failure, ProductVariantEntity>> createVariant(ProductVariantEntity variant);
  Future<Either<Failure, ProductVariantEntity>> updateVariant(ProductVariantEntity variant);
  Future<Either<Failure, Unit>> deleteVariant(String variantId);

  /// Stream reactivo para actualizar la UI en tiempo real cuando cambia el stock.
  Stream<List<ProductEntity>> watchProducts({String? categoryId, String? searchQuery});
  Stream<List<CategoryEntity>> watchCategories();
}
