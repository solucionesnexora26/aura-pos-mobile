import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';

abstract interface class ProductLocalDataSource {
  /// Base de datos local, expuesta para que el repositorio encolle en la
  /// cola de sincronización las operaciones de catálogo.
  AppDatabase get db;

  Future<List<ProductRow>> getProducts({
    String? categoryId,
    String? searchQuery,
    bool onlyFavorites = false,
    bool onlyActive = true,
  });
  Future<ProductRow> getProductById(String id);
  Future<ProductRow?> getProductByBarcode(String barcode);
  Future<ProductRow> insertProduct(ProductsCompanion companion);
  Future<ProductRow> updateProduct(String id, ProductsCompanion companion);
  Future<void> deleteProduct(String id);
  Future<void> toggleFavorite(String productId);
  Future<void> updateStock(String productId, double newQty,
      {String? variantId});

  Future<List<CategoryRow>> getCategories({bool onlyActive = true});
  Future<CategoryRow> insertCategory(CategoriesCompanion companion);
  Future<CategoryRow> updateCategory(String id, CategoriesCompanion companion);
  Future<void> deleteCategory(String id);

  Future<List<BrandRow>> getBrands();
  Future<BrandRow> insertBrand(BrandsCompanion companion);

  Future<List<SupplierRow>> getSuppliers({bool onlyActive = true});
  Future<SupplierRow> insertSupplier(SuppliersCompanion companion);
  Future<SupplierRow> updateSupplier(String id, SuppliersCompanion companion);

  Future<List<ProductVariantRow>> getVariantsByProduct(String productId);
  Future<ProductVariantRow> insertVariant(ProductVariantsCompanion companion);
  Future<ProductVariantRow> updateVariant(
      String id, ProductVariantsCompanion companion);
  Future<void> deleteVariant(String variantId);

  Stream<List<ProductRow>> watchProducts(
      {String? categoryId, String? searchQuery});
  Stream<List<CategoryRow>> watchCategories();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  const ProductLocalDataSourceImpl(this._db);
  final AppDatabase _db;

  @override
  AppDatabase get db => _db;

  // ── Productos ─────────────────────────────────────────────────────────────

  @override
  Future<List<ProductRow>> getProducts({
    String? categoryId,
    String? searchQuery,
    bool onlyFavorites = false,
    bool onlyActive = true,
  }) async {
    final query = _db.select(_db.products);
    query.where((tbl) {
      Expression<bool> condition = const Constant(true);
      if (onlyActive) condition = condition & tbl.isActive.equals(true);
      if (categoryId != null)
        condition = condition & tbl.categoryId.equals(categoryId);
      if (onlyFavorites) condition = condition & tbl.isFavorite.equals(true);
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = '%${searchQuery.toLowerCase()}%';
        condition = condition &
            (tbl.name.lower().like(q) |
                tbl.sku.lower().like(q) |
                tbl.barcode.like(q));
      }
      return condition;
    });
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.get();
  }

  @override
  Future<ProductRow> getProductById(String id) async {
    final row = await (_db.select(_db.products)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw const NotFoundException('Producto no encontrado.');
    return row;
  }

  @override
  Future<ProductRow?> getProductByBarcode(String barcode) {
    return (_db.select(_db.products)
          ..where((tbl) => tbl.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  @override
  Future<ProductRow> insertProduct(ProductsCompanion companion) async {
    final id = (companion.id as Value<String>).value;
    await _db.into(_db.products).insert(companion);
    return getProductById(id);
  }

  @override
  Future<ProductRow> updateProduct(
      String id, ProductsCompanion companion) async {
    await (_db.update(_db.products)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
    return getProductById(id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final count = await (_db.update(_db.products)
          ..where((tbl) => tbl.id.equals(id)))
        .write(ProductsCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
    if (count == 0) throw const NotFoundException('Producto no encontrado.');
    await (_db.update(_db.productVariants)
          ..where((tbl) => tbl.productId.equals(id)))
        .write(const ProductVariantsCompanion(isActive: Value(false)));
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    final product = await getProductById(productId);
    await (_db.update(_db.products)..where((tbl) => tbl.id.equals(productId)))
        .write(
      ProductsCompanion(isFavorite: Value(!product.isFavorite)),
    );
  }

  @override
  Future<void> updateStock(String productId, double newQty,
      {String? variantId}) async {
    if (variantId != null) {
      await (_db.update(_db.productVariants)
            ..where((tbl) => tbl.id.equals(variantId)))
          .write(ProductVariantsCompanion(stockQuantity: Value(newQty)));
    } else {
      await (_db.update(_db.products)..where((tbl) => tbl.id.equals(productId)))
          .write(ProductsCompanion(
        stockQuantity: Value(newQty),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  // ── Categorías ────────────────────────────────────────────────────────────

  @override
  Future<List<CategoryRow>> getCategories({bool onlyActive = true}) {
    final query = _db.select(_db.categories);
    if (onlyActive) query.where((tbl) => tbl.isActive.equals(true));
    query.orderBy([
      (tbl) => OrderingTerm.asc(tbl.sortOrder),
      (tbl) => OrderingTerm.asc(tbl.name)
    ]);
    return query.get();
  }

  @override
  Future<CategoryRow> insertCategory(CategoriesCompanion companion) async {
    await _db.into(_db.categories).insert(companion);
    final id = (companion.id as Value<String>).value;
    return (_db.select(_db.categories)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  @override
  Future<CategoryRow> updateCategory(
      String id, CategoriesCompanion companion) async {
    await (_db.update(_db.categories)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
    return (_db.select(_db.categories)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> deleteCategory(String id) async {
    await (_db.delete(_db.categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ── Marcas ────────────────────────────────────────────────────────────────

  @override
  Future<List<BrandRow>> getBrands() {
    return (_db.select(_db.brands)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  @override
  Future<BrandRow> insertBrand(BrandsCompanion companion) async {
    await _db.into(_db.brands).insert(companion);
    final id = (companion.id as Value<String>).value;
    return (_db.select(_db.brands)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // ── Proveedores ───────────────────────────────────────────────────────────

  @override
  Future<List<SupplierRow>> getSuppliers({bool onlyActive = true}) {
    final query = _db.select(_db.suppliers);
    if (onlyActive) query.where((tbl) => tbl.isActive.equals(true));
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.get();
  }

  @override
  Future<SupplierRow> insertSupplier(SuppliersCompanion companion) async {
    await _db.into(_db.suppliers).insert(companion);
    final id = (companion.id as Value<String>).value;
    return (_db.select(_db.suppliers)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  @override
  Future<SupplierRow> updateSupplier(
      String id, SuppliersCompanion companion) async {
    await (_db.update(_db.suppliers)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
    return (_db.select(_db.suppliers)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // ── Variantes ─────────────────────────────────────────────────────────────

  @override
  Future<List<ProductVariantRow>> getVariantsByProduct(String productId) {
    return (_db.select(_db.productVariants)
          ..where((tbl) =>
              tbl.productId.equals(productId) & tbl.isActive.equals(true)))
        .get();
  }

  @override
  Future<ProductVariantRow> insertVariant(
      ProductVariantsCompanion companion) async {
    await _db.into(_db.productVariants).insert(companion);
    final id = (companion.id as Value<String>).value;
    return (_db.select(_db.productVariants)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  @override
  Future<ProductVariantRow> updateVariant(
      String id, ProductVariantsCompanion companion) async {
    await (_db.update(_db.productVariants)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
    return (_db.select(_db.productVariants)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> deleteVariant(String variantId) async {
    await (_db.delete(_db.productVariants)
          ..where((tbl) => tbl.id.equals(variantId)))
        .go();
  }

  // ── Streams ───────────────────────────────────────────────────────────────

  @override
  Stream<List<ProductRow>> watchProducts(
      {String? categoryId, String? searchQuery}) {
    final query = _db.select(_db.products);
    query.where((tbl) {
      Expression<bool> condition = tbl.isActive.equals(true);
      if (categoryId != null)
        condition = condition & tbl.categoryId.equals(categoryId);
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = '%${searchQuery.toLowerCase()}%';
        condition =
            condition & (tbl.name.lower().like(q) | tbl.barcode.like(q));
      }
      return condition;
    });
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.watch();
  }

  @override
  Stream<List<CategoryRow>> watchCategories() {
    return (_db.select(_db.categories)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .watch();
  }
}
