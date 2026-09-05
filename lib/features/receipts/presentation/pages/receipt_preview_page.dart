import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/database/tables/sales_tables.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../pos/data/repositories/sale_repository_impl.dart';
import '../../../pos/presentation/providers/pos_providers.dart';
import '../../../printers/domain/services/receipt_printer_service.dart';
import '../../../printers/domain/services/receipt_ticket_builder.dart';
import '../../../printers/presentation/providers/printer_providers.dart';
import '../../../printers/presentation/providers/receipt_config_provider.dart';

class ReceiptPreviewPage extends ConsumerWidget {
  const ReceiptPreviewPage({this.saleId, super.key});
  final String? saleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = saleId;
    if (id == null) {
      return const Scaffold(body: AppErrorView(message: 'ID de venta no especificado.'));
    }

    final receiptConfig = ref.watch(receiptConfigStreamProvider).valueOrNull;

    // Cache en memoria: si acabamos de cobrar, la venta ya está disponible y
    // el recibo se muestra al instante, sin volver a consultar la BD.
    final cached = ref.watch(lastCompletedSaleProvider);
    if (cached != null && cached.id == id) {
      final customerName = _resolveCustomerName(ref, cached.customerId);
      return _buildScaffold(
        context,
        ref,
        sale: cached,
        body: _ReceiptBody(
          sale: cached,
          receiptConfig: receiptConfig,
          customerName: customerName,
        ),
      );
    }

    final asyncSale = ref.watch(saleByIdProvider(id));
    return _buildScaffold(
      context,
      ref,
      sale: asyncSale.value?.fold((_) => null, (s) => s),
      body: asyncSale.when(
        loading: () => const AppLoadingView(message: 'Cargando recibo…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (result) => result.fold(
          (f) => AppErrorView(message: f.message),
          (sale) {
            final customerName = _resolveCustomerName(ref, sale.customerId);
            return _ReceiptBody(
              sale: sale,
              receiptConfig: receiptConfig,
              customerName: customerName,
            );
          },
        ),
      ),
    );
  }

  String? _resolveCustomerName(WidgetRef ref, String? customerId) {
    if (customerId == null || customerId.isEmpty) return null;
    final asyncCustomer = ref.watch(customerByIdProvider(customerId));
    return asyncCustomer.valueOrNull?.fullName;
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref,
      {required SaleEntity? sale, required Widget body}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recibo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Compartir',
            onPressed:
                sale == null ? null : () => _share(context, ref, sale),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Imprimir',
            onPressed:
                sale == null ? null : () => _print(context, ref, sale),
          ),
        ],
      ),
      body: body,
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref, SaleEntity sale) async {
    try {
      final receiptConfig = await ref.read(receiptConfigRepositoryProvider).getConfig();
      await Share.share(
        ReceiptTicketBuilder.buildPlainText(sale, receiptConfig: receiptConfig),
        subject: 'Recibo ${sale.ticketNumber} - Aura POS',
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No se pudo compartir: $e')));
    }
  }

  Future<void> _print(BuildContext context, WidgetRef ref, SaleEntity sale) async {
    final messenger = ScaffoldMessenger.of(context);
    final printersResult =
        await ref.read(printerRepositoryProvider).getPrinters();
    final printers = printersResult.getOrElse((_) => const <PrinterConfigEntity>[]);

    if (printers.isEmpty) {
      if (!context.mounted) return;
      await _showNoPrinterDialog(context, ref);
      return;
    }

    // Imprime automáticamente a la impresora favorita (o la primera).
    final printer = printers.firstWhere(
      (p) => p.isFavorite,
      orElse: () => printers.first,
    );

    final receiptConfig =
        await ref.read(receiptConfigRepositoryProvider).getConfig();

    String? customerName;
    if (sale.customerId != null && sale.customerId!.isNotEmpty) {
      final asyncCustomer = ref.read(customerByIdProvider(sale.customerId));
      customerName = asyncCustomer.valueOrNull?.fullName;
    }

    messenger.showSnackBar(SnackBar(content: Text('Imprimiendo a "${printer.name}"…')));
    final result = await ReceiptPrinterService.printSale(
      sale: sale,
      printer: printer,
      receiptConfig: receiptConfig,
      customerName: customerName,
    );
    if (!context.mounted) return;
    result.fold(
      (f) => messenger
          .showSnackBar(SnackBar(content: Text('No se pudo imprimir: ${f.message}'))),
      (_) => messenger.showSnackBar(
          const SnackBar(content: Text('Recibo enviado a la impresora'))),
    );
  }

  Future<void> _showNoPrinterDialog(BuildContext context, WidgetRef ref) async {
    // Escanea impresoras Bluetooth disponibles en el momento.
    List<BluetoothInfo> available = const [];
    try {
      available = await PrintBluetoothThermal.pairedBluetooths;
    } catch (_) {}

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sin impresora configurada'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'No hay impresoras configuradas. Configura una impresora para poder imprimir recibos.',
              ),
              const SizedBox(height: 16),
              const Text('Impresoras Bluetooth disponibles:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (available.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('(No se encontraron impresoras Bluetooth)'),
                )
              else
                ...available.map((bt) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.bluetooth),
                      title: Text(bt.name),
                      subtitle: Text(bt.macAdress),
                    )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.goNamed(RouteNames.printerSettings);
            },
            child: const Text('Configurar impresora'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _ReceiptBody extends StatelessWidget {
  const _ReceiptBody({
    required this.sale,
    this.receiptConfig,
    this.customerName,
  });
  final SaleEntity sale;
  final ReceiptConfigEntity? receiptConfig;
  final String? customerName;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final businessName = receiptConfig?.businessName?.trim();
    final displayName = businessName != null && businessName.isNotEmpty
        ? businessName
        : 'Aura POS';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabecera
                  Center(
                    child: Column(children: [
                      if (receiptConfig?.showLogo == true &&
                          receiptConfig?.logoUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Image.network(
                            receiptConfig!.logoUrl!,
                            height: 60,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.point_of_sale_rounded,
                                size: 40),
                          ),
                        )
                      else
                        const Icon(Icons.point_of_sale_rounded, size: 40),
                      const SizedBox(height: 8),
                      Text(displayName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      if (receiptConfig?.showTaxId == true &&
                          receiptConfig?.taxId != null &&
                          receiptConfig!.taxId!.isNotEmpty)
                        Text('NIT/RFC: ${receiptConfig!.taxId}',
                            style: text.bodySmall),
                      if (receiptConfig?.showAddress == true &&
                          receiptConfig?.address != null &&
                          receiptConfig!.address!.isNotEmpty)
                        Text(receiptConfig!.address ?? '',
                            style: text.bodySmall),
                      if (receiptConfig?.showPhone == true &&
                          receiptConfig?.phone != null &&
                          receiptConfig!.phone!.isNotEmpty)
                        Text('Tel: ${receiptConfig!.phone}',
                            style: text.bodySmall),
                      const Text('Recibo de Venta',
                          style: TextStyle(fontSize: 12)),
                    ]),
                  ),
                  const Divider(height: 32),

                  // Datos del ticket
                  _KV('Ticket N°', sale.ticketNumber, text),
                  _KV('Fecha', AppFormatters.dateTime(sale.paidAt ?? sale.createdAt), text),
                  if (sale.employeeName != null && sale.employeeName!.isNotEmpty)
                    _KV('Cajero', sale.employeeName!, text),
                  if (sale.tpvName != null && sale.tpvName!.isNotEmpty)
                    _KV('TPV', sale.tpvName!, text),
                  if (customerName != null && customerName!.isNotEmpty)
                    _KV('Cliente', customerName!, text),
                  if (sale.payments.isNotEmpty)
                    _KV(
                      'Metodo de pago',
                      sale.payments.map((p) => p.method.label).join(', '),
                      text,
                    ),
                  const Divider(height: 24),

                  // Ítems
                  ...sale.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productNameSnapshot, style: text.bodyMedium),
                            Text(
                              '${AppFormatters.quantity(item.quantity)} × ${AppFormatters.currency(item.unitPrice)}',
                              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        )),
                        Text(AppFormatters.currency(item.lineTotal), style: text.bodyMedium),
                      ],
                    ),
                  )),

                  const Divider(height: 24),

                  // Totales
                  _KV('Subtotal', AppFormatters.currency(sale.subtotal), text),
                  if (sale.discountTotal > 0)
                    _KV('Descuento', '−${AppFormatters.currency(sale.discountTotal)}', text,
                        color: scheme.error),
                  if (sale.taxTotal > 0)
                    _KV('Impuestos', AppFormatters.currency(sale.taxTotal), text),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: Text('TOTAL', style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                    Text(AppFormatters.currency(sale.total),
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                  ]),

                  if (sale.changeGiven > 0) ...[
                    const SizedBox(height: 4),
                    _KV('Cambio', AppFormatters.currency(sale.changeGiven), text, color: Colors.green),
                  ],

                  const Divider(height: 24),

                  // Pie de página (footer de receipt_config)
                  if (receiptConfig?.footer != null &&
                      receiptConfig!.footer!.trim().isNotEmpty)
                    Center(
                      child: Column(
                        children: [
                          for (final line
                              in receiptConfig!.footer!.split('\n'))
                            Text(line.trim(),
                                style: text.bodySmall),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                  Center(child: Text(
                    receiptConfig?.thankYou ?? '¡Gracias por su compra!',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _KV(String label, String value, TextTheme text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(child: Text(label, style: text.bodySmall)),
        Text(value, style: text.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
