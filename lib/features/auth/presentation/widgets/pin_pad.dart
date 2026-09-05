import 'package:flutter/material.dart';

/// Teclado numérico reutilizable para entrada de PIN. Emite eventos de
/// dígito y acción (borrar, limpiar). Sensible a tema claro/oscuro.
class PinPad extends StatelessWidget {
  const PinPad({
    required this.onDigit,
    required this.onBackspace,
    super.key,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  static const List<String> _digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ..._digits.map(
          (digit) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onDigit(digit),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    digit,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBackspace,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.backspace_outlined, color: scheme.onSurface),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
