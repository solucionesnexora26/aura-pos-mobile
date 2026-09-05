import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../../core/database/tables/system_tables.dart';
import '../../../../core/error/failures.dart';
import '../../../pos/data/repositories/sale_repository_impl.dart';
import '../../presentation/providers/printer_providers.dart';
import '../../presentation/providers/receipt_config_provider.dart';
import 'receipt_debug_logger.dart';
import 'receipt_ticket_builder.dart';

/// Servicio de impresión: genera los bytes ESC/POS del recibo y los envía a
/// la impresora configurada (Bluetooth o red), sin mostrar selectores.
abstract class ReceiptPrinterService {
  // flush() confirma la entrega al socket, no el procesamiento físico de la
  // PT-210. Este retardo corto evita cerrar el socket en la misma ráfaga; no
  // sustituye la validación del payload ni es un workaround gráfico.
  static const _bluetoothDrainDelay = Duration(milliseconds: 250);

  /// Envía el recibo a la impresora indicada. Devuelve [Right(unit)] si la
  /// impresión se realizó correctamente, o un [PrinterFailure] con el motivo.
  static Future<Either<Failure, Unit>> printSale({
    required SaleEntity sale,
    required PrinterConfigEntity printer,
    ReceiptConfigEntity? receiptConfig,
    String? customerName,
  }) async {
    try {
      final bytes = await ReceiptTicketBuilder.buildBytes(
        sale: sale,
        printer: printer,
        receiptConfig: receiptConfig,
        customerName: customerName,
      );
      final copies = receiptConfig?.printCopies.clamp(1, 3) ?? 1;
      final multiBytes = List<int>.generate(
        bytes.length * copies,
        (i) => bytes[i % bytes.length],
      );
      await ReceiptDebugLogger.log(
          'sale',
          'sale=${sale.ticketNumber} printer=${printer.name} '
          'conn=${printer.connectionType.name} base=${bytes.length}B '
          'copies=$copies total=${multiBytes.length}B');
      return switch (printer.connectionType) {
        PrinterConnectionType.bluetooth =>
          _printBluetooth(printer.address, multiBytes),
        PrinterConnectionType.network =>
          _printNetwork(printer.address, printer.port ?? 9100, multiBytes),
        PrinterConnectionType.usb =>
          const Left(PrinterFailure('La impresión USB aún no está soportada. Usa Bluetooth o Red WiFi.')),
      };
    } catch (e) {
      return Left(PrinterFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Unit>> _printBluetooth(
    String mac,
    List<int> bytes,
  ) async {
    final tailStart = bytes.length > 16 ? bytes.length - 16 : 0;
    await ReceiptDebugLogger.log('sending',
        'bluetooth mac=$mac payload=${bytes.length}B '
        'first=[${ReceiptDebugLogger.hex(bytes, max: 16)}] '
        'last=[${ReceiptDebugLogger.hex(bytes, start: tailStart, max: 16)}]');
    final permission = await _ensureBluetoothPermission();
    if (!permission) {
      return const Left(PrinterFailure(
          'Permiso de Bluetooth denegado. Habilítalo en los ajustes del sistema.'));
    }
    final enabled = await PrintBluetoothThermal.bluetoothEnabled;
    if (!enabled) {
      return const Left(PrinterFailure(
          'Bluetooth apagado. Enciéndelo e intenta de nuevo.'));
    }
    final connected =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (!connected) {
      await ReceiptDebugLogger.log('sending', 'bluetooth connect=FALLO');
      return const Left(PrinterFailure(
          'No se pudo conectar a la impresora. Verifica que esté encendida y emparejada.'));
    }
    await ReceiptDebugLogger.log('sending', 'bluetooth connect=OK');

    // IMPORTANTE: El plugin Kotlin print_bluetooth_thermal agrega un byte \n
    // (0x0A) al INICIO de cada llamada a writebytes. Si enviamos múltiples
    // chunks, ese \n se inserta en medio de la secuencia ESC/POS, corrompiendo
    // todos los comandos posteriores. Por eso enviamos TODO el payload en UNA
    // sola llamada. El chunking nativo de Kotlin (16KB con flush) se encarga
    // de dividir los datos de forma segura hacia el output stream de Bluetooth.
    final sent = await PrintBluetoothThermal.writeBytes(bytes);
    await Future<void>.delayed(_bluetoothDrainDelay);
    await PrintBluetoothThermal.disconnect;
    await ReceiptDebugLogger.log('sending', 'bluetooth writeBytes sent=$sent');
    return sent
        ? const Right(unit)
        : const Left(PrinterFailure('Error al enviar el recibo a la impresora.'));
  }

  static Future<Either<Failure, Unit>> _printNetwork(
    String host,
    int port,
    List<int> bytes,
  ) async {
    await ReceiptDebugLogger.log('sending',
        'network $host:$port payload=${bytes.length}B');
    try {
      final socket = await Socket.connect(host, port,
          timeout: const Duration(seconds: 5));
      socket.add(bytes);
      await socket.flush();
      await socket.close();
      return const Right(unit);
    } catch (e) {
      return Left(PrinterFailure('No se pudo conectar a la impresora de red: $e'));
    }
  }

  /// Solicita el permiso de Bluetooth en runtime (necesario en Android 12+).
  static Future<bool> _ensureBluetoothPermission() async {
    if (!Platform.isAndroid) return true;
    await Permission.bluetoothScan.request();
    final status = await Permission.bluetoothConnect.request();
    if (status.isGranted) return true;
    final legacy = await Permission.bluetooth.request();
    return legacy.isGranted;
  }
}
