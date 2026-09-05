import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/supabase_providers.dart';
import '../../data/repositories/sale_repository_impl.dart';

export 'cart_provider.dart';

final Provider<SaleRepository> saleRepositoryProvider =
    Provider<SaleRepository>(
        (ref) => SaleRepositoryImpl(
          ref.watch(appDatabaseProvider),
          ref.watch(deviceIdServiceProvider),
        ),
    );

/// Última venta completada en memoria. Se escribe al cobrar para que el
/// recibo se muestre al instante sin volver a consultar la BD.
final StateProvider<SaleEntity?> lastCompletedSaleProvider =
    StateProvider<SaleEntity?>((ref) => null);

/// Venta por ID (respaldo cuando no hay cache, ej. abrir recibo histórico).
final FutureProviderFamily<Either<Failure, SaleEntity>, String>
    saleByIdProvider = FutureProviderFamily<Either<Failure, SaleEntity>, String>(
        (ref, saleId) =>
            ref.watch(saleRepositoryProvider).getSaleById(saleId));

// Ventas abiertas (stream reactivo)
final StreamProvider<List<SaleEntity>> openSalesStreamProvider =
    StreamProvider<List<SaleEntity>>((ref) {
  return ref.watch(saleRepositoryProvider).watchOpenSales();
});

// Total de ventas del día (para dashboard)
final FutureProvider<double> todaySalesTotalProvider =
    FutureProvider<double>((ref) async {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, now.day);
  final to = DateTime(now.year, now.month, now.day, 23, 59, 59);
  final result = await ref
      .watch(saleRepositoryProvider)
      .getSalesByDate(from: from, to: to);
  final sales = result.getOrElse((_) => <SaleEntity>[]);
  return sales.fold<double>(0.0, (sum, s) => sum + s.total);
});

// Ventas del día (lista)
final FutureProvider<List<SaleEntity>> todaySalesProvider =
    FutureProvider<List<SaleEntity>>((ref) async {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, now.day);
  final to = DateTime(now.year, now.month, now.day, 23, 59, 59);
  final result = await ref
      .watch(saleRepositoryProvider)
      .getSalesByDate(from: from, to: to);
  return result.getOrElse((_) => <SaleEntity>[]);
});
