import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../../core/database/tables/system_tables.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/services/receipt_debug_logger.dart';
import '../../domain/services/receipt_diagnostic_scenarios.dart';
import '../providers/printer_providers.dart';
import '../providers/receipt_config_provider.dart';

class PrinterSettingsPage extends ConsumerWidget {
  const PrinterSettingsPage({super.key});

  static const _bluetoothDrainDelay = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printersAsync = ref.watch(printersStreamProvider);
    final scheme = Theme.of(context).colorScheme;
    final printerList = printersAsync.valueOrNull ?? const <PrinterConfigEntity>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impresoras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: 'Diagnóstico de impresión',
            onPressed: () {
              if (printerList.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Configura una impresora primero.')));
                return;
              }
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _DiagnosticsSheet(printers: printerList),
              );
            },
          ),
        ],
      ),
      body: printersAsync.when(
        loading: () => const AppLoadingView(),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (printers) => Column(
          children: [
            Expanded(
              child: printers.isEmpty
                  ? AppEmptyView(
                      message: 'No hay impresoras configuradas.',
                      icon: Icons.print_outlined,
                      actionLabel: 'Agregar impresora',
                      onAction: () => _showPrinterForm(context, ref),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: printers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = printers[i];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: p.isFavorite
                                  ? scheme.primaryContainer
                                  : scheme.surfaceContainerHighest,
                              child: Icon(
                                _connIcon(p.connectionType),
                                color: p.isFavorite
                                    ? scheme.onPrimaryContainer
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                            title: Text(p.name),
                            subtitle: Text('${p.connectionLabel} · ${p.paperLabel} · ${p.address}'),
                            onTap: () => _showPrinterForm(context, ref, printer: p),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (p.isFavorite)
                                  Chip(label: const Text('Favorita'), padding: EdgeInsets.zero),
                                IconButton(
                                  icon: const Icon(Icons.print_outlined),
                                  tooltip: 'Prueba',
                                  onPressed: () => _testPrintSaved(context, ref, p),
                                ),
                                IconButton(
                                  icon: Icon(p.isFavorite ? Icons.star : Icons.star_outline),
                                  onPressed: () => ref.read(printerRepositoryProvider).setFavorite(p.id),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: scheme.error),
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(context);
                                    final repo = ref.read(printerRepositoryProvider);
                                    final ok = await showDialog<bool>(
                                      context: context,
                                      builder: (dialogCtx) => AlertDialog(
                                        title: const Text('Eliminar impresora'),
                                        content: Text('¿Eliminar "${p.name}"?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Cancelar')),
                                          FilledButton(onPressed: () => Navigator.pop(dialogCtx, true), child: const Text('Eliminar')),
                                        ],
                                      ),
                                    );
                                    if (ok == true) {
                                      final result = await repo.deletePrinter(p.id);
                                      if (!context.mounted) return;
                                      result.fold(
                                        (f) => messenger.showSnackBar(SnackBar(content: Text('Error: ${f.message}'))),
                                        (_) => messenger.showSnackBar(SnackBar(content: Text('"${p.name}" eliminada'))),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _showPrinterForm(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar impresora'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _connIcon(PrinterConnectionType type) => switch (type) {
        PrinterConnectionType.bluetooth => Icons.bluetooth,
        PrinterConnectionType.usb => Icons.usb,
        PrinterConnectionType.network => Icons.wifi,
      };

  void _showPrinterForm(BuildContext context, WidgetRef ref, {PrinterConfigEntity? printer}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _PrinterFormSheet(ref: ref, existing: printer),
    );
  }

  Future<void> _testPrintSaved(BuildContext context, WidgetRef ref, PrinterConfigEntity printer) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(content: Text('Imprimiendo prueba en "${printer.name}"…')));
    final bytes = await _buildTestReceipt(printer);
    final result = await _sendBytes(printer, bytes);
    if (!context.mounted) return;
    result.fold(
      (f) => messenger.showSnackBar(SnackBar(content: Text('Error: ${f.message}'))),
      (_) => messenger.showSnackBar(const SnackBar(content: Text('Prueba enviada a la impresora'))),
    );
  }

  static Future<List<int>> _buildTestReceipt(PrinterConfigEntity printer) async {
    final profile = await CapabilityProfile.load();
    final paperSize = printer.paperWidth == PrinterPaperWidth.mm58 ? PaperSize.mm58 : PaperSize.mm80;
    final gen = Generator(paperSize, profile);
    final bytes = <int>[];
    bytes.addAll(gen.reset());
    bytes.addAll(gen.text('AURA POS', styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2)));
    bytes.addAll(gen.text('PRUEBA DE IMPRESION', styles: const PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(gen.hr());
    bytes.addAll(gen.text('Fecha: ${DateTime.now().toString().substring(0, 19)}'));
    bytes.addAll(gen.text('Impresora: ${printer.name}'));
    bytes.addAll(gen.text('Conexion: ${printer.connectionLabel}'));
    bytes.addAll(gen.text('Papel: ${printer.paperLabel}'));
    bytes.addAll(gen.hr());
    bytes.addAll(gen.row([
      PosColumn(text: '1 x Producto ejemplo', width: 8),
      PosColumn(text: '\$10.00', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(gen.row([
      PosColumn(text: '2 x Segundo item', width: 8),
      PosColumn(text: '\$25.00', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(gen.hr());
    bytes.addAll(gen.text('TOTAL: \$35.00', styles: const PosStyles(align: PosAlign.center, bold: true)));
    bytes.addAll(gen.emptyLines(2));
    bytes.addAll(gen.text('Impresion de prueba exitosa', styles: const PosStyles(align: PosAlign.center)));
    bytes.addAll(gen.emptyLines(3));
    if (printer.autoCut) bytes.addAll(gen.cut());
    return bytes;
  }

  static Future<Either<Failure, Unit>> _sendBytes(PrinterConfigEntity printer, List<int> bytes) async {
    try {
      if (printer.connectionType == PrinterConnectionType.bluetooth) {
        final tailStart = bytes.length > 16 ? bytes.length - 16 : 0;
        await ReceiptDebugLogger.log('diag',
            'bt send payload=${bytes.length}B '
            'first=[${ReceiptDebugLogger.hex(bytes, max: 16)}] '
            'last=[${ReceiptDebugLogger.hex(bytes, start: tailStart, max: 16)}]');
        await Permission.bluetoothScan.request();
        await Permission.bluetoothConnect.request();
        final enabled = await PrintBluetoothThermal.bluetoothEnabled;
        if (!enabled) return const Left(PrinterFailure('Bluetooth apagado.'));
        final connected = await PrintBluetoothThermal.connect(macPrinterAddress: printer.address);
        if (!connected) return const Left(PrinterFailure('No se pudo conectar a la impresora.'));
        final sent = await PrintBluetoothThermal.writeBytes(bytes);
        await Future<void>.delayed(_bluetoothDrainDelay);
        await PrintBluetoothThermal.disconnect;
        await ReceiptDebugLogger.log('diag', 'bt writeBytes sent=$sent');
        return sent ? const Right(unit) : const Left(PrinterFailure('Error al enviar datos.'));
      } else if (printer.connectionType == PrinterConnectionType.network) {
        await ReceiptDebugLogger.log('diag',
            'net ${printer.address}:${printer.port ?? 9100} payload=${bytes.length}B');
        final socket = await Socket.connect(printer.address, printer.port ?? 9100, timeout: const Duration(seconds: 5));
        socket.add(bytes);
        await socket.flush();
        await socket.close();
        return const Right(unit);
      }
      return const Left(PrinterFailure('USB no soportado aún.'));
    } catch (e) {
      await ReceiptDebugLogger.log('diag', 'send ERROR: $e');
      return Left(PrinterFailure(e.toString()));
    }
  }

  /// Envía [first] y [second] como dos writeBytes sobre la MISMA conexión
  /// Bluetooth, con una pausa entre ambos (reproduce el "chunking" manual).
  static Future<Either<Failure, Unit>> _sendChunksSameConnection(
    PrinterConfigEntity printer,
    List<int> first,
    List<int> second, {
    Duration delay = const Duration(milliseconds: 200),
  }) async {
    try {
      await ReceiptDebugLogger.log(
          'diag', 'chunked parte1=${first.length}B parte2=${second.length}B delay=${delay.inMilliseconds}ms');
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) return const Left(PrinterFailure('Bluetooth apagado.'));
      final connected =
          await PrintBluetoothThermal.connect(macPrinterAddress: printer.address);
      if (!connected) return const Left(PrinterFailure('No se pudo conectar a la impresora.'));
      final r1 = await PrintBluetoothThermal.writeBytes(first);
      await Future<void>.delayed(delay);
      final r2 = await PrintBluetoothThermal.writeBytes(second);
      await Future<void>.delayed(_bluetoothDrainDelay);
      await PrintBluetoothThermal.disconnect;
      await ReceiptDebugLogger.log('diag', 'chunked r1=$r1 r2=$r2');
      if (r1 && r2) return const Right(unit);
      return Left(PrinterFailure('Error en envío por partes (r1=$r1 r2=$r2).'));
    } catch (e) {
      await ReceiptDebugLogger.log('diag', 'chunked ERROR: $e');
      return Left(PrinterFailure(e.toString()));
    }
  }
}

class _DiagnosticsSheet extends HookConsumerWidget {
  const _DiagnosticsSheet({required this.printers});
  final List<PrinterConfigEntity> printers;

  static Future<String> _readLogFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File(
          '${dir.path}${Platform.pathSeparator}${ReceiptDebugLogger.fileName}');
      if (!await f.exists()) {
        return '(aún no hay log. Imprime algo primero.)';
      }
      final txt = await f.readAsString();
      return txt.isEmpty ? '(log vacío)' : txt;
    } catch (e) {
      return 'Error leyendo log: $e';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final messenger = ScaffoldMessenger.of(context);
    final printer = printers.any((p) => p.isFavorite)
        ? printers.firstWhere((p) => p.isFavorite)
        : printers.first;
    final running = useState<String?>(null);
    final scenarios = ReceiptDiagnosticTests.all;

    Future<void> run(ReceiptDiagnosticScenario s) async {
      running.value = s.id;
      try {
        final cfg = await ref.read(receiptConfigFutureProvider.future);
        final bytes = await s.build(printer, cfg);
        await ReceiptDebugLogger.log('diag', '${s.id} built=${bytes.length}B');
        messenger.showSnackBar(SnackBar(
            content: Text('${s.id}: enviando ${bytes.length} bytes…')));
        final result = s.chunked
            ? await PrinterSettingsPage._sendChunksSameConnection(
                printer,
                bytes.sublist(0, bytes.length ~/ 2),
                bytes.sublist(bytes.length ~/ 2),
              )
            : await PrinterSettingsPage._sendBytes(printer, bytes);
        if (!context.mounted) return;
        result.fold(
          (f) => messenger.showSnackBar(
              SnackBar(content: Text('${s.id} Error: ${f.message}'))),
          (_) => messenger
              .showSnackBar(SnackBar(content: Text('${s.id} enviado'))),
        );
      } catch (e) {
        if (context.mounted) {
          messenger.showSnackBar(
              SnackBar(content: Text('${s.id} ERROR: $e')));
        }
      } finally {
        running.value = null;
      }
    }

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, color: scheme.primary),
                const SizedBox(width: 8),
                Text('Diagnóstico de impresión',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Impresora: ${printer.name} · ${printer.connectionLabel} · ${printer.paperLabel}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Pruebas aisladas hacia la PT210. El log se guarda en '
              'Documentos/${ReceiptDebugLogger.fileName}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: scenarios.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final s = scenarios[i];
                  final isRunning = running.value == s.id;
                  return Card(
                    child: ListTile(
                      leading: Icon(
                          s.chunked ? Icons.call_split : Icons.print,
                          color: s.chunked ? scheme.tertiary : scheme.primary),
                      title: Text(s.label),
                      subtitle: Text(s.description,
                          style: Theme.of(context).textTheme.bodySmall),
                      trailing: isRunning
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : IconButton(
                              icon: const Icon(Icons.play_arrow),
                              tooltip: 'Imprimir ${s.id}',
                              onPressed: () => run(s),
                            ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: running.value == null
                        ? () async {
                            final txt = await _readLogFile();
                            if (!context.mounted) return;
                            await showDialog<void>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Log de diagnóstico'),
                                content: SingleChildScrollView(
                                  child: Text(
                                    txt,
                                    style: const TextStyle(
                                        fontFamily: 'monospace', fontSize: 12),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.article_outlined),
                    label: const Text('Ver log'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ReceiptDebugLogger.clear();
                      messenger.showSnackBar(
                          const SnackBar(content: Text('Log limpiado')));
                    },
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: const Text('Limpiar log'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrinterFormSheet extends HookConsumerWidget {
  const _PrinterFormSheet({required this.ref, this.existing});
  final WidgetRef ref;
  final PrinterConfigEntity? existing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = existing != null;
    final nameCtrl = useTextEditingController(text: existing?.name ?? '');
    final addressCtrl = useTextEditingController(text: existing?.address ?? '');
    final portCtrl = useTextEditingController(text: existing?.port?.toString() ?? '9100');
    final connType = useState(existing?.connectionType ?? PrinterConnectionType.bluetooth);
    final paperWidth = useState(existing?.paperWidth ?? PrinterPaperWidth.mm80);
    final autoCut = useState(existing?.autoCut ?? true);
    final isSaving = useState(false);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEdit ? 'Editar Impresora' : 'Nueva Impresora', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre *')),
            const SizedBox(height: 12),
            DropdownButtonFormField<PrinterConnectionType>(
              value: connType.value,
              decoration: const InputDecoration(labelText: 'Tipo de conexión'),
              items: PrinterConnectionType.values.map((t) {
                final label = switch (t) {
                  PrinterConnectionType.bluetooth => 'Bluetooth',
                  PrinterConnectionType.usb => 'USB',
                  PrinterConnectionType.network => 'Red WiFi',
                };
                return DropdownMenuItem(value: t, child: Text(label));
              }).toList(),
              onChanged: (v) => connType.value = v ?? PrinterConnectionType.bluetooth,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              decoration: InputDecoration(
                labelText: connType.value == PrinterConnectionType.bluetooth
                    ? 'Dirección MAC (ej: AA:BB:CC:DD:EE:FF)'
                    : connType.value == PrinterConnectionType.network
                        ? 'Dirección IP (ej: 192.168.1.100)'
                        : 'ID del dispositivo USB',
                suffixIcon: connType.value == PrinterConnectionType.bluetooth
                    ? IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: 'Buscar dispositivos vinculados',
                        onPressed: () => _pickBluetoothDevice(context, nameCtrl, addressCtrl),
                      )
                    : null,
              ),
            ),
            if (connType.value == PrinterConnectionType.network) ...[
              const SizedBox(height: 12),
              TextField(controller: portCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Puerto (ej: 9100)')),
            ],
            const SizedBox(height: 12),
            DropdownButtonFormField<PrinterPaperWidth>(
              value: paperWidth.value,
              decoration: const InputDecoration(labelText: 'Ancho de papel'),
              items: const [
                DropdownMenuItem(value: PrinterPaperWidth.mm58, child: Text('58 mm')),
                DropdownMenuItem(value: PrinterPaperWidth.mm80, child: Text('80 mm')),
              ],
              onChanged: (v) => paperWidth.value = v ?? PrinterPaperWidth.mm80,
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: autoCut.value,
              onChanged: (v) => autoCut.value = v,
              title: const Text('Corte automático'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: addressCtrl.text.trim().isEmpty
                    ? null
                    : () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final p = PrinterConfigEntity(
                          id: '',
                          name: nameCtrl.text.trim().isEmpty ? 'Prueba' : nameCtrl.text.trim(),
                          connectionType: connType.value,
                          address: addressCtrl.text.trim(),
                          port: connType.value == PrinterConnectionType.network ? int.tryParse(portCtrl.text) : null,
                          paperWidth: paperWidth.value,
                          autoCut: autoCut.value,
                          headerText: null,
                          footerText: null,
                          isFavorite: false,
                        );
                        messenger.showSnackBar(const SnackBar(content: Text('Imprimiendo prueba…')));
                        final bytes = await PrinterSettingsPage._buildTestReceipt(p);
                        final result = await PrinterSettingsPage._sendBytes(p, bytes);
                        if (!context.mounted) return;
                        result.fold(
                          (f) => messenger.showSnackBar(SnackBar(content: Text('Error: ${f.message}'))),
                          (_) => messenger.showSnackBar(const SnackBar(content: Text('Prueba enviada'))),
                        );
                      },
                icon: const Icon(Icons.print),
                label: const Text('Impresión de prueba'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isSaving.value || nameCtrl.text.trim().isEmpty || addressCtrl.text.trim().isEmpty
                    ? null
                    : () async {
                        isSaving.value = true;
                        await ref.read(printerRepositoryProvider).savePrinter(
                          PrinterConfigEntity(
                            id: existing?.id ?? '',
                            name: nameCtrl.text.trim(),
                            connectionType: connType.value,
                            address: addressCtrl.text.trim(),
                            port: connType.value == PrinterConnectionType.network
                                ? int.tryParse(portCtrl.text)
                                : null,
                            paperWidth: paperWidth.value,
                            autoCut: autoCut.value,
                            headerText: existing?.headerText,
                            footerText: existing?.footerText,
                            isFavorite: existing?.isFavorite ?? false,
                          ),
                        );
                        isSaving.value = false;
                        if (context.mounted) Navigator.of(context).pop();
                      },
                child: Text(isEdit ? 'Actualizar impresora' : 'Guardar impresora'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBluetoothDevice(
    BuildContext context,
    TextEditingController nameCtrl,
    TextEditingController addressCtrl,
  ) async {
    if (!await Permission.bluetoothConnect.isGranted) {
      final status = await Permission.bluetoothConnect.request();
      if (!status.isGranted) {
        final legacy = await Permission.bluetooth.request();
        if (!legacy.isGranted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permiso de Bluetooth requerido para buscar impresoras.')),
            );
          }
          return;
        }
      }
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _BtDevicePickerDialog(nameCtrl: nameCtrl, addressCtrl: addressCtrl),
    );
  }
}

class _BtDevicePickerDialog extends StatefulWidget {
  const _BtDevicePickerDialog({required this.nameCtrl, required this.addressCtrl});
  final TextEditingController nameCtrl;
  final TextEditingController addressCtrl;

  @override
  State<_BtDevicePickerDialog> createState() => _BtDevicePickerDialogState();
}

class _BtDevicePickerDialogState extends State<_BtDevicePickerDialog> {
  bool _loading = true;
  bool _btOff = false;
  List<BluetoothInfo> _devices = const [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    bool btEnabled = true;
    try {
      btEnabled = await PrintBluetoothThermal.bluetoothEnabled.timeout(
        const Duration(seconds: 5),
        onTimeout: () => true,
      );
    } catch (_) {}
    if (!mounted) return;
    if (!btEnabled) {
      setState(() { _loading = false; _btOff = true; });
      return;
    }

    List<BluetoothInfo> devices = const [];
    try {
      devices = await PrintBluetoothThermal.pairedBluetooths.timeout(
        const Duration(seconds: 10),
        onTimeout: () => <BluetoothInfo>[],
      );
    } catch (_) {}
    if (mounted) setState(() { _loading = false; _devices = devices; });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar impresora'),
      content: SizedBox(
        width: double.maxFinite,
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Buscando impresoras Bluetooth…'),
                  ],
                ),
              )
            : _btOff
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bluetooth_disabled, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Bluetooth apagado.\nEnciéndelo en los ajustes del celular.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : _devices.isEmpty
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bluetooth_disabled, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'No se encontraron impresoras.\n\n'
                            'Verifica que:\n'
                            '• El Bluetooth esté encendido\n'
                            '• La impresora esté emparejada en los Ajustes del celular',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _devices.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final bt = _devices[i];
                          return ListTile(
                            leading: const Icon(Icons.bluetooth),
                            title: Text(bt.name),
                            subtitle: Text(bt.macAdress),
                            onTap: () {
                              widget.nameCtrl.text = bt.name;
                              widget.addressCtrl.text = bt.macAdress;
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
