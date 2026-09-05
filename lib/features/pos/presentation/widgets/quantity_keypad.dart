import 'package:flutter/material.dart';

/// Teclado numérico propio para el editor de cantidad. Botones grandes y
/// táctiles (>= 56 px), consistente con la identidad visual de Aura POS.
class QuantityKeypad extends StatelessWidget {
  const QuantityKeypad({
    required this.onDigit,
    required this.onBackspace,
    required this.onConfirm,
    super.key,
  });

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onConfirm;

  static const List<List<int>> _rows = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Widget key(Widget child, {VoidCallback? onTap, Color? background}) {
      return Expanded(
        child: AspectRatio(
          aspectRatio: 1.55,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: background ?? scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    Widget gap() => const SizedBox(width: 10);

    return Column(
      children: [
        for (final row in _rows) ...[
          Row(
            children: [
              gap(),
              ...row.map((d) => key(
                    Text(
                      '$d',
                      style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => onDigit(d),
                  )),
              gap(),
            ],
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            gap(),
            key(
              Icon(Icons.backspace_outlined, color: scheme.onSurface),
              onTap: onBackspace,
            ),
            gap(),
            key(
              Text('0', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              onTap: () => onDigit(0),
            ),
            gap(),
            key(
              Icon(Icons.check, color: scheme.onPrimary),
              onTap: onConfirm,
              background: scheme.primary,
            ),
            gap(),
          ],
        ),
      ],
    );
  }
}
