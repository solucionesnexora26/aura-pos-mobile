import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/cash_register_tables.dart';
import '../providers/cash_register_providers.dart';

class CashRegisterPage extends ConsumerWidget {
  const CashRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerAsync = ref.watch(openCashRegisterProvider);
    final historyAsync = ref.watch(cashRegisterHistoryProvider);
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
        title: const Text('Caja'),
      ),
      body: registerAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando caja…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (register) {
          if (register == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: scheme.outline),
                  const SizedBox(height: 16),
                  Text('La caja está cerrada', style: text.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Debes abrir la caja antes de realizar ventas.',
                      style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.goNamed(RouteNames.cashRegisterOpen),
                    icon: const Icon(Icons.lock_open_outlined),
                    label: const Text('Abrir Caja'),
                  ),
                  const SizedBox(height: 32),
                  // Historial de turnos cerrados
                  historyAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (history) {
                      if (history.isEmpty) return const SizedBox.shrink();
                      final closed = history.where((r) => !r.isOpen).toList();
                      if (closed.isEmpty) return const SizedBox.shrink();
                      return SizedBox(
                        width: 400,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Turnos anteriores', style: text.titleSmall?.copyWith(color: scheme.primary)),
                                const Divider(height: 12),
                                ...closed.take(5).map((r) {
                                   final totalIncome = r.movements
                                       .where((m) => m.type == CashMovementType.income || m.type == CashMovementType.saleCash || m.type == CashMovementType.deposit)
                                       .fold(0.0, (sum, m) => sum + m.amount);
                                   final totalExpense = r.movements
                                       .where((m) => m.type == CashMovementType.expense || m.type == CashMovementType.withdrawal)
                                       .fold(0.0, (sum, m) => sum + m.amount);
                                  final balance = r.openingAmount + totalIncome - totalExpense;
                                  return ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.history, size: 18, color: scheme.onSurfaceVariant),
                                    title: Text(AppFormatters.dateTime(r.openedAt), style: text.bodySmall),
                                    subtitle: r.shiftLabel != null ? Text(r.shiftLabel!, style: text.bodySmall) : null,
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(AppFormatters.currency(balance), style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                                        if (r.difference != null && r.difference!.abs() >= 0.01)
                                          Text('Δ ${AppFormatters.currency(r.difference!)}',
                                              style: text.bodySmall?.copyWith(color: scheme.error, fontSize: 11)),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          final totalIncome = register.movements
              .where((m) => m.type == CashMovementType.saleCash || m.type == CashMovementType.deposit || m.type == CashMovementType.income)
              .fold(0.0, (sum, m) => sum + m.amount);
          final totalExpense = register.movements
              .where((m) => m.type == CashMovementType.expense || m.type == CashMovementType.withdrawal)
              .fold(0.0, (sum, m) => sum + m.amount);
          final currentBalance = register.openingAmount + totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen de caja
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(child: _Stat('Apertura', AppFormatters.currency(register.openingAmount), scheme)),
                          Expanded(child: _Stat('Ingresos', AppFormatters.currency(totalIncome), scheme, color: Colors.green)),
                          Expanded(child: _Stat('Egresos', AppFormatters.currency(totalExpense), scheme, color: scheme.error)),
                        ]),
                        const Divider(height: 24),
                        Row(children: [
                          Expanded(child: Text('Balance actual', style: text.titleMedium)),
                          Text(AppFormatters.currency(currentBalance),
                              style: text.titleLarge?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold)),
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          Expanded(child: Text('Abierta: ${AppFormatters.dateTime(register.openedAt)}',
                              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant))),
                        ]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Desglose por medio de pago ──────────────────────────
                _MethodBreakdownCard(movements: register.movements),

                const SizedBox(height: 16),

                // Acciones rápidas
                Row(children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_circle_outline,
                      label: 'Ingreso',
                      color: Colors.green,
                      onTap: () => _addMovement(context, ref, register.id, CashMovementType.income),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.remove_circle_outline,
                      label: 'Egreso',
                      color: scheme.error,
                      onTap: () => _addMovement(context, ref, register.id, CashMovementType.expense),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.lock_outline,
                      label: 'Cerrar Caja',
                      color: scheme.primary,
                      onTap: () => context.goNamed(RouteNames.cashRegisterClose),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // Historial de movimientos
                Text('Movimientos', style: text.titleSmall?.copyWith(color: scheme.primary)),
                const Divider(height: 8),
                if (register.movements.isEmpty)
                  const AppEmptyView(message: 'Sin movimientos registrados.', icon: Icons.list_alt_outlined)
                else
                  ...register.movements.take(20).map((m) {
                    final isPositive = m.type == CashMovementType.saleCash ||
                        m.type == CashMovementType.income ||
                        m.type == CashMovementType.openingFloat ||
                        m.type == CashMovementType.deposit;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: (isPositive ? Colors.green : scheme.error).withValues(alpha: 0.1),
                        child: Icon(
                          isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 14,
                          color: isPositive ? Colors.green : scheme.error,
                        ),
                      ),
                      title: Text(m.description ?? _movTypeLabel(m.type), style: text.bodyMedium),
                      subtitle: Text(
                        '${AppFormatters.dateTime(m.createdAt)}${m.method != null ? ' · ${_methodLabel(m.method!)}' : ''}',
                        style: text.bodySmall,
                      ),
                      trailing: Text(
                        '${isPositive ? '+' : '−'}${AppFormatters.currency(m.amount)}',
                        style: text.titleSmall?.copyWith(color: isPositive ? Colors.green : scheme.error),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  String _movTypeLabel(CashMovementType t) => switch (t) {
        CashMovementType.income => 'Ingreso',
        CashMovementType.expense => 'Egreso',
        CashMovementType.saleCash => 'Venta',
        CashMovementType.openingFloat => 'Apertura',
        CashMovementType.closingCount => 'Conteo de cierre',
        CashMovementType.withdrawal => 'Retiro',
        CashMovementType.deposit => 'Depósito',
      };

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

  void _addMovement(BuildContext context, WidgetRef ref, String registerId, CashMovementType type) {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String? dialogError;
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(type == CashMovementType.income ? 'Registrar Ingreso' : 'Registrar Egreso'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monto *')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
              if (dialogError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(dialogError!, style: TextStyle(color: Theme.of(ctx).colorScheme.error, fontSize: 12)),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                final amount = double.tryParse(amountCtrl.text.replaceAll(',', '.')) ?? 0;
                if (amount <= 0) {
                  setDialogState(() => dialogError = 'Ingresa un monto mayor a 0');
                  return;
                }
                final session = ref.read(authSessionProvider);
                final result = await ref.read(cashRegisterRepositoryProvider).addMovement(
                  registerId: registerId,
                  type: type,
                  amount: amount,
                  userId: session.user?.id ?? '',
                  description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                );
                result.fold(
                  (f) => setDialogState(() => dialogError = f.message),
                  (_) {
                    ref.invalidate(openCashRegisterProvider);
                    if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                  },
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.scheme, {this.color});
  final String label;
  final String value;
  final ColorScheme scheme;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color ?? scheme.onSurface)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// Tarjeta que desglosa lo recaudado por medio de pago (ventas + abonos).
class _MethodBreakdownCard extends StatelessWidget {
  const _MethodBreakdownCard({required this.movements});
  final List<CashMovementRow> movements;

  static const _methods = [
    (code: 0, label: 'Efectivo', color: Colors.green),
    (code: 1, label: 'Tarjeta', color: Colors.blue),
    (code: 2, label: 'Transferencia', color: Colors.indigo),
    (code: 3, label: 'Nequi', color: Colors.purple),
    (code: 4, label: 'Daviplata', color: Colors.orange),
    (code: 5, label: 'Mixto', color: Colors.teal),
    (code: 6, label: 'Crédito', color: Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Sumar por método los movimientos que representan recaudo (venta/abono).
    final byMethod = <int, double>{};
    for (final m in movements) {
      final isCollection =
          m.type == CashMovementType.saleCash || m.type == CashMovementType.income;
      if (!isCollection || m.method == null) continue;
      byMethod[m.method!] = (byMethod[m.method!] ?? 0) + m.amount;
    }

    final totalCollections = byMethod.values.fold(0.0, (a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payments_outlined, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text('Recaudado por medio de pago', style: text.titleSmall?.copyWith(color: scheme.primary)),
                const Spacer(),
                Text(AppFormatters.currency(totalCollections), style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
              ],
            ),
            const Divider(height: 20),
            if (byMethod.isEmpty)
              Text('Sin movimientos de recaudo.', style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant))
            else
              ..._methods.where((m) => byMethod.containsKey(m.code)).map((m) {
                final amount = byMethod[m.code]!;
                final share = totalCollections > 0 ? amount / totalCollections : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: m.color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(m.label, style: text.bodyMedium)),
                      Text(AppFormatters.currency(amount), style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 9),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '${(share * 100).toStringAsFixed(0)}%',
                          textAlign: TextAlign.right,
                          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
