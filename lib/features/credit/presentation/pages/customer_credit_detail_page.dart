import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/credit_entities.dart';
import '../providers/credit_providers.dart';

/// Detalle de crédito de un cliente: resumen + ventas pendientes + historial
/// de abonos. Desde aquí se puede registrar un abono.
class CustomerCreditDetailPage extends ConsumerWidget {
  const CustomerCreditDetailPage({
    super.key,
    required this.customerId,
    this.customerName,
  });

  final String customerId;
  final String? customerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(customerCreditSummaryProvider(customerId));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(customerName ?? 'Crédito del cliente'),
      ),
      body: summaryAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando resumen…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (summary) {
          if (summary == null) {
            return const AppEmptyView(
              message: 'No se encontró información de crédito.',
              icon: Icons.info_outline,
            );
          }

          return Column(
            children: [
              // ── Tarjeta resumen ────────────────────────────────────────
              _SummaryCard(summary: summary, scheme: scheme),

              // ── Botón abonar ───────────────────────────────────────────
              if (summary.pendingSales.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text('Registrar abono'),
                      onPressed: () async {
                        final result = await context.pushNamed<bool>(
                          RouteNames.abonoForm,
                          queryParameters: {'customerId': customerId},
                        );
                        if (result == true && context.mounted) {
                          ref.invalidate(customerCreditSummaryProvider(customerId));
                          ref.invalidate(customerPaymentsProvider(customerId));
                          ref.invalidate(creditOverviewProvider);
                        }
                      },
                    ),
                  ),
                ),

              // ── Ventas pendientes ──────────────────────────────────────
              if (summary.pendingSales.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ventas pendientes (${summary.pendingSales.length})',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: summary.pendingSales.length,
                    itemBuilder: (context, i) {
                      final sale = summary.pendingSales[i];
                      return _PendingSaleTile(
                        ticketNumber: sale.ticketNumber,
                        total: sale.total,
                        paid: sale.paid,
                        pending: sale.pending,
                        createdAt: sale.createdAt,
                        onTap: () {
                          _showSaleDetails(context, sale, scheme);
                        },
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary, required this.scheme});
  final CreditSummary summary;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final creditBalance = summary.totalOwed;
    final creditLimit = summary.creditLimitEffective;
    final totalPaid = summary.totalPaid;
    final availableCredit = summary.availableCredit;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: scheme.primary),
              const SizedBox(width: 8),
              Text('Total adeudado', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Text(
                AppFormatters.currency(creditBalance),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: scheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryItem(label: 'Cupo total', value: AppFormatters.currency(creditLimit)),
              _SummaryItem(label: 'Total abonado', value: AppFormatters.currency(totalPaid), color: scheme.tertiary),
              if (creditLimit > 0)
                _SummaryItem(label: 'Cupo disponible', value: AppFormatters.currency(availableCredit), color: scheme.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
      ],
    );
  }
}

void _showSaleDetails(BuildContext context, CreditSalePending sale, ColorScheme scheme) {
  final progress = sale.total > 0 ? (sale.paid / sale.total).clamp(0.0, 1.0) : 0.0;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Ticket ${sale.ticketNumber}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(AppFormatters.dateTime(sale.createdAt), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: scheme.surfaceContainerHighest,
            color: progress >= 1.0 ? scheme.tertiary : scheme.primary,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Total', value: AppFormatters.currency(sale.total)),
          const SizedBox(height: 8),
          _DetailRow(label: 'Pagado', value: AppFormatters.currency(sale.paid), color: scheme.tertiary),
          const SizedBox(height: 8),
          _DetailRow(label: 'Pendiente', value: AppFormatters.currency(sale.pending), color: scheme.error),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _PendingSaleTile extends StatelessWidget {
  const _PendingSaleTile({
    required this.ticketNumber,
    required this.total,
    required this.paid,
    required this.pending,
    required this.createdAt,
    this.onTap,
  });

  final String ticketNumber;
  final double total;
  final double paid;
  final double pending;
  final DateTime createdAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = total > 0 ? (paid / total).clamp(0.0, 1.0) : 0.0;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: scheme.errorContainer,
          child: Text(
            '#${ticketNumber.length > 4 ? ticketNumber.substring(ticketNumber.length - 4) : ticketNumber}',
            style: TextStyle(
              fontSize: 11,
              color: scheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'Ticket $ticketNumber',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: scheme.surfaceContainerHighest,
              color: progress >= 1.0 ? scheme.tertiary : scheme.primary,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 4),
            Text(
              'Pagado: ${AppFormatters.currency(paid)}  ·  Pendiente: ${AppFormatters.currency(pending)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
