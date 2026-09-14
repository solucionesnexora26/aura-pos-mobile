import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/tables/cash_register_tables.dart';
import '../../../../core/database/tables/sales_tables.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../pos/presentation/providers/cart_provider.dart';
import '../../../pos/presentation/providers/pos_providers.dart';
import '../providers/payment_methods_provider.dart';

class PaymentPage extends HookConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final selectedMethod = useState<PaymentMethod>(PaymentMethod.cash);
    final cashAmountCtrl = useTextEditingController(text: cart.total.toStringAsFixed(0));
    final referenceCtrl = useTextEditingController();
    final payments = useState<List<({PaymentMethod method, double amount, String? reference})>>([]);
    final isMixed = useState(false);
    final isProcessing = useState(false);
    final error = useState<String?>(null);

    // Métodos de pago activos configurados en el servidor (o fallback local).
    final serverMethods = ref.watch(activePaymentMethodsProvider).valueOrNull ?? [];
    final paymentMethods = serverMethods.isNotEmpty
        ? serverMethods
        : const [
            PaymentMethodConfig(code: 0, label: 'Efectivo', icon: 'banknote', isCredit: false),
            PaymentMethodConfig(code: 1, label: 'Tarjeta', icon: 'credit-card', isCredit: false),
            PaymentMethodConfig(code: 2, label: 'Transferencia', icon: 'arrow-left-right', isCredit: false),
            PaymentMethodConfig(code: 3, label: 'Nequi', icon: 'smartphone', isCredit: false),
            PaymentMethodConfig(code: 4, label: 'Daviplata', icon: 'smartphone', isCredit: false),
            PaymentMethodConfig(code: 5, label: 'Mixto', icon: 'arrow-left-right', isCredit: false),
            PaymentMethodConfig(code: 6, label: 'Crédito', icon: '', isCredit: true),
          ];

    final totalPaid = payments.value.fold(0.0, (sum, p) => sum + p.amount);
    final remaining = cart.total - totalPaid;
    final cashAmount = double.tryParse(cashAmountCtrl.text.replaceAll(',', '.')) ?? 0;
    final change = selectedMethod.value == PaymentMethod.cash ? cashAmount - remaining : 0.0;
    // Total cero o negativo: la venta queda a favor del cliente, no se cobra.
    final noPayment = cart.total <= 0;

    // Validación específica de la venta a crédito (método "Crédito").
    final isCredit = selectedMethod.value == PaymentMethod.credit;
    final String? creditError = _creditValidationError(isCredit, cart.customer, cart.total);

    Future<void> processPayment() async {
      isProcessing.value = true;
      error.value = null;

      // Bloquear la venta a crédito si no hay cliente, supera el cupo o el
      // total no es positivo.
      final String? invalidCredit = _creditValidationError(
        isCredit,
        cart.customer,
        cart.total,
      );
      if (invalidCredit != null) {
        isProcessing.value = false;
        error.value = invalidCredit;
        return;
      }

      // Devoluciones que dejan el total en cero o negativo no generan ingresos:
      // se registra un pago simbólico de $0 y el cajero entrega el saldo a
      // favor al cliente desde la caja.
      final allPayments = noPayment
          ? [
              (
                method: PaymentMethod.cash,
                amount: 0.0,
                reference: 'Total a favor del cliente',
              )
            ]
          : (isMixed.value
              ? payments.value
              : [
                  (
                    method: selectedMethod.value,
                    amount: selectedMethod.value == PaymentMethod.cash
                        ? cashAmount
                        : remaining,
                    reference: referenceCtrl.text.trim().isEmpty
                        ? null
                        : referenceCtrl.text.trim(),
                  )
                ]);

      final session = ref.read(authSessionProvider);
      final saleRepo = ref.read(saleRepositoryProvider);
      final cashRepo = ref.read(cashRegisterRepositoryProvider);

      if (session.user == null || !Validators.isValidUuid(session.user!.id)) {
        isProcessing.value = false;
        error.value = 'La sesión del empleado no es válida. Inicie sesión nuevamente.';
        return;
      }
      final userId = session.user!.id;

      // Obtener la caja abierta para vincularla a la venta
      String? cashRegisterId;
      final openRegResult = await cashRepo.getOpenRegister();
      openRegResult.fold(
        (f) => debugPrint('[CASH_REGISTER][WARN] getOpenRegister failed: ${f.message} — sale without cash linkage'),
        (reg) => cashRegisterId = reg?.id,
      );

      // Si no hay saleId, primero creamos la venta como abierta
      String saleId = cart.openSaleId ?? '';
      if (saleId.isEmpty) {
        final createResult = await saleRepo.createOpenSale(
          cart,
          userId,
          cashRegisterId,
        );
        createResult.fold(
          (f) { error.value = f.message; isProcessing.value = false; return; },
          (sale) => saleId = sale.id,
        );
        if (error.value != null) return;
      }

      final result = await saleRepo.completeSale(
        saleId: saleId,
        cart: cart,
        payments: allPayments,
        changeGiven: noPayment ? 0 : (change > 0 ? change : 0),
        userId: userId,
      );

      if (result.isLeft()) {
        isProcessing.value = false;
        result.fold((f) => error.value = f.message, (_) {});
        return;
      }

      final sale = result.getRight().toNullable();
      if (sale == null) {
        isProcessing.value = false;
        error.value = 'Error desconocido al crear la venta.';
        return;
      }

      debugPrint('[SALE] sale created: ${sale.id} (cashRegisterId=$cashRegisterId)');

      // Registrar movimientos de caja para todos los medios de pago
      if (cashRegisterId != null) {
        for (final p in allPayments) {
          if (p.amount > 0) {
            debugPrint('[CASH_REGISTER] creating movement: method=${p.method.name} amount=${p.amount} registerId=$cashRegisterId');
            final movResult = await cashRepo.addMovement(
              registerId: cashRegisterId!,
              type: CashMovementType.saleCash,
              amount: p.amount,
              userId: userId,
              description: 'Venta ${sale.ticketNumber}',
              saleId: sale.id,
              method: p.method.index,
            );
            movResult.fold(
              (f) => debugPrint('[CASH_REGISTER][ERROR] addMovement failed: ${f.message}'),
              (_) => debugPrint('[CASH_REGISTER] movement created OK: ${p.method.name}'),
            );
          }
        }
        ref.invalidate(openCashRegisterProvider);
      } else {
        debugPrint('[CASH_REGISTER] cashRegisterId is NULL — no movement created');
      }

      ref.read(lastCompletedSaleProvider.notifier).state = sale;
      ref.read(cartProvider.notifier).clear();
      // Sube la venta a Supabase en segundo plano (fire-and-forget).
      debugPrint('[SALE] triggering push for sale: ${sale.id}');
      ref.read(syncControllerProvider.notifier).push().then((_) {
        debugPrint('[SALE] push completed for sale: ${sale.id}');
      }).catchError((Object e, StackTrace st) {
        debugPrint('[SALE][ERROR] push failed for sale: ${sale.id}');
        debugPrint('[SALE][ERROR] $e');
        debugPrint('[SALE][ERROR] $st');
      });

      isProcessing.value = false;
      if (context.mounted) {
        context.goNamed(RouteNames.receiptPreview, queryParameters: {'saleId': sale.id});
      }
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Cobrar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (cart.customer != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(children: [
                          const Icon(Icons.person_outline, size: 16),
                          const SizedBox(width: 8),
                          Text(cart.customer!.fullName, style: text.bodyMedium),
                        ]),
                      ),
                    Row(children: [
                      Expanded(child: Text('Subtotal', style: text.bodyMedium)),
                      Text(AppFormatters.currency(cart.subtotal), style: text.bodyMedium),
                    ]),
                    if (cart.discountTotal > 0)
                      Row(children: [
                        Expanded(child: Text('Descuento', style: text.bodyMedium)),
                        Text('−${AppFormatters.currency(cart.discountTotal)}',
                            style: text.bodyMedium?.copyWith(color: scheme.error)),
                      ]),
                    if (cart.taxTotal > 0)
                      Row(children: [
                        Expanded(child: Text('Impuestos', style: text.bodyMedium)),
                        Text(AppFormatters.currency(cart.taxTotal), style: text.bodyMedium),
                      ]),
                    if (cart.hasReturns) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          const Icon(Icons.undo, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Devoluciones',
                              style: text.bodyMedium?.copyWith(
                                color: scheme.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '−${AppFormatters.currency(cart.returnsTotal.abs())}',
                            style: text.bodyMedium?.copyWith(
                              color: scheme.onErrorContainer,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ]),
                      ),
                    ],
                    const Divider(height: 16),
                    Row(children: [
                      Expanded(child: Text('Total', style: text.titleLarge)),
                      Text(AppFormatters.currency(cart.total.abs()),
                          style: text.titleLarge?.copyWith(
                              color: cart.total < 0
                                  ? scheme.error
                                  : scheme.primary)),
                    ]),
                    if (cart.total < 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Total A FAVOR del cliente: '
                            '${AppFormatters.currency(cart.total.abs())}. '
                            'Entregue este valor al cliente desde la caja.',
                            style: text.bodyMedium?.copyWith(
                              color: scheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (noPayment) ...[
              const SizedBox(height: 24),
              Card(
                color: scheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Icon(Icons.currency_exchange,
                        color: scheme.onTertiaryContainer, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cart.total < 0
                            ? 'Esta venta entrega ${AppFormatters.currency(cart.total.abs())} al cliente. No se cobra ningún método de pago.'
                            : 'Venta neta en cero. No se cobra ningún método de pago.',
                        style: TextStyle(color: scheme.onTertiaryContainer),
                      ),
                    ),
                  ]),
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),

              // Método de pago
              Text('Método de pago', style: text.titleSmall?.copyWith(color: scheme.primary)),
              const Divider(height: 8),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: paymentMethods.map((pm) {
                  final m = pm.paymentMethod;
                  final label = pm.label;
                  final icon = pm.iconData;
                  return ChoiceChip(
                    label: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(icon, size: 16),
                      const SizedBox(width: 6),
                      Text(label),
                    ]),
                    selected: selectedMethod.value == m && !isMixed.value,
                    onSelected: (_) {
                      selectedMethod.value = m;
                      isMixed.value = false;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Campo de monto
              if (selectedMethod.value == PaymentMethod.cash) ...[
                TextField(
                  controller: cashAmountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monto recibido',
                    prefixIcon: const Icon(Icons.attach_money),
                    suffix: change > 0
                        ? Text('Cambio: ${AppFormatters.currency(change)}',
                            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold))
                        : null,
                  ),
                ),
              ] else if (selectedMethod.value == PaymentMethod.credit) ...[
                Card(
                  color: scheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          color: scheme.onPrimaryContainer, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cart.customer == null
                              ? 'Requiere seleccionar un cliente.'
                              : 'Se cobrará a crédito a ${cart.customer!.fullName}.',
                          style: TextStyle(color: scheme.onPrimaryContainer),
                        ),
                      ),
                    ]),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: referenceCtrl,
                  decoration: InputDecoration(
                    labelText: _refLabel(selectedMethod.value),
                    prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  ),
                ),
              ],
            ],

            if (error.value != null || creditError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    error.value ?? creditError!,
                    style: TextStyle(color: scheme.onErrorContainer),
                  ),
                ),
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isProcessing.value || creditError != null
                    ? null
                    : processPayment,
                icon: isProcessing.value
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  cart.total <= 0
                      ? 'Confirmar (total a favor del cliente)'
                      : 'Confirmar pago ${AppFormatters.currency(cart.total)}',
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _refLabel(PaymentMethod m) => switch (m) {
        PaymentMethod.card => 'Últimos 4 dígitos',
        PaymentMethod.transfer => 'Número de referencia',
        PaymentMethod.nequi => 'Número de transacción',
        PaymentMethod.daviplata => 'Número de transacción',
        _ => 'Referencia',
      };

  /// Valida la venta a crédito. Devuelve null si es válida o un mensaje de
  /// error. Solo aplica cuando el método seleccionado es [PaymentMethod.credit].
  ///
  /// Regla de cupo (coherente con el RPC `register_credit_sale`): solo se
  /// bloquea si el cliente tiene un cupo definido (> 0) y lo supera. Si el
  /// cupo es 0, el backend usa `default_credit_limit` global; aquí no se
  /// bloquea y la validación definitiva la hace el servidor.
  String? _creditValidationError(
      bool isCredit, CustomerEntity? customer, double total) {
    if (!isCredit) return null;
    if (total <= 0) return 'No se puede cobrar a crédito una venta con total menor o igual a cero.';
    if (customer == null) return 'Selecciona un cliente para la venta a crédito.';
    if (customer.creditLimit > 0 && customer.availableCredit < total) {
      return 'Cupo insuficiente. Disponible para crédito: '
          '${AppFormatters.currency(customer.availableCredit)}.';
    }
    return null;
  }
}
