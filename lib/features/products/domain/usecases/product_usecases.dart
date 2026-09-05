import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GET PRODUCTS
// ─────────────────────────────────────────────────────────────────────────────

class GetProductsParams {
  const GetProductsParams({
    this.categoryId,
    this.searchQuery,
    this.onlyFavorites = false,
    this.onlyActive = true,
  });
  final String? categoryId;
  final String? searchQuery;
  final bool onlyFavorites;
  final bool onlyActive;
}

class GetProductsUseCase implements UseCase<List<ProductEntity>, GetProductsParams> {
  const GetProductsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) {
    return _repository.getProducts(
      categoryId: params.categoryId,
      searchQuery: params.searchQuery,
      onlyFavorites: params.onlyFavorites,
      onlyActive: params.onlyActive,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GET PRODUCT BY ID
// ─────────────────────────────────────────────────────────────────────────────

class GetProductByIdUseCase implements UseCase<ProductEntity, String> {
  const GetProductByIdUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductEntity>> call(String params) {
    return _repository.getProductById(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GET PRODUCT BY BARCODE
// ─────────────────────────────────────────────────────────────────────────────

class GetProductByBarcodeUseCase implements UseCase<ProductEntity?, String> {
  const GetProductByBarcodeUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductEntity?>> call(String params) {
    return _repository.getProductByBarcode(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE PRODUCT
// ─────────────────────────────────────────────────────────────────────────────

class CreateProductUseCase implements UseCase<ProductEntity, ProductEntity> {
  const CreateProductUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductEntity>> call(ProductEntity params) async {
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure('El nombre del producto es obligatorio.'));
    }
    if (params.price < 0) {
      return const Left(ValidationFailure('El precio no puede ser negativo.'));
    }
    return _repository.createProduct(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UPDATE PRODUCT
// ─────────────────────────────────────────────────────────────────────────────

class UpdateProductUseCase implements UseCase<ProductEntity, ProductEntity> {
  const UpdateProductUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductEntity>> call(ProductEntity params) async {
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure('El nombre del producto es obligatorio.'));
    }
    if (params.price < 0) {
      return const Left(ValidationFailure('El precio no puede ser negativo.'));
    }
    return _repository.updateProduct(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DELETE PRODUCT
// ─────────────────────────────────────────────────────────────────────────────

class DeleteProductUseCase implements UseCase<Unit, String> {
  const DeleteProductUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return _repository.deleteProduct(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOGGLE FAVORITE
// ─────────────────────────────────────────────────────────────────────────────

class ToggleFavoriteUseCase implements UseCase<Unit, String> {
  const ToggleFavoriteUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return _repository.toggleFavorite(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GET CATEGORIES
// ─────────────────────────────────────────────────────────────────────────────

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  const GetCategoriesUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return _repository.getCategories();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE CATEGORY
// ─────────────────────────────────────────────────────────────────────────────

class CreateCategoryUseCase implements UseCase<CategoryEntity, CategoryEntity> {
  const CreateCategoryUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, CategoryEntity>> call(CategoryEntity params) async {
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure('El nombre de la categoría es obligatorio.'));
    }
    return _repository.createCategory(params);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GET BRANDS / SUPPLIERS
// ─────────────────────────────────────────────────────────────────────────────

class GetBrandsUseCase implements UseCase<List<BrandEntity>, NoParams> {
  const GetBrandsUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<BrandEntity>>> call(NoParams params) {
    return _repository.getBrands();
  }
}

class GetSuppliersUseCase implements UseCase<List<SupplierEntity>, NoParams> {
  const GetSuppliersUseCase(this._repository);
  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(NoParams params) {
    return _repository.getSuppliers();
  }
}
