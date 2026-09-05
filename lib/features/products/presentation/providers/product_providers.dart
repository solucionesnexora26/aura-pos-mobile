import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/product_usecases.dart';

// ─── Infraestructura ──────────────────────────────────────────────────────────

final Provider<ProductLocalDataSource> productLocalDataSourceProvider =
    Provider<ProductLocalDataSource>((ref) =>
        ProductLocalDataSourceImpl(ref.watch(appDatabaseProvider)));

final Provider<ProductRepository> productRepositoryProvider =
    Provider<ProductRepository>((ref) =>
        ProductRepositoryImpl(ref.watch(productLocalDataSourceProvider)));

// ─── UseCases ─────────────────────────────────────────────────────────────────

final Provider<GetProductsUseCase> getProductsUseCaseProvider =
    Provider((ref) => GetProductsUseCase(ref.watch(productRepositoryProvider)));

final Provider<GetProductByIdUseCase> getProductByIdUseCaseProvider =
    Provider((ref) => GetProductByIdUseCase(ref.watch(productRepositoryProvider)));

final Provider<GetProductByBarcodeUseCase> getProductByBarcodeUseCaseProvider =
    Provider((ref) => GetProductByBarcodeUseCase(ref.watch(productRepositoryProvider)));

final Provider<CreateProductUseCase> createProductUseCaseProvider =
    Provider((ref) => CreateProductUseCase(ref.watch(productRepositoryProvider)));

final Provider<UpdateProductUseCase> updateProductUseCaseProvider =
    Provider((ref) => UpdateProductUseCase(ref.watch(productRepositoryProvider)));

final Provider<DeleteProductUseCase> deleteProductUseCaseProvider =
    Provider((ref) => DeleteProductUseCase(ref.watch(productRepositoryProvider)));

final Provider<ToggleFavoriteUseCase> toggleFavoriteUseCaseProvider =
    Provider((ref) => ToggleFavoriteUseCase(ref.watch(productRepositoryProvider)));

final Provider<GetCategoriesUseCase> getCategoriesUseCaseProvider =
    Provider((ref) => GetCategoriesUseCase(ref.watch(productRepositoryProvider)));

final Provider<CreateCategoryUseCase> createCategoryUseCaseProvider =
    Provider((ref) => CreateCategoryUseCase(ref.watch(productRepositoryProvider)));

final Provider<GetBrandsUseCase> getBrandsUseCaseProvider =
    Provider((ref) => GetBrandsUseCase(ref.watch(productRepositoryProvider)));

final Provider<GetSuppliersUseCase> getSuppliersUseCaseProvider =
    Provider((ref) => GetSuppliersUseCase(ref.watch(productRepositoryProvider)));

// ─── Estado: lista de productos (con filtros) ─────────────────────────────────

class ProductFilterState {
  const ProductFilterState({
    this.categoryId,
    this.searchQuery,
    this.onlyFavorites = false,
  });
  final String? categoryId;
  final String? searchQuery;
  final bool onlyFavorites;

  ProductFilterState copyWith({
    String? categoryId,
    String? searchQuery,
    bool? onlyFavorites,
    bool clearCategory = false,
  }) =>
      ProductFilterState(
        categoryId: clearCategory ? null : categoryId ?? this.categoryId,
        searchQuery: searchQuery ?? this.searchQuery,
        onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      );
}

class ProductFilterNotifier extends Notifier<ProductFilterState> {
  @override
  ProductFilterState build() => const ProductFilterState();

  void setCategory(String? categoryId) =>
      state = state.copyWith(categoryId: categoryId, clearCategory: categoryId == null);
  void setSearch(String query) =>
      state = state.copyWith(searchQuery: query.isEmpty ? null : query);
  void toggleFavorites() =>
      state = state.copyWith(onlyFavorites: !state.onlyFavorites);
  void reset() => state = const ProductFilterState();
}

final NotifierProvider<ProductFilterNotifier, ProductFilterState> productFilterProvider =
    NotifierProvider<ProductFilterNotifier, ProductFilterState>(ProductFilterNotifier.new);

// Productos filtrados reactivos (Drift watch + filtros UI)
final StreamProvider<List<ProductEntity>> productsStreamProvider =
    StreamProvider<List<ProductEntity>>((ref) {
  final filter = ref.watch(productFilterProvider);
  return ref.watch(productRepositoryProvider).watchProducts(
        categoryId: filter.categoryId,
        searchQuery: filter.searchQuery,
      );
});

// Categorías reactivas
final StreamProvider<List<CategoryEntity>> categoriesStreamProvider =
    StreamProvider<List<CategoryEntity>>((ref) {
  return ref.watch(productRepositoryProvider).watchCategories();
});

// Producto individual para el formulario
final FutureProviderFamily<ProductEntity?, String?> productByIdProvider =
    FutureProviderFamily<ProductEntity?, String?>((ref, id) async {
  if (id == null) return null;
  final result = await ref.watch(getProductByIdUseCaseProvider).call(id);
  return result.fold((_) => null, (p) => p);
});

// Categorías (lista simple para selects/dropdowns)
final FutureProvider<List<CategoryEntity>> categoriesProvider =
    FutureProvider<List<CategoryEntity>>((ref) async {
  final result = await ref.watch(getCategoriesUseCaseProvider).call(const NoParams());
  return result.fold((_) => [], (cats) => cats);
});

// Marcas
final FutureProvider<List<BrandEntity>> brandsProvider =
    FutureProvider<List<BrandEntity>>((ref) async {
  final result = await ref.watch(getBrandsUseCaseProvider).call(const NoParams());
  return result.fold((_) => [], (brands) => brands);
});

// Proveedores
final FutureProvider<List<SupplierEntity>> suppliersProvider =
    FutureProvider<List<SupplierEntity>>((ref) async {
  final result = await ref.watch(getSuppliersUseCaseProvider).call(const NoParams());
  return result.fold((_) => [], (sups) => sups);
});
