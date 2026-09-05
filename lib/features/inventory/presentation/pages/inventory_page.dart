import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../providers/inventory_providers.dart';

class InventoryPage extends HookConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = useState(0);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: const Text('Inventario'),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.list_alt), text: 'Movimientos'),
            Tab(icon: Icon(Icons.warning_amber_outlined), text: 'Alertas'),
          ]),
        ),
        body: TabBarView(children: [
          const _MovementsTab(),
          const _AlertsTab(),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAdjustmentDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Ajustar stock'),
        ),
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AdjustmentSheet(ref: ref),
    );
  }
}

class _MovementsTab extends ConsumerWidget {
  const _MovementsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsAsync = ref.watch(recentMovementsStreamProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return movementsAsync.when(
      loading: () => const AppLoadingView(message: 'Cargando movimientos…'),
      error: (e, _) => AppErrorView(message: e.toString()),
      data: (movements) {
        if (movements.isEmpty) {
          return const AppEmptyView(
            message: 'No hay movimientos de inventario registrados.',
            icon: Icons.list_alt_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: movements.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final m = movements[i];
            final isPositive = m.type.isPositive;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isPositive
                      ? Colors.green.withValues(alpha: 0.15)
                      : scheme.errorContainer,
                  child: Icon(
                    isPositive ? Icons.add : Icons.remove,
                    color: isPositive ? Colors.green : scheme.error,
                  ),
                ),
                title: Text(m.productName ?? 'Producto', style: text.labelMedium),
                subtitle: Text(
                  '${m.type.label} · ${AppFormatters.dateTime(m.createdAt)}',
                  style: text.bodySmall,
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : '-'}${AppFormatters.quantity(m.quantity)}',
                      style: text.titleSmall?.copyWith(
                        color: isPositive ? Colors.green : scheme.error,
                      ),
                    ),
                    Text(
                      'Stock: ${AppFormatters.quantity(m.stockAfter)}',
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AlertsTab extends ConsumerWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return productsAsync.when(
      loading: () => const AppLoadingView(),
      error: (e, _) => AppErrorView(message: e.toString()),
      data: (products) {
        final alerts = products
            .where((p) => p.trackStock && p.isLowStock)
            .toList()
          ..sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));
        if (alerts.isEmpty) {
          return const AppEmptyView(
            message: 'Sin alertas de stock. Todo en orden.',
            icon: Icons.check_circle_outline,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final p = alerts[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: p.isOutOfStock
                      ? scheme.errorContainer
                      : Colors.orange.withValues(alpha: 0.15),
                  child: Icon(
                    p.isOutOfStock
                        ? Icons.error_outline
                        : Icons.warning_amber_outlined,
                    color: p.isOutOfStock ? scheme.error : Colors.orange,
                  ),
                ),
                title: Text(p.name, style: text.labelMedium),
                subtitle: Text(p.category?.name ?? 'Sin categoría', style: text.bodySmall),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppFormatters.quantity(p.stockQuantity),
                      style: text.titleSmall?.copyWith(
                        color: p.isOutOfStock ? scheme.error : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mín: ${AppFormatters.quantity(p.lowStockThreshold)}',
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AdjustmentSheet extends HookConsumerWidget {
  const _AdjustmentSheet({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final selectedProduct = useState<String?>(null);
    final quantityCtrl = useTextEditingController();
    final reasonCtrl = useTextEditingController();
    final type = useState(InventoryMovementTypeEntity.entry);
    final isSaving = useState(false);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 24, 16, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ajustar Stock',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          productsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (products) => DropdownButtonFormField<String>(
              value: selectedProduct.value,
              decoration: const InputDecoration(labelText: 'Producto *'),
              items: products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
              onChanged: (v) => selectedProduct.value = v,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<InventoryMovementTypeEntity>(
            value: type.value,
            decoration: const InputDecoration(labelText: 'Tipo de movimiento'),
            items: [
              InventoryMovementTypeEntity.entry,
              InventoryMovementTypeEntity.exit,
              InventoryMovementTypeEntity.adjustment,
            ].map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
            onChanged: (v) => type.value = v ?? InventoryMovementTypeEntity.entry,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: quantityCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reasonCtrl,
            decoration: const InputDecoration(labelText: 'Motivo (opcional)'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isSaving.value || selectedProduct.value == null
                  ? null
                  : () async {
                      final qty = double.tryParse(quantityCtrl.text.replaceAll(',', '.')) ?? 0;
                      if (qty <= 0) return;
                      isSaving.value = true;
                      final session = ref.read(authSessionProvider);
                      await ref.read(registerInventoryMovementUseCaseProvider).call(
                            RegisterMovementParams(
                              productId: selectedProduct.value!,
                              type: type.value,
                              quantity: qty,
                              userId: session.user?.id ?? '',
                              reason: reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim(),
                            ),
                          );
                      isSaving.value = false;
                      if (context.mounted) Navigator.of(context).pop();
                    },
              child: isSaving.value
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Registrar movimiento'),
            ),
          ),
        ],
      ),
    );
  }
}
