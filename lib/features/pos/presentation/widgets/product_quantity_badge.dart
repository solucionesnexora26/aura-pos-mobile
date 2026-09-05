import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Badge de cantidad mostrado sobre la tarjeta de producto cuando el producto
/// ya está en el carrito. Al tocarlo abre el editor de cantidad.
///
/// Refleja directamente la cantidad real del carrito (única fuente de verdad).
/// Anima el cambio con una pequeña transición de escala (microinteracción).
class ProductQuantityBadge extends StatelessWidget {
  const ProductQuantityBadge({
    required this.quantity,
    required this.onTap,
    super.key,
  });

  /// Cantidad actual del producto en el carrito (>= 1).
  final double quantity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final qty = AppFormatters.quantity(quantity);

    return Semantics(
      button: true,
      label: 'Cantidad: $qty. Toca para editar',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_shopping_cart, size: 13, color: scheme.onPrimary),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    qty,
                    key: ValueKey(qty),
                    style: text.labelLarge?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
