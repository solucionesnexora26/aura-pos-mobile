import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/sync_queue_service.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._dataSource);
  final ProductLocalDataSource _dataSource;

  // ── Helpers ───────────────────────────────────────────────────────────────

  SyncQueueService get _queue => SyncQueueService(_dataSource.db);

  /// Encola el snapshot del producto (y sus variantes) para el push.
  Future<void> _enqueueProduct(String productId) async {
    final row = await _dataSource.getProductById(productId);
    await _queue.enqueueCatalog('products', SyncSerializers.product(row));
    final variants = await _dataSource.getVariantsByProduct(productId);
    for (final v in variants) {
      await _queue.enqueueCatalog(
        'product_variants',
        SyncSerializers.productVariant(v),
      );
    }
  }

  Future<ProductEntity> _enrichProduct(ProductRow row) async {
    final variants = await _dataSource.getVariantsByProduct(row.id);
    CategoryEntity? category;
    BrandEntity? brand;
    SupplierEntity? supplier;
    if (row.categoryId != null) {
      final cats = await _dataSource.getCategories(onlyActive: false);
      category =
          cats.where((c) => c.id == row.categoryId).firstOrNull?.toEntity();
    }
    if (row.brandId != null) {
      final brands = await _dataSource.getBrands();
      brand = brands.where((b) => b.id == row.brandId).firstOrNull?.toEntity();
    }
    if (row.supplierId != null) {
      final suppliers = await _dataSource.getSuppliers(onlyActive: false);
      supplier = suppliers
          .where((s) => s.id == row.supplierId)
          .firstOrNull
          ?.toEntity();
    }
    return row.toEntity(
      category: category,
      brand: brand,
      supplier: supplier,
      variants: variants.map((v) => v.toEntity()).toList(),
    );
  }

  // ── Productos ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? categoryId,
    String? searchQuery,
    bool onlyFavorites = false,
    bool onlyActive = true,
  }) async {
    try {
      final rows = await _dataSource.getProducts(
        categoryId: categoryId,
        searchQuery: searchQuery,
        onlyFavorites: onlyFavorites,
        onlyActive: onlyActive,
      );
      final products = await Future.wait(rows.map(_enrichProduct));
      return Right(products);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final row = await _dataSource.getProductById(id);
      return Right(await _enrichProduct(row));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity?>> getProductByBarcode(
      String barcode) async {
    try {
      final row = await _dataSource.getProductByBarcode(barcode);
      if (row == null) return const Right(null);
      return Right(await _enrichProduct(row));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(
      ProductEntity product) async {
    try {
      final id = const Uuid().v4();
      final companion = product
          .copyWith(
              id: id, createdAt: DateTime.now(), updatedAt: DateTime.now())
          .toCompanion();
      final row = await _dataSource.insertProduct(companion);
      // Insertar variantes si las hay
      for (final variant in product.variants) {
        await _dataSource.insertVariant(
          variant.copyWith(id: const Uuid().v4(), productId: id).toCompanion(),
        );
      }
      await _enqueueProduct(id);
      return Right(await _enrichProduct(row));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
      ProductEntity product) async {
    try {
      final row =
          await _dataSource.updateProduct(product.id, product.toCompanion());
      await _enqueueProduct(product.id);
      return Right(await _enrichProduct(row));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      await _dataSource.db.transaction(() async {
        await _dataSource.deleteProduct(id);
        await _queue.enqueueDelete('products', id);
      });
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String productId) async {
    try {
      await _dataSource.toggleFavorite(productId);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStock(
      String productId, double newQuantity,
      {String? variantId}) async {
    try {
      await _dataSource.updateStock(productId, newQuantity,
          variantId: variantId);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ── Categorías ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
      {bool onlyActive = true}) async {
    try {
      final rows = await _dataSource.getCategories(onlyActive: onlyActive);
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(
      CategoryEntity category) async {
    try {
      final companion = category.copyWith(id: const Uuid().v4()).toCompanion();
      final row = await _dataSource.insertCategory(companion);
      await _queue.enqueueCatalog('categories', SyncSerializers.category(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(
      CategoryEntity category) async {
    try {
      final companion = category.toCompanion();
      final row = await _dataSource.updateCategory(category.id, companion);
      await _queue.enqueueCatalog('categories', SyncSerializers.category(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await _dataSource.deleteCategory(id);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ── Marcas ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands() async {
    try {
      final rows = await _dataSource.getBrands();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BrandEntity>> createBrand(BrandEntity brand) async {
    try {
      final companion = BrandsCompanion.insert(
        id: Value(const Uuid().v4()),
        name: brand.name,
      );
      final row = await _dataSource.insertBrand(companion);
      await _queue.enqueueCatalog('brands', SyncSerializers.brand(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ── Proveedores ───────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<SupplierEntity>>> getSuppliers(
      {bool onlyActive = true}) async {
    try {
      final rows = await _dataSource.getSuppliers(onlyActive: onlyActive);
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> createSupplier(
      SupplierEntity s) async {
    try {
      final companion = SuppliersCompanion.insert(
        id: Value(const Uuid().v4()),
        name: s.name,
        contactName: Value(s.contactName),
        phone: Value(s.phone),
        email: Value(s.email),
        address: Value(s.address),
        isActive: Value(s.isActive),
      );
      final row = await _dataSource.insertSupplier(companion);
      await _queue.enqueueCatalog('suppliers', SyncSerializers.supplier(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> updateSupplier(
      SupplierEntity s) async {
    try {
      final companion = SuppliersCompanion(
        name: Value(s.name),
        contactName: Value(s.contactName),
        phone: Value(s.phone),
        email: Value(s.email),
        address: Value(s.address),
        isActive: Value(s.isActive),
      );
      final row = await _dataSource.updateSupplier(s.id, companion);
      await _queue.enqueueCatalog('suppliers', SyncSerializers.supplier(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ── Variantes ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ProductVariantEntity>>> getVariantsByProduct(
      String productId) async {
    try {
      final rows = await _dataSource.getVariantsByProduct(productId);
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductVariantEntity>> createVariant(
      ProductVariantEntity variant) async {
    try {
      final row = await _dataSource.insertVariant(
        variant.copyWith(id: const Uuid().v4()).toCompanion(),
      );
      await _queue.enqueueCatalog(
          'product_variants', SyncSerializers.productVariant(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductVariantEntity>> updateVariant(
      ProductVariantEntity variant) async {
    try {
      final row =
          await _dataSource.updateVariant(variant.id, variant.toCompanion());
      await _queue.enqueueCatalog(
          'product_variants', SyncSerializers.productVariant(row));
      return Right(row.toEntity());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVariant(String variantId) async {
    try {
      await _dataSource.deleteVariant(variantId);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ── Streams ───────────────────────────────────────────────────────────────

  @override
  Stream<List<ProductEntity>> watchProducts(
      {String? categoryId, String? searchQuery}) {
    return _dataSource
        .watchProducts(categoryId: categoryId, searchQuery: searchQuery)
        .asyncMap((rows) => Future.wait(rows.map(_enrichProduct)));
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return _dataSource
        .watchCategories()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }
}
