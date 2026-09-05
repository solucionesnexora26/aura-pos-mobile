import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/supabase_providers.dart';
import '../../data/repositories/credit_repository.dart';
import '../../domain/entities/credit_entities.dart';

final creditRepositoryProvider = Provider<CreditRepository>((ref) {
  return CreditRepository(ref.watch(supabaseClientProvider));
});

/// Cartera general: todos los clientes con deuda pendiente.
final creditOverviewProvider = FutureProvider<List<CreditOverviewItem>>((ref) async {
  final repo = ref.watch(creditRepositoryProvider);
  return repo.getCreditOverview();
});

/// Resumen de crédito de un cliente específico.
final customerCreditSummaryProvider =
    FutureProvider.family<CreditSummary?, String>((ref, customerId) async {
  final repo = ref.watch(creditRepositoryProvider);
  return repo.getCustomerCreditSummary(customerId);
});

/// Historial de abonos de un cliente.
final customerPaymentsProvider =
    FutureProvider.family<List<CreditPaymentRecord>, String>((ref, customerId) async {
  final repo = ref.watch(creditRepositoryProvider);
  return repo.getCustomerPayments(customerId);
});

/// Historial de comprobantes de abono de un cliente.
final customerReceiptsProvider =
    FutureProvider.family<List<PaymentReceipt>, String>((ref, customerId) async {
  final repo = ref.watch(creditRepositoryProvider);
  return repo.getCustomerReceipts(customerId);
});

/// Todos los comprobantes de abono (vista global).
final allReceiptsProvider = FutureProvider<List<PaymentReceipt>>((ref) async {
  final repo = ref.watch(creditRepositoryProvider);
  return repo.getAllReceipts();
});
