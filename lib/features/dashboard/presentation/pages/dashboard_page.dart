import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../../core/database/tables/cash_register_tables.dart';
import '../../../inventory/domain/entities/inventory_entity.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../../pos/data/repositories/sale_repository_impl.dart';
import '../../../pos/presentation/providers/pos_providers.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final todayTotal = ref.watch(todaySalesTotalProvider);
    final todaySales = ref.watch(todaySalesProvider);
    final openSales = ref.watch(openSalesStreamProvider);
    final openRegister = ref.watch(openCashRegisterProvider);
    final recentMovements = ref.watch(recentMovementsStreamProvider);
    final productsAsync = ref.watch(productsStreamProvider);

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.goNamed(RouteNames.switchUser),
            tooltip: 'Cambiar usuario',
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => ref.read(authSessionProvider.notifier).logout(),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(todaySalesTotalProvider)
            ..invalidate(todaySalesProvider)
            ..invalidate(openSalesStreamProvider)
            ..invalidate(recentMovementsStreamProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo
              Text(
                'Hola, ${session.user?.fullName.split(' ').first ?? 'usuario'} 👋',
                style: text.headlineSmall,
              ),
              Text(
                AppFormatters.date(now),
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),

              // Estado de la caja
              openRegister.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (reg) => _CashRegisterBanner(register: reg, ref: ref),
              ),
              const SizedBox(height: 16),

              // KPIs del día
              Text('Resumen de hoy', style: text.titleMedium),
              const SizedBox(height: 12),
              _KpiGrid(
                todayTotal: todayTotal,
                todaySales: todaySales,
                openSales: openSales,
                productsAsync: productsAsync,
              ),
              const SizedBox(height: 24),

              // Acceso rápido
              Text('Acceso rápido', style: text.titleMedium),
              const SizedBox(height: 12),
              _QuickAccessGrid(),
              const SizedBox(height: 24),

              // Actividad reciente
              Text('Actividad reciente', style: text.titleMedium),
              const SizedBox(height: 12),
              recentMovements.when(
                loading: () => const AppLoadingView(),
                error: (_, __) => const SizedBox.shrink(),
                data: (movements) {
                  if (movements.isEmpty) {
                    return const AppEmptyView(
                      message: 'Sin actividad reciente.',
                      icon: Icons.history,
                    );
                  }
                  return Column(
                    children: movements.take(5).map((m) {
                      final isPositive = m.type.isPositive;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: (isPositive ? Colors.green : scheme.error).withValues(alpha: 0.1),
                          child: Icon(
                            isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                            size: 14,
                            color: isPositive ? Colors.green : scheme.error,
                          ),
                        ),
                        title: Text(m.productName ?? 'Movimiento', style: text.bodyMedium),
                        subtitle: Text(AppFormatters.dateTime(m.createdAt), style: text.bodySmall),
                        trailing: Text(
                          '${isPositive ? '+' : '−'}${AppFormatters.quantity(m.quantity)}',
                          style: text.titleSmall?.copyWith(
                            color: isPositive ? Colors.green : scheme.error,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CashRegisterBanner extends StatelessWidget {
  const _CashRegisterBanner({required this.register, required this.ref});
  final CashRegisterEntity? register;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isOpen = register != null;

    double? balance;
    if (isOpen) {
      final movements = register!.movements;
      final totalIncome = movements
          .where((m) => m.type == CashMovementType.saleCash || m.type == CashMovementType.income || m.type == CashMovementType.deposit)
          .fold(0.0, (sum, m) => sum + m.amount);
      final totalExpense = movements
          .where((m) => m.type == CashMovementType.expense || m.type == CashMovementType.withdrawal)
          .fold(0.0, (sum, m) => sum + m.amount);
      balance = register!.openingAmount + totalIncome - totalExpense;
    }

    return InkWell(
      onTap: () => context.goNamed(isOpen ? RouteNames.cashRegister : RouteNames.cashRegisterOpen),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isOpen
              ? Colors.green.withValues(alpha: 0.1)
              : scheme.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOpen ? Colors.green.withValues(alpha: 0.3) : scheme.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isOpen ? Icons.lock_open_outlined : Icons.lock_outline,
              color: isOpen ? Colors.green : scheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOpen ? 'Caja abierta' : 'Caja cerrada',
                    style: text.bodyMedium?.copyWith(
                      color: isOpen ? Colors.green.shade700 : scheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isOpen && balance != null)
                    Text(
                      AppFormatters.currency(balance),
                      style: text.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isOpen ? Colors.green : scheme.error),
          ],
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({
    required this.todayTotal,
    required this.todaySales,
    required this.openSales,
    required this.productsAsync,
  });
  final AsyncValue<double> todayTotal;
  final AsyncValue<List<SaleEntity>> todaySales;
  final AsyncValue<List<SaleEntity>> openSales;
  final AsyncValue<List<ProductEntity>> productsAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 840 ? 4 : 2;

    final cards = [
      _KpiCard(
        label: 'Ventas hoy',
        value: todayTotal.when(
          loading: () => '…',
          error: (_, __) => '—',
          data: AppFormatters.currency,
        ),
        icon: Icons.trending_up,
        color: scheme.primary,
      ),
      _KpiCard(
        label: 'Transacciones',
        value: todaySales.when(
          loading: () => '…',
          error: (_, __) => '—',
          data: (s) => s.length.toString(),
        ),
        icon: Icons.receipt_outlined,
        color: Colors.blue,
      ),
      _KpiCard(
        label: 'Ventas abiertas',
        value: openSales.when(
          loading: () => '…',
          error: (_, __) => '—',
          data: (s) => s.length.toString(),
        ),
        icon: Icons.receipt_long_outlined,
        color: Colors.orange,
      ),
      _KpiCard(
        label: 'Stock bajo',
        value: productsAsync.when(
          loading: () => '…',
          error: (_, __) => '—',
          data: (products) => products.where((p) => p.isLowStock).length.toString(),
        ),
        icon: Icons.warning_amber_outlined,
        color: scheme.error,
      ),
    ];

    return GridView.count(
      crossAxisCount: cols,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const Spacer(),
            Text(value, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: text.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.point_of_sale_rounded, 'Nueva venta', RouteNames.pos, Colors.green),
      (Icons.receipt_long_outlined, 'Ventas abiertas', RouteNames.openSales, Colors.orange),
      (Icons.inventory_2_outlined, 'Productos', RouteNames.products, Colors.blue),
      (Icons.people_outline, 'Clientes', RouteNames.customers, Colors.purple),
      (Icons.list_alt_outlined, 'Inventario', RouteNames.inventory, Colors.teal),
      (Icons.settings_outlined, 'Ajustes', RouteNames.settings, Colors.grey),
    ];
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 840 ? 6 : 3;

    return GridView.count(
      crossAxisCount: cols,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) {
        return InkWell(
          onTap: () => context.goNamed(item.$3),
          borderRadius: BorderRadius.circular(16),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.$1, color: item.$4, size: 28),
                const SizedBox(height: 6),
                Text(item.$2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
