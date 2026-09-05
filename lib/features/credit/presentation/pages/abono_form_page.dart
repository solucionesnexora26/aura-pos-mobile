import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/tables/cash_register_tables.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/sync/supabase_providers.dart';
import '../../../../core/sync/device_id_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../payment/presentation/providers/payment_methods_provider.dart';
import '../../data/repositories/credit_repository.dart';
import '../../domain/entities/credit_entities.dart';
import '../providers/credit_providers.dart';

/// Formulario para registrar un abono a una venta a crédito.
///
/// Recibe [customerId] como query parameter. Muestra las ventas pendientes
/// del cliente y permite seleccionar a cuál abonar (o abono general).
class AbonoFormPage extends ConsumerStatefulWidget {
  const AbonoFormPage({super.key, required this.customerId});
  final String customerId;

  @override
  ConsumerState<AbonoFormPage> createState() => _AbonoFormPageState();
}

class _AbonoFormPageState extends ConsumerState<AbonoFormPage> {
  final _amountCtrl = TextEditingController();
  final Set<String> _selectedSaleIds = {};
  int _selectedMethod = 0; // Efectivo por defecto
  bool _generalAbono = true; // Abono general (FIFO) por defecto
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountCtrl.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;

  String _methodLabel(int method) => switch (method) {
        0 => 'Efectivo',
        1 => 'Tarjeta',
        2 => 'Transferencia',
        3 => 'Nequi',
        4 => 'Daviplata',
        5 => 'Mixto',
        6 => 'Crédito',
        _ => 'Otro',
      };

  double selectedPendingTotal(CreditSummary summary) {
    return summary.pendingSales
        .where((s) => _selectedSaleIds.contains(s.saleId))
        .fold<double>(0, (sum, s) => sum + s.pending);
  }

  Future<void> _submit() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido mayor a 0')),
      );
      return;
    }
    if (!_generalAbono && _selectedSaleIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos una venta a abonar')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final deviceIdService = ref.read(deviceIdServiceProvider);
      final activationCode = await deviceIdService.getActivationCode();
      final deviceCode = (activationCode != null && activationCode.length >= 3)
          ? activationCode.substring(activationCode.length - 3).toUpperCase()
          : null;

      final repo = ref.read(creditRepositoryProvider);
      AbonoReceiptResult result;
      if (_generalAbono) {
        result = await repo.registerAbonoGeneral(
          customerId: widget.customerId,
          amount: _amount,
          method: _selectedMethod,
          deviceCode: deviceCode,
        );
      } else {
        // Distribuir monto entre ventas seleccionadas (FIFO por antigüedad)
        final summary = ref.read(customerCreditSummaryProvider(widget.customerId)).valueOrNull;
        if (summary == null) return;
        final selected = summary.pendingSales
            .where((s) => _selectedSaleIds.contains(s.saleId))
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        double remaining = _amount;
        String? lastReceiptNumber;
        for (final sale in selected) {
          if (remaining <= 0) break;
          final part = remaining < sale.pending ? remaining : sale.pending;
          final r = await repo.registerAbono(
            saleId: sale.saleId,
            customerId: widget.customerId,
            amount: part,
            method: _selectedMethod,
            deviceCode: deviceCode,
          );
          lastReceiptNumber = r.receiptNumber;
          remaining -= part;
        }
        result = AbonoReceiptResult(
          receiptNumber: lastReceiptNumber ?? '',
          totalAmount: _amount,
          saleIds: _selectedSaleIds.toList(),
        );
      }

      // Registrar movimiento de caja para el abono
      final cashRepo = ref.read(cashRegisterRepositoryProvider);
      final session = ref.read(authSessionProvider);
      final userId = session.user?.id ?? '';
      final openRegResult = await cashRepo.getOpenRegister();
      openRegResult.fold(
        (f) => debugPrint('[CASH_REGISTER][WARN] getOpenRegister failed after abono: ${f.message}'),
        (reg) async {
          if (reg != null && userId.isNotEmpty) {
            final movResult = await cashRepo.addMovement(
              registerId: reg.id,
              type: CashMovementType.income,
              amount: _amount,
              userId: userId,
              description: 'Abono ${result.receiptNumber}',
              method: _selectedMethod,
            );
            movResult.fold(
              (f) => debugPrint('[CASH_REGISTER][ERROR] abono movement failed: ${f.message}'),
              (_) => debugPrint('[CASH_REGISTER] abono movement created OK'),
            );
            ref.invalidate(openCashRegisterProvider);
          }
        },
      );
      if (mounted) {
        // Show receipt preview bottom sheet
        _showReceiptPreview(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showReceiptPreview(AbonoReceiptResult result) {
    final scheme = Theme.of(context).colorScheme;
    final methodName = _methodLabel(_selectedMethod);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Center(
                child: Text(
                  'COMPROBANTE DE ABONO',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _ReceiptPreviewCard(
                receiptNumber: result.receiptNumber,
                amount: result.totalAmount,
                methodName: methodName,
                createdAt: DateTime.now(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.print),
                  label: const Text('Imprimir comprobante'),
                  onPressed: () {
                    // TODO: Connect to AbonoReceiptBuilder + ReceiptPrinterService
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Impresión no disponible aún')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.pop(true);
                  },
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      if (mounted) context.pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(customerCreditSummaryProvider(widget.customerId));
    // Métodos de pago activos del servidor, o fallback hardcodeado (0-4).
    final serverMethods = ref.watch(activePaymentMethodsProvider).valueOrNull ?? [];
    final fallback = const [
      PaymentMethodConfig(code: 0, label: 'Efectivo', icon: 'banknote', isCredit: false),
      PaymentMethodConfig(code: 1, label: 'Tarjeta', icon: 'credit-card', isCredit: false),
      PaymentMethodConfig(code: 2, label: 'Transferencia', icon: 'arrow-left-right', isCredit: false),
      PaymentMethodConfig(code: 3, label: 'Nequi', icon: 'smartphone', isCredit: false),
      PaymentMethodConfig(code: 4, label: 'Daviplata', icon: 'smartphone', isCredit: false),
    ];
    // En abonos no se permite crédito (el cliente ya debe).
    final availableMethods = (serverMethods.isNotEmpty ? serverMethods : fallback)
        .where((m) => !m.isCredit && m.code != 6)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar abono')),
      body: summaryAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando ventas pendientes…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (summary) {
          if (summary == null || summary.pendingSales.isEmpty) {
            return const AppEmptyView(
              message: 'No hay ventas pendientes para abonar.',
              icon: Icons.check_circle_outline,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Modo de abono ────────────────────────────────────────
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Abono general'),
                      icon: Icon(Icons.all_inbox_outlined),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('A factura'),
                      icon: Icon(Icons.receipt_long_outlined),
                    ),
                  ],
                  selected: {_generalAbono},
                  onSelectionChanged: (sel) =>
                      setState(() => _generalAbono = sel.first),
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 16),

                // ── Saldo actual ───────────────────────────────────────
                _BalanceInfo(
                  balance: summary.totalOwed,
                  available: summary.availableCredit,
                ),
                const SizedBox(height: 20),

                // ── Seleccionar venta (solo modo específico) ────────────
                if (!_generalAbono) ...[
                  Row(
                    children: [
                      Text('Ventas a abonar', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      if (_selectedSaleIds.isNotEmpty)
                        TextButton(
                          onPressed: () => setState(() => _selectedSaleIds.clear()),
                          child: const Text('Limpiar'),
                        ),
                      TextButton(
                        onPressed: () => setState(() {
                          if (_selectedSaleIds.length == summary.pendingSales.length) {
                            _selectedSaleIds.clear();
                          } else {
                            _selectedSaleIds.addAll(summary.pendingSales.map((s) => s.saleId));
                          }
                        }),
                        child: Text(_selectedSaleIds.length == summary.pendingSales.length ? 'Ninguna' : 'Todas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...summary.pendingSales.map((sale) {
                    final selected = _selectedSaleIds.contains(sale.saleId);
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: selected,
                      onChanged: (v) => setState(() {
                        if (v == true) {
                          _selectedSaleIds.add(sale.saleId);
                        } else {
                          _selectedSaleIds.remove(sale.saleId);
                        }
                      }),
                      title: Text(
                        'Ticket ${sale.ticketNumber}  ·  Pendiente: ${AppFormatters.currency(sale.pending)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            ),
                      ),
                      subtitle: Text(
                        'Total: ${AppFormatters.currency(sale.total)}  ·  Pagado: ${AppFormatters.currency(sale.paid)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }),
                  if (_selectedSaleIds.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${_selectedSaleIds.length} venta(s) seleccionada(s) · Total pendiente: ${AppFormatters.currency(selectedPendingTotal(summary))}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],

                // ── Monto ──────────────────────────────────────────────
                TextField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Monto del abono',
                    prefixText: '\$ ',
                    border: const OutlineInputBorder(),
                    suffixText: _amount > 0
                        ? '/ ${AppFormatters.currency(!_generalAbono && _selectedSaleIds.isNotEmpty ? selectedPendingTotal(summary) : summary.totalOwed)}'
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),

                // ── Método de pago ──────────────────────────────────────
                Text('Método de pago', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableMethods.map((m) {
                    final selected = _selectedMethod == m.code;
                    return ChoiceChip(
                      label: Text(m.label),
                      avatar: Icon(m.iconData, size: 18),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedMethod = m.code),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // ── Botón submit ────────────────────────────────────────
                FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(
                          'Abonar ${_amount > 0 ? AppFormatters.currency(_amount) : ''}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BalanceInfo extends StatelessWidget {
  const _BalanceInfo({required this.balance, required this.available});
  final double balance;
  final double available;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: scheme.error, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total adeudado', style: Theme.of(context).textTheme.bodySmall),
              Text(
                AppFormatters.currency(balance),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: scheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          if (available > 0) ...[
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Cupo disponible', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  AppFormatters.currency(available),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ReceiptPreviewCard extends StatelessWidget {
  const _ReceiptPreviewCard({
    required this.receiptNumber,
    required this.amount,
    required this.methodName,
    required this.createdAt,
  });

  final String receiptNumber;
  final double amount;
  final String methodName;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt, color: scheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Comprobante',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            receiptNumber,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total abono', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                AppFormatters.currency(amount),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Método', style: Theme.of(context).textTheme.bodySmall),
              Text(
                methodName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fecha', style: Theme.of(context).textTheme.bodySmall),
              Text(
                AppFormatters.dateTime(createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
