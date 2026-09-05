import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/tables/cash_register_tables.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../providers/cash_register_providers.dart';
import '../providers/tpv_inventory_provider.dart';

class CashRegisterClosePage extends HookConsumerWidget {
  const CashRegisterClosePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerAsync = ref.watch(openCashRegisterProvider);
    final countedCtrl = useTextEditingController();
    final noteCtrl = useTextEditingController();
    final isLoading = useState(false);
    final error = useState<String?>(null);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cerrar Caja')),
      body: registerAsync.when(
        loading: () => const AppLoadingView(),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (register) {
          if (register == null) {
            return const AppEmptyView(message: 'No hay caja abierta.', icon: Icons.lock_outline);
          }

          // Calcular esperado
          final saleCashMovements = register.movements
              .where((m) => m.type == CashMovementType.saleCash)
              .toList();
          final totalSales = saleCashMovements.fold(0.0, (sum, m) => sum + m.amount);
          final salesCount = saleCashMovements.length;
          // Abonos: ingresos con medio de pago definido (vienen del módulo Cartera).
          final abonoMovements = register.movements
              .where((m) => m.type == CashMovementType.income && m.method != null)
              .toList();
          final totalAbonos = abonoMovements.fold(0.0, (sum, m) => sum + m.amount);
          final abonosCount = abonoMovements.length;
          // Otros ingresos manuales: income sin medio de pago + depósitos.
          final manualIncomeMovements = register.movements
              .where((m) =>
                  (m.type == CashMovementType.income && m.method == null) ||
                  m.type == CashMovementType.deposit)
              .toList();
          final manualIncome = manualIncomeMovements.fold(0.0, (sum, m) => sum + m.amount);
          final totalIncome = totalSales + totalAbonos + manualIncome;
          final totalExpense = register.movements
              .where((m) => m.type == CashMovementType.expense || m.type == CashMovementType.withdrawal)
              .fold(0.0, (sum, m) => sum + m.amount);
          final expectedAmount = register.openingAmount + totalIncome - totalExpense;

          final counted = double.tryParse(countedCtrl.text.replaceAll(',', '.')) ?? 0;
          final diff = counted - expectedAmount;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.lock_outline, size: 48, color: scheme.primary),
                    const SizedBox(height: 12),
                    Text('Cierre de Caja', style: text.headlineSmall),
                    const SizedBox(height: 24),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _Row('Abierta', AppFormatters.dateTime(register.openedAt), text),
                            _Row('Monto inicial', AppFormatters.currency(register.openingAmount), text),
                            const Divider(height: 16),
                            if (salesCount > 0) ...[
                              _Row('Ventas ($salesCount)', AppFormatters.currency(totalSales), text, color: Colors.green),
                            ],
                            if (abonosCount > 0) ...[
                              _Row('Abonos ($abonosCount)', AppFormatters.currency(totalAbonos), text, color: Colors.green),
                            ],
                            if (manualIncome > 0) ...[
                              _Row('Otros ingresos', AppFormatters.currency(manualIncome), text, color: Colors.green),
                            ],
                            if (salesCount == 0 && abonosCount == 0 && manualIncome == 0 && totalIncome > 0) ...[
                              _Row('Ingresos', AppFormatters.currency(totalIncome), text, color: Colors.green),
                            ],
                            _Row('Egresos', AppFormatters.currency(totalExpense), text, color: scheme.error),
                            const Divider(height: 16),
                            _Row('Esperado en caja', AppFormatters.currency(expectedAmount), text, bold: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Cotejo de ruta (inventario por TPV) ──────────────
                    _CotejoRutaCard(register: register),

                    const SizedBox(height: 16),

                    TextField(
                      controller: countedCtrl,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {},
                      decoration: const InputDecoration(labelText: 'Monto contado en caja', prefixIcon: Icon(Icons.calculate_outlined)),
                    ),
                    if (countedCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: diff.abs() < 0.01 ? Colors.green.withValues(alpha: 0.1) : scheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          Icon(diff.abs() < 0.01 ? Icons.check_circle : Icons.warning_amber, color: diff.abs() < 0.01 ? Colors.green : scheme.error),
                          const SizedBox(width: 8),
                          Text('Diferencia: ${AppFormatters.currency(diff)}',
                              style: text.bodyMedium?.copyWith(color: diff.abs() < 0.01 ? Colors.green : scheme.error)),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteCtrl,
                      decoration: const InputDecoration(labelText: 'Nota de cierre (opcional)'),
                      maxLines: 2,
                    ),
                    if (error.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(error.value!, style: TextStyle(color: scheme.error)),
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLoading.value ? null : () async {
                          final counted = double.tryParse(countedCtrl.text.replaceAll(',', '.')) ?? 0;
                          isLoading.value = true;
                          error.value = null;
                          final result = await ref.read(cashRegisterRepositoryProvider).closeRegister(
                            registerId: register.id,
                            countedAmount: counted,
                            expectedAmount: expectedAmount,
                            note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                          );
                          isLoading.value = false;
                          result.fold(
                            (f) => error.value = f.message,
                            (closedReg) {
                              ref.invalidate(openCashRegisterProvider);
                              ref.invalidate(cashRegisterHistoryProvider);
                              if (!context.mounted) return;
                              // Mostrar resumen del cierre
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogCtx) => AlertDialog(
                                  icon: Icon(
                                    (closedReg.difference ?? 0).abs() < 0.01
                                        ? Icons.check_circle
                                        : Icons.warning_amber,
                                    color: (closedReg.difference ?? 0).abs() < 0.01
                                        ? Colors.green
                                        : scheme.error,
                                    size: 48,
                                  ),
                                  title: const Text('Caja cerrada'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _SummaryRow('Abierta', AppFormatters.dateTime(closedReg.openedAt)),
                                        _SummaryRow('Cerrada', AppFormatters.dateTime(closedReg.closedAt ?? DateTime.now())),
                                        const Divider(),
                                        _SummaryRow('Monto inicial', AppFormatters.currency(closedReg.openingAmount)),
                                        if (salesCount > 0)
                                          _SummaryRow('Ventas ($salesCount)', AppFormatters.currency(totalSales), color: Colors.green),
                                        if (abonosCount > 0)
                                          _SummaryRow('Abonos ($abonosCount)', AppFormatters.currency(totalAbonos), color: Colors.green),
                                        if (manualIncome > 0)
                                          _SummaryRow('Otros ingresos', AppFormatters.currency(manualIncome), color: Colors.green),
                                        _SummaryRow('Ingresos totales', AppFormatters.currency(totalIncome), color: Colors.green),
                                        _SummaryRow('Egresos', AppFormatters.currency(totalExpense), color: scheme.error),
                                        _SummaryRow('Esperado', AppFormatters.currency(expectedAmount), bold: true),
                                        const Divider(),
                                        _SummaryRow('Contado', AppFormatters.currency(counted)),
                                        _SummaryRow(
                                          'Diferencia',
                                          AppFormatters.currency(closedReg.difference ?? 0),
                                          color: (closedReg.difference ?? 0).abs() < 0.01 ? Colors.green : scheme.error,
                                          bold: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(dialogCtx);
                                        context.goNamed(RouteNames.cashRegister);
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('Cerrar Caja'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _Row(String label, String value, TextTheme text, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(label, style: text.bodyMedium)),
        Text(value, style: bold ? text.titleSmall?.copyWith(color: color) : text.bodyMedium?.copyWith(color: color)),
      ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.color, this.bold = false});
  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(label, style: text.bodyMedium)),
        Text(
          value,
          style: bold
              ? text.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w700)
              : text.bodyMedium?.copyWith(color: color),
        ),
      ]),
    );
  }
}

/// Sección de cotejo de ruta: muestra el inventario restante del vehículo (TPV)
/// y permite capturar la devolución de cada producto. Calcula el faltante
/// (devuelto vs esperado) y el efectivo esperado.
class _CotejoRutaCard extends ConsumerWidget {
  const _CotejoRutaCard({required this.register});
  final CashRegisterEntity register;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(currentTpvStockProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: stockAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error al cargar cotejo: $e',
              style: text.bodySmall?.copyWith(color: scheme.error)),
          data: (items) {
            if (items.isEmpty) {
              return Text(
                'Sin inventario asignado a este vehículo. Carga el inventario en la web antes de iniciar la ruta.',
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              );
            }
            return _CotejoRutaList(items: items);
          },
        ),
      ),
    );
  }
}

class _CotejoRutaList extends StatefulWidget {
  const _CotejoRutaList({required this.items});
  final List<StockItem> items;

  @override
  State<_CotejoRutaList> createState() => _CotejoRutaListState();
}

class _CotejoRutaListState extends State<_CotejoRutaList> {
  final Map<String, TextEditingController> _ctrls = {};

  @override
  void initState() {
    super.initState();
    for (final it in widget.items) {
      _ctrls[it.id] = TextEditingController(text: it.stock.toStringAsFixed(0));
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  double _returned(String id) => double.tryParse(_ctrls[id]!.text.replaceAll(',', '.')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    double totalLoaded() => widget.items.fold(0, (s, it) => s + it.stock);
    double totalReturned() => widget.items.fold(0, (s, it) => s + _returned(it.id));
    double missing() => (totalLoaded() - totalReturned()).clamp(0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.inventory_2_outlined, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text('Cotejo de ruta', style: text.titleSmall?.copyWith(color: scheme.primary)),
        ]),
        const Divider(height: 16),
        ...widget.items.map((it) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it.name, style: text.bodyMedium),
                    Text(
                      'Disponible: ${AppFormatters.currency(it.stock)}',
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _ctrls[it.id],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Devuelto',
                    isDense: true,
                  ),
                ),
              ),
            ]),
          );
        }),
        const Divider(height: 16),
        _RowCotejo('Total cargado', AppFormatters.currency(totalLoaded()), text),
        _RowCotejo('Total devuelto', AppFormatters.currency(totalReturned()), text,
            color: Colors.orange),
        _RowCotejo('Faltante / merma', AppFormatters.currency(missing()), text,
            color: missing() > 0 ? scheme.error : Colors.green, bold: true),
      ],
    );
  }
}

class _RowCotejo extends StatelessWidget {
  const _RowCotejo(this.label, this.value, this.text, {this.color, this.bold = false});
  final String label;
  final String value;
  final TextTheme text;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(label, style: text.bodyMedium)),
        Text(value,
            style: bold
                ? text.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w700)
                : text.bodyMedium?.copyWith(color: color)),
      ]),
    );
  }
}
