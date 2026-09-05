import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../cash_register/presentation/providers/cash_register_providers.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../domain/entities/cart_entity.dart';
import '../providers/pos_providers.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Column(
      children: [
        // ── Header de la venta ──────────────────────────────────────────────
        _CartHeader(cart: cart, ref: ref),

        // ── Selector de cliente ─────────────────────────────────────────────
        _CustomerChip(cart: cart, ref: ref),

        // ── Lista de productos (scrollable) ─────────────────────────────────
        Expanded(
          child: cart.isEmpty
              ? const _EmptyCartView()
              : _CartItemList(cart: cart),
        ),

        // ── Resumen fijo + botón cobrar ─────────────────────────────────────
        if (!cart.isEmpty) _CartFooter(cart: cart),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// HEADER
// ═════════════════════════════════════════════════════════════════════════════

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.cart, required this.ref});
  final CartState cart;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart.openSaleLabel ?? 'Venta actual',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (cart.openSaleLabel != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Venta guardada',
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!cart.isEmpty) ...[
                _ActionChip(
                  icon: Icons.save_outlined,
                  label: 'Guardar',
                  onTap: () => _saveOpenSale(context, ref, cart),
                ),
                const SizedBox(width: 8),
                _ActionChip(
                  icon: Icons.delete_outline,
                  label: 'Vaciar',
                  onTap: () => _confirmClear(context, ref),
                  isDestructive: true,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveOpenSale(BuildContext context, WidgetRef ref, CartState cart) async {
    final labelCtrl = TextEditingController(text: cart.openSaleLabel);
    final label = await showDialog<String>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Guardar venta abierta'),
        content: TextField(
          controller: labelCtrl,
          decoration: const InputDecoration(
            labelText: 'Etiqueta (ej: Mesa 5, Cliente Pérez)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, labelCtrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (label == null || !context.mounted) return;

    final session = ref.read(authSessionProvider);
    final notifier = ref.read(cartProvider.notifier);
    final saleRepo = ref.read(saleRepositoryProvider);
    final newLabel = label.isEmpty ? null : label;

    // Obtener la caja abierta para vincularla a la venta
    String? cashRegisterId;
    final openRegResult = await ref.read(cashRegisterRepositoryProvider).getOpenRegister();
    openRegResult.fold((_) {}, (reg) => cashRegisterId = reg?.id);

    final result = cart.openSaleId != null
        ? await saleRepo.updateOpenSale(cart.openSaleId!, cart.copyWith(openSaleLabel: newLabel))
        : await saleRepo.createOpenSale(
            cart.copyWith(openSaleLabel: newLabel),
            session.user?.id ?? '',
            cashRegisterId,
          );

    result.fold(
      (f) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo guardar la venta: ${f.message}')),
          );
        }
      },
      (sale) {
        notifier.clear();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venta guardada.')),
          );
        }
      },
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text('¿Eliminar todos los productos del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );
    if (ok == true) ref.read(cartProvider.notifier).clear();
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isDestructive ? scheme.error : scheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDestructive
              ? scheme.errorContainer.withValues(alpha: 0.4)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CLIENTE
// ═════════════════════════════════════════════════════════════════════════════

class _CustomerChip extends ConsumerWidget {
  const _CustomerChip({required this.cart, required this.ref});
  final CartState cart;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final customer = cart.customer;

    return InkWell(
      onTap: () => _selectCustomer(context, ref),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: customer != null
              ? scheme.primaryContainer.withValues(alpha: 0.3)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              customer != null ? Icons.person : Icons.person_add_outlined,
              size: 18,
              color: customer != null ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                customer?.fullName ?? 'Cliente ocasional',
                style: text.bodyMedium?.copyWith(
                  color: customer != null ? scheme.onSurface : scheme.onSurfaceVariant,
                  fontWeight: customer != null ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (customer != null)
              IconButton(
                icon: Icon(Icons.close, size: 16, color: scheme.onSurfaceVariant),
                onPressed: () => ref.read(cartProvider.notifier).setCustomer(null),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              )
            else
              Icon(Icons.chevron_right, size: 18, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _selectCustomer(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CustomerPickerSheet(ref: ref),
    );
  }
}

class _CustomerPickerSheet extends ConsumerWidget {
  const _CustomerPickerSheet({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersStreamProvider);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Seleccionar cliente',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          customersAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Text(e.toString()),
            data: (customers) => SizedBox(
              height: 300,
              child: ListView.separated(
                itemCount: customers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, i) {
                  final c = customers[i];
                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: CircleAvatar(
                      backgroundColor: scheme.primaryContainer,
                      child: Text(
                        c.fullName[0].toUpperCase(),
                        style: TextStyle(color: scheme.onPrimaryContainer),
                      ),
                    ),
                    title: Text(c.fullName),
                    subtitle: Text(c.type.label),
                    onTap: () {
                      ref.read(cartProvider.notifier).setCustomer(c);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LISTA DE PRODUCTOS
// ═════════════════════════════════════════════════════════════════════════════

class _CartItemList extends StatelessWidget {
  const _CartItemList({required this.cart});
  final CartState cart;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, i) => _CartItemTile(item: cart.items[i]),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});
  final CartItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final notifier = ref.read(cartProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // ── Icono del producto ──────────────────────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item.product.name.substring(0, 1).toUpperCase(),
                style: text.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Nombre + precio unitario + controles ───────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppFormatters.currency(item.unitPrice)} /ud',
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                // Controles de cantidad
                Container(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () => notifier.updateQuantity(item.id, item.quantity - 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppFormatters.quantity(item.quantity),
                          style: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () => notifier.updateQuantity(item.id, item.quantity + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ── Precio total + eliminar ────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.delete_outline, size: 16, color: scheme.error),
                onPressed: () => _confirmRemove(context, ref, notifier),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 4),
              Text(
                AppFormatters.currency(item.lineTotal),
                style: text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref, CartNotifier notifier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar "${item.product.name}" del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) notifier.removeItem(item.id);
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: scheme.onSurfaceVariant),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CARRITO VACÍO
// ═════════════════════════════════════════════════════════════════════════════

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 32,
                color: scheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tu venta está vacía',
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Agrega productos para comenzar',
              style: text.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// FOOTER — RESUMEN + BOTÓN COBRAR
// ═════════════════════════════════════════════════════════════════════════════

class _CartFooter extends StatelessWidget {
  const _CartFooter({required this.cart});
  final CartState cart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal
          _SummaryRow(
            label: 'Subtotal',
            value: AppFormatters.currency(cart.subtotal),
            icon: Icons.receipt_outlined,
          ),
          // Descuento
          if (cart.discountTotal > 0)
            _SummaryRow(
              label: 'Descuento',
              value: '−${AppFormatters.currency(cart.discountTotal)}',
              icon: Icons.local_offer_outlined,
              valueColor: scheme.error,
            ),
          // Impuestos
          if (cart.taxTotal > 0)
            _SummaryRow(
              label: 'Impuestos',
              value: AppFormatters.currency(cart.taxTotal),
              icon: Icons.percent,
            ),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          // Total
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: scheme.onSurface,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Total',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                AppFormatters.currency(cart.total),
                style: text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Botón Cobrar
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => context.goNamed(RouteNames.payment),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Cobrar ${AppFormatters.currency(cart.total)}',
                    style: text.labelLarge?.copyWith(
                      color: scheme.onPrimary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: text.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? scheme.onSurface,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
