import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer_entity.dart';

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerRepositoryImpl(ref.watch(appDatabaseProvider)) as CustomerRepository,
);

final Provider<GetCustomersUseCase> getCustomersUseCaseProvider =
    Provider((ref) => GetCustomersUseCase(ref.watch(customerRepositoryProvider)));

final Provider<GetCustomerByIdUseCase> getCustomerByIdUseCaseProvider =
    Provider((ref) => GetCustomerByIdUseCase(ref.watch(customerRepositoryProvider)));

final Provider<SaveCustomerUseCase> saveCustomerUseCaseProvider =
    Provider((ref) => SaveCustomerUseCase(ref.watch(customerRepositoryProvider)));

final Provider<DeleteCustomerUseCase> deleteCustomerUseCaseProvider =
    Provider((ref) => DeleteCustomerUseCase(ref.watch(customerRepositoryProvider)));

// ─── Estado de búsqueda ───────────────────────────────────────────────────────

final StateProvider<String> customerSearchProvider =
    StateProvider<String>((ref) => '');

// Stream reactivo de clientes con filtro
final StreamProvider<List<CustomerEntity>> customersStreamProvider =
    StreamProvider<List<CustomerEntity>>((ref) {
  final query = ref.watch(customerSearchProvider);
  return ref
      .watch(customerRepositoryProvider)
      .watchCustomers(searchQuery: query.isEmpty ? null : query);
});

// Cliente individual para el formulario
final FutureProviderFamily<CustomerEntity?, String?> customerByIdProvider =
    FutureProviderFamily<CustomerEntity?, String?>((ref, id) async {
  if (id == null) return null;
  final result = await ref.read(getCustomerByIdUseCaseProvider).call(id);
  return result.fold((_) => null, (c) => c);
});
