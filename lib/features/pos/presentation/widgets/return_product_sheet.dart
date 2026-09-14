import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../products/domain/entities/product_entity.dart';

/// Selección confirmada de una devolución.
typedef ReturnSelection = ({
  double quantity,
  String reason,
  String? returnedFromTicket,
});

/// Registrar una devolución. Bottom sheet con cantidad (sin tope de stock),
/// motivo obligatorio y ticket original opcional.
///
/// Confirma devolviendo una [ReturnSelection]; el caller la aplica con
/// [CartNotifier.addReturnProduct].
class ReturnProductSheet extends StatefulWidget {
  const ReturnProductSheet({
    required this.product,
    this.variant,
    super.key,
  });

  final ProductEntity product;
  final ProductVariantEntity? variant;

  static const List<({String code, String label})> reasons = [
    (code: 'deterioro', label: 'Deterioro'),
    (code: 'vencimiento', label: 'Vencimiento'),
    (code: 'no_aceptacion', label: 'No aceptación'),
    (code: 'otro', label: 'Otro'),
  ];

  @override
  State<ReturnProductSheet> createState() => _ReturnProductSheetState();
}

class _ReturnProductSheetState extends State<ReturnProductSheet> {
  int _qty = 1;
  String _reason = 'otro';
  final _ticketCtrl = TextEditingController();

  String get _displayName => widget.variant != null
      ? '${widget.product.name} — ${widget.variant!.name}'
      : widget.product.name;

  @override
  void dispose() {
    _ticketCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    void confirm() {
      final ticket = _ticketCtrl.text.trim();
      Navigator.of(context).pop<ReturnSelection>((
        quantity: _qty.toDouble(),
        reason: _reason,
        returnedFromTicket: ticket.isEmpty ? null : ticket,
      ));
    }

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
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.undo, color: scheme.onErrorContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registrar devolución',
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          _displayName,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cantidad (sin tope de stock: el producto se reincorpora al
              // inventario automáticamente).
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _StepButton(
                          icon: Icons.remove,
                          onTap: _qty <= 1 ? null : () => setState(() => _qty--),
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
                                color: scheme.error,
                              ),
                            ),
                          ),
                        ),
                        _StepButton(
                          icon: Icons.add,
                          onTap: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Se reincorporará al inventario',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final v in const [1, 2, 3, 5, 10])
                  ActionChip(
                    label: Text('$v'),
                    backgroundColor: scheme.surfaceContainerHighest,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () => setState(() => _qty = v),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Motivo
              Text(
                'Motivo de la devolución',
                style: text.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ReturnProductSheet.reasons.map((r) {
                  final selected = _reason == r.code;
                  return ChoiceChip(
                    label: Text(r.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _reason = r.code),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Ticket original (opcional)
              TextField(
                controller: _ticketCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Ticket original (opcional)',
                  hintText: 'Ej: TPV-2609-0007',
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

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
                    child: FilledButton.icon(
                      onPressed: confirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.error,
                        foregroundColor: scheme.onError,
                      ),
                      icon: const Icon(Icons.undo, size: 18),
                      label: Text(
                        'Devolver ${AppFormatters.quantity(_qty.toDouble())}',
                      ),
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

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    return Material(
      color: enabled
          ? scheme.errorContainer
          : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: enabled ? scheme.onErrorContainer : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}