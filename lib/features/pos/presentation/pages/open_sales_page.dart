import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/entities/cart_entity.dart';
import '../providers/pos_providers.dart';

class OpenSalesPage extends ConsumerWidget {
  const OpenSalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openSalesAsync = ref.watch(openSalesStreamProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Ventas Abiertas'),
      ),
      body: openSalesAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando ventas abiertas…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (sales) {
          if (sales.isEmpty) {
            return const AppEmptyView(
              message: 'No hay ventas abiertas.',
              icon: Icons.receipt_long_outlined,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sales.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final sale = sales[i];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: scheme.tertiaryContainer,
                    child: Icon(Icons.receipt_long_outlined, color: scheme.onTertiaryContainer),
                  ),
                  title: Text(
                    sale.ticketLabel ?? 'Ticket #${sale.ticketNumber}',
                    style: text.titleSmall,
                  ),
                  subtitle: Text(
                    '${sale.items.length} producto(s) · ${AppFormatters.dateTime(sale.updatedAt)}',
                    style: text.bodySmall,
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppFormatters.currency(sale.total),
                        style: text.titleSmall?.copyWith(color: scheme.primary),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => _cancelSale(context, ref, sale.id),
                            child: Text('Cancelar', style: TextStyle(color: scheme.error, fontSize: 11)),
                          ),
                          FilledButton(
                            onPressed: () => _loadSale(context, ref, sale),
                            child: const Text('Reanudar', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _loadSale(BuildContext context, WidgetRef ref, SaleEntity sale) async {
    // Convierte los ítems de la BD al estado del carrito
    final items = <CartItemEntity>[];
    for (final row in sale.items) {
      final result =
          await ref.read(getProductByIdUseCaseProvider).call(row.productId);
      final product = result.fold((_) => null, (p) => p);
      if (product == null) continue;

      ProductVariantEntity? variant;
      if (row.variantId != null) {
        for (final v in product.variants) {
          if (v.id == row.variantId) {
            variant = v;
            break;
          }
        }
      }

      items.add(CartItemEntity(
        id: const Uuid().v4(),
        product: product,
        variant: variant,
        quantity: row.quantity,
        unitPrice: row.unitPrice,
        discount: row.discount,
        taxRate: row.taxRate,
        note: row.note,
      ));
    }

    ref.read(cartProvider.notifier).loadOpenSale(
          saleId: sale.id,
          label: sale.ticketLabel,
          items: items,
          note: sale.note,
        );
    if (context.mounted) context.go(RoutePaths.pos);
  }

  void _cancelSale(BuildContext context, WidgetRef ref, String saleId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cancelar venta'),
        content: const Text('¿Estás seguro de cancelar esta venta abierta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(dialogCtx, true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(saleRepositoryProvider).cancelSale(saleId);
  }
}
