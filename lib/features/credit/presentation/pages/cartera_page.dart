import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/credit_entities.dart';
import '../providers/credit_providers.dart';

/// Pantalla principal de cartera: lista de clientes con saldo de crédito
/// pendiente, ordenados por deuda (mayor a menor).
class CarteraPage extends ConsumerStatefulWidget {
  const CarteraPage({super.key});

  @override
  ConsumerState<CarteraPage> createState() => _CarteraPageState();
}

class _CarteraPageState extends ConsumerState<CarteraPage> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(creditOverviewProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Cartera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Historial de abonos',
            onPressed: () => context.pushNamed(RouteNames.abonoHistory),
          ),
        ],
      ),
      body: overviewAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando cartera…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyView(
              message: 'No hay clientes con saldo pendiente.',
              icon: Icons.account_balance_wallet_outlined,
            );
          }

          // ── Filtrado por búsqueda ───────────────────────────────────
          final filtered = _search.isEmpty
              ? items
              : items.where((i) =>
                  i.customerName.toLowerCase().contains(_search.toLowerCase())).toList();

          final totalDebt = items.fold<double>(0, (s, i) => s + i.totalOwed);

          return Column(
            children: [
              // ── Resumen ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: scheme.primaryContainer.withValues(alpha: 0.3),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: scheme.primary, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      '${items.length} cliente(s) con deuda',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      AppFormatters.currency(totalDebt),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              // ── Buscador ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar cliente…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  ),
                ),
              ),

              // ── Lista ────────────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? const AppEmptyView(
                        message: 'No se encontraron clientes.',
                        icon: Icons.search_off,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) => _CarteraTile(item: filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CarteraTile extends StatelessWidget {
  const _CarteraTile({required this.item});
  final CreditOverviewItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final customerName = item.customerName;
    final creditBalance = item.totalOwed;
    final pendingCount = item.pendingCount;
    final daysSinceOldest = item.daysSinceOldest;
    final customerId = item.customerId;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: creditBalance > 0 ? scheme.errorContainer : scheme.surfaceContainerHighest,
          child: Text(
            customerName[0].toUpperCase(),
            style: TextStyle(
              color: creditBalance > 0 ? scheme.onErrorContainer : scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(customerName, style: text.titleSmall),
        subtitle: Text(
          '$pendingCount venta(s) pendiente(s)${daysSinceOldest > 0 ? ' · $daysSinceOldest días' : ''}',
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        trailing: Text(
          AppFormatters.currency(creditBalance),
          style: text.titleMedium?.copyWith(
            color: scheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => context.pushNamed(
          RouteNames.customerCreditDetail,
          queryParameters: {'customerId': customerId, 'customerName': customerName},
        ),
      ),
    );
  }
}
