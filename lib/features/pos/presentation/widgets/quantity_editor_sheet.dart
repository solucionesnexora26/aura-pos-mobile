import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../widgets/quantity_keypad.dart';

/// Editor de cantidad para un producto del carrito. Bottom sheet con stepper
/// −/+, cantidades rápidas y keypad numérico propio.
///
/// Confirma devolviendo la cantidad elegida (0 => eliminar el producto). La
/// aplicación real la hace el caller con [updateQuantity] (lógica existente).
class QuantityEditorSheet extends StatefulWidget {
  const QuantityEditorSheet({
    required this.productName,
    required this.initialQuantity,
    required this.maxQuantity,
    super.key,
  });

  final String productName;
  final double initialQuantity;
  final double maxQuantity;

  @override
  State<QuantityEditorSheet> createState() => _QuantityEditorSheetState();
}

class _QuantityEditorSheetState extends State<QuantityEditorSheet> {
  late int _qty = widget.initialQuantity.round();
  late final int _max = widget.maxQuantity.isFinite
      ? widget.maxQuantity.floor()
      : 1 << 30;

  bool get _hasStockLimit => widget.maxQuantity.isFinite;

  void _set(int value) {
    setState(() {
      _qty = value.clamp(0, _max);
    });
  }

  void _increment() => _set(_qty + 1);
  void _decrement() => _set(_qty - 1);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grip + título
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.productName,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _hasStockLimit
                    ? 'Stock disponible: ${AppFormatters.quantity(widget.maxQuantity)}'
                    : 'Sin límite de stock',
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              // Cantidad actual + stepper
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    _StepperButton(
                      icon: Icons.remove,
                      onTap: _qty <= 0 ? null : _decrement,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Text(
                          '$_qty',
                          key: ValueKey(_qty),
                          textAlign: TextAlign.center,
                          style: text.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ),
                    _StepperButton(
                      icon: Icons.add,
                      onTap: _qty >= _max ? null : _increment,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Cantidades rápidas
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final v in const [1, 2, 3, 5, 10, 20, 30, 50])
                  _QuickAmount(
                    value: v,
                    onTap: v > _max && _hasStockLimit ? null : () => _set(v),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Keypad
              QuantityKeypad(
                onDigit: (d) {
                  final next = _qty * 10 + d;
                  if (next > _max && _hasStockLimit) return;
                  _set(next);
                },
                onBackspace: () => _set(_qty ~/ 10),
                onConfirm: () => Navigator.of(context).pop(_qty.toDouble()),
              ),
              const SizedBox(height: 8),

              // Acciones
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(_qty.toDouble()),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    return Material(
      color: enabled ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: enabled ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _QuickAmount extends StatelessWidget {
  const _QuickAmount({required this.value, this.onTap});
  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = onTap != null;
    return ActionChip(
      label: Text('$value'),
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: selected
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: onTap,
    );
  }
}
