import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

part 'customer_entity.freezed.dart';

enum CustomerTypeEntity { occasional, frequent, credit }

extension CustomerTypeEntityX on CustomerTypeEntity {
  String get label => switch (this) {
        CustomerTypeEntity.occasional => 'Ocasional',
        CustomerTypeEntity.frequent => 'Frecuente',
        CustomerTypeEntity.credit => 'Crédito',
      };
}

// ─── Entidad ──────────────────────────────────────────────────────────────────

@freezed
class CustomerEntity with _$CustomerEntity {
  const factory CustomerEntity({
    required String id,
    required String fullName,
    String? documentId,
    String? phone,
    String? email,
    String? address,
    required CustomerTypeEntity type,
    required double creditLimit,
    required double creditBalance,
    required bool isActive,
    required DateTime createdAt,
  }) = _CustomerEntity;

  const CustomerEntity._();

  double get availableCredit => creditLimit - creditBalance;
  bool get hasCredit => type == CustomerTypeEntity.credit;
}

// ─── Repositorio ──────────────────────────────────────────────────────────────

abstract interface class CustomerRepository {
  Future<Either<Failure, List<CustomerEntity>>> getCustomers({String? searchQuery, bool onlyActive = true});
  Future<Either<Failure, CustomerEntity>> getCustomerById(String id);
  Future<Either<Failure, CustomerEntity>> createCustomer(CustomerEntity customer);
  Future<Either<Failure, CustomerEntity>> updateCustomer(CustomerEntity customer);
  Future<Either<Failure, Unit>> deleteCustomer(String id);
  Stream<List<CustomerEntity>> watchCustomers({String? searchQuery});
}

// ─── UseCases ─────────────────────────────────────────────────────────────────

class GetCustomersUseCase implements UseCase<List<CustomerEntity>, String?> {
  const GetCustomersUseCase(this._repo);
  final CustomerRepository _repo;

  @override
  Future<Either<Failure, List<CustomerEntity>>> call(String? params) {
    return _repo.getCustomers(searchQuery: params);
  }
}

class GetCustomerByIdUseCase implements UseCase<CustomerEntity, String> {
  const GetCustomerByIdUseCase(this._repo);
  final CustomerRepository _repo;

  @override
  Future<Either<Failure, CustomerEntity>> call(String params) {
    return _repo.getCustomerById(params);
  }
}

class SaveCustomerUseCase implements UseCase<CustomerEntity, CustomerEntity> {
  const SaveCustomerUseCase(this._repo);
  final CustomerRepository _repo;

  @override
  Future<Either<Failure, CustomerEntity>> call(CustomerEntity params) async {
    if (params.fullName.trim().isEmpty) {
      return const Left(ValidationFailure('El nombre del cliente es obligatorio.'));
    }
    return params.id.isEmpty || params.id == 'new'
        ? _repo.createCustomer(params)
        : _repo.updateCustomer(params);
  }
}

class DeleteCustomerUseCase implements UseCase<Unit, String> {
  const DeleteCustomerUseCase(this._repo);
  final CustomerRepository _repo;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return _repo.deleteCustomer(params);
  }
}
