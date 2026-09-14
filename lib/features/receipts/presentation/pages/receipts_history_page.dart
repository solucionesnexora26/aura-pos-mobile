import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/tables/sales_tables.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../pos/data/repositories/sale_repository_impl.dart';
import '../../../pos/presentation/providers/pos_providers.dart';

class ReceiptsHistoryPage extends ConsumerStatefulWidget {
  const ReceiptsHistoryPage({super.key});

  @override
  ConsumerState<ReceiptsHistoryPage> createState() => _ReceiptsHistoryPageState();
}

class _ReceiptsHistoryPageState extends ConsumerState<ReceiptsHistoryPage> {
  Future<void> _pickDate() async {
    final selected = ref.read(_selectedDateProvider);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selected ?? now,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Filtrar recibos por fecha',
    );
    if (picked != null && mounted) {
      ref.read(_selectedDateProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(_receiptsProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(RouteNames.pos),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo recibo'),
      ),
      body: salesAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando recibos…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (result) => result.fold(
          (Failure f) => AppErrorView(message: f.message),
          (List<SaleEntity> sales) => _buildContent(sales, scheme, text),
        ),
      ),
    );
  }

  Widget _buildContent(List<SaleEntity> sales, ColorScheme scheme, TextTheme text) {
    if (sales.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _buildHeader(scheme, text),
          ),
          Expanded(child: _buildEmpty(scheme, text)),
        ],
      );
    }

    final total = sales.fold<double>(0.0, (sum, s) => sum + s.total);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: sales.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(scheme, text),
              const SizedBox(height: 20),
              _buildSummaryCard(total, sales.length, scheme, text),
              const SizedBox(height: 24),
              _buildDateHeader(sales.length, total, scheme, text),
              const SizedBox(height: 12),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ReceiptCard(sale: sales[index - 1]),
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme scheme, TextTheme text) {
    final isFiltered = ref.watch(_selectedDateProvider) != null;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historial de Recibos',
                style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                'Resumen de tus ventas',
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        _FilterButton(
          isActive: isFiltered,
          onPick: _pickDate,
          onClear: isFiltered ? () => ref.read(_selectedDateProvider.notifier).state = null : null,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(double total, int count, ColorScheme scheme, TextTheme text) {
    final deep = Color.lerp(scheme.primary, Colors.black, 0.28)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, deep],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -28,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            right: 48,
            bottom: -40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total general',
                style: text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 6),
              Text(
                AppFormatters.currency(total),
                style: text.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count recibos en este período',
                style: text.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(int count, double total, ColorScheme scheme, TextTheme text) {
    final selected = ref.watch(_selectedDateProvider);
    final isToday = selected == null;
    final date = selected ?? DateTime.now();
    final longDate = DateFormat('EEEE d \'de\' MMMM', AppConstants.defaultLocale).format(date);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToday ? 'Hoy' : 'Fecha seleccionada',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                isToday ? 'Hoy, $longDate' : '$longDate · ${date.year}',
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.inverseSurface,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count · ${AppFormatters.currency(total)}',
            style: text.bodySmall?.copyWith(
              color: scheme.onInverseSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(ColorScheme scheme, TextTheme text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No se encontraron recibos',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no tienes recibos para mostrar.\nPrueba cambiar la fecha o crear una nueva venta.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.goNamed(RouteNames.pos),
              icon: const Icon(Icons.add),
              label: const Text('Nueva venta'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.isActive, required this.onPick, this.onClear});

  final bool isActive;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: isActive ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPick,
            icon: Icon(
              Icons.calendar_month,
              color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
            tooltip: 'Filtrar por fecha',
          ),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, size: 18),
              color: scheme.onPrimary,
              tooltip: 'Ver hoy',
            ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends ConsumerWidget {
  const _ReceiptCard({required this.sale});

  final SaleEntity sale;

  void _open(BuildContext context) {
    context.goNamed(
      RouteNames.receiptPreview,
      queryParameters: {'saleId': sale.id},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final info = _statusInfo(sale.status);
    final when = sale.paidAt ?? sale.createdAt;
    final hasReturns = sale.items.any((i) => i.isReturn);
    final paymentLabels = sale.payments.map((p) => _paymentLabel(p.method)).join(', ');
    final customer = sale.customerId == null
        ? null
        : ref.watch(customerByIdProvider(sale.customerId)).maybeWhen(
            data: (c) => c?.fullName,
            orElse: () => null,
          );

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _open(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: info.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(info.icon, color: info.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket #${sale.ticketNumber}',
                          style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (customer != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            customer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppFormatters.currency(sale.total),
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${AppFormatters.date(when)} · ${sale.items.length} ${sale.items.length == 1 ? 'artículo' : 'artículos'}',
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    AppFormatters.time(when),
                    style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  if (paymentLabels.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.payments_outlined, size: 14, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        paymentLabels,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (hasReturns)
                    _ReturnTag(),
                  _StatusPill(color: info.color, label: info.label),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Ver detalle',
                    style: text.bodySmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward, size: 14, color: scheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class _ReturnTag extends StatelessWidget {
  const _ReturnTag();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'Devolución',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: scheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}

({Color color, IconData icon, String label}) _statusInfo(SaleStatus status) =>
    switch (status) {
      SaleStatus.paid => (color: AppColors.paidTicket, icon: Icons.receipt_long, label: 'Pagado'),
      SaleStatus.cancelled =>
        (color: AppColors.cancelledTicket, icon: Icons.cancel_outlined, label: 'Cancelado'),
      SaleStatus.refunded =>
        (color: AppColors.warning, icon: Icons.currency_exchange, label: 'Reembolsado'),
      SaleStatus.open => (color: AppColors.openTicket, icon: Icons.edit_outlined, label: 'Abierto'),
    };

String _paymentLabel(PaymentMethod m) => switch (m) {
      PaymentMethod.cash => 'Efectivo',
      PaymentMethod.card => 'Tarjeta',
      PaymentMethod.transfer => 'Transferencia',
      PaymentMethod.nequi => 'Nequi',
      PaymentMethod.daviplata => 'Daviplata',
      PaymentMethod.mixed => 'Mixto',
      PaymentMethod.credit => 'Crédito',
    };

final _selectedDateProvider = StateProvider<DateTime?>((ref) => null);

final _receiptsProvider = FutureProvider<Either<Failure, List<SaleEntity>>>((ref) async {
  final selected = ref.watch(_selectedDateProvider);
  final now = DateTime.now();
  final day = selected ?? DateTime(now.year, now.month, now.day);
  final from = DateTime(day.year, day.month, day.day);
  final to = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);
  return ref.watch(saleRepositoryProvider).getReceiptsByDate(from: from, to: to);
});
