import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/credit_entities.dart';
import '../providers/credit_providers.dart';

/// Página dedicada de historial de abonos (comprobantes).
///
/// Muestra todos los comprobantes de abono emitidos, ordenados del más
/// reciente al más antiguo.
class AbonoHistoryPage extends ConsumerStatefulWidget {
  const AbonoHistoryPage({super.key});

  @override
  ConsumerState<AbonoHistoryPage> createState() => _AbonoHistoryPageState();
}

class _AbonoHistoryPageState extends ConsumerState<AbonoHistoryPage> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(allReceiptsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de abonos'),
      ),
      body: receiptsAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando abonos…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (receipts) {
          if (receipts.isEmpty) {
            return const AppEmptyView(
              message: 'No hay abonos registrados.',
              icon: Icons.receipt_long,
            );
          }

          // ── Filtrado por búsqueda ───────────────────────────────────
          final filtered = _search.isEmpty
              ? receipts
              : receipts.where((r) =>
                  r.receiptNumber.toLowerCase().contains(_search.toLowerCase()) ||
                  (r.customerName ?? '').toLowerCase().contains(_search.toLowerCase())).toList();

          final totalAmount = filtered.fold<double>(0, (s, r) => s + r.totalAmount);

          return Column(
            children: [
              // ── Resumen ──────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: scheme.primaryContainer.withValues(alpha: 0.3),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long, color: scheme.primary, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      '${filtered.length} abono(s)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      AppFormatters.currency(totalAmount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              // ── Buscador ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar por comprobante o cliente…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  ),
                ),
              ),

              // ── Lista ────────────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? const AppEmptyView(
                        message: 'No se encontraron abonos.',
                        icon: Icons.search_off,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) => _ReceiptTile(receipt: filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.receipt});
  final PaymentReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: scheme.tertiaryContainer,
          child: Icon(Icons.receipt, size: 18, color: scheme.onTertiaryContainer),
        ),
        title: Text(
          receipt.receiptNumber,
          style: text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${receipt.customerName ?? "—"} · ${AppFormatters.dateTime(receipt.createdAt)}',
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        trailing: Text(
          AppFormatters.currency(receipt.totalAmount),
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
        ),
      ),
    );
  }
}
