import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Barra resumen del carrito para el layout móvil. Muestra líneas, unidades y
/// total, y abre el carrito al tocarla. Reemplaza al antiguo FAB.
class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({
    required this.lineCount,
    required this.unitCount,
    required this.total,
    required this.onTap,
    super.key,
  });

  final int lineCount;
  final int unitCount;
  final double total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: scheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$lineCount ${lineCount == 1 ? 'producto' : 'productos'} · $unitCount ${unitCount == 1 ? 'unidad' : 'unidades'}',
                    style: text.labelSmall?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppFormatters.currency(total),
                    style: text.titleMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(Icons.chevron_right, color: scheme.onPrimary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
