import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';

import '../../../../core/database/tables/system_tables.dart';
import '../../../../core/utils/formatters.dart';
import '../../../credit/domain/entities/credit_entities.dart';
import '../../presentation/providers/printer_providers.dart';
import '../../presentation/providers/receipt_config_provider.dart';
import 'receipt_debug_logger.dart';
import 'receipt_image_encoder.dart';

/// Construye el comprobante de abono en formato térmico ESC/POS y una versión
/// en texto plano (para compartir).
abstract class AbonoReceiptBuilder {
  AbonoReceiptBuilder._();

  static String _s(String text) => text
      .replaceAll(RegExp(r'[°ºª]'), '')
      .replaceAll(RegExp(r'[áà]'), 'a')
      .replaceAll(RegExp(r'[éè]'), 'e')
      .replaceAll(RegExp(r'[íì]'), 'i')
      .replaceAll(RegExp(r'[óò]'), 'o')
      .replaceAll(RegExp(r'[úù]'), 'u')
      .replaceAll(RegExp(r'ñ'), 'n')
      .replaceAll(RegExp(r'ü'), 'u')
      .replaceAll(RegExp(r'¡'), '!')
      .replaceAll(RegExp(r'¿'), '?')
      .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '')
      .replaceAll(RegExp(r'[\u00A0\u2007\u202F]'), ' ');

  /// Bytes ESC/POS listos para enviar a una impresora térmica.
  static Future<List<int>> buildBytes({
    required PaymentReceipt receipt,
    required PrinterConfigEntity printer,
    ReceiptConfigEntity? receiptConfig,
    List<String> ticketNumbers = const [],
  }) async {
    final profile = await CapabilityProfile.load();
    final paperSize = printer.paperWidth == PrinterPaperWidth.mm58
        ? PaperSize.mm58
        : PaperSize.mm80;
    final gen = Generator(paperSize, profile);

    await ReceiptDebugLogger.log(
        'abono',
        'BEGIN comprobante=${receipt.receiptNumber} paper=${printer.paperWidth.name} '
        'total=${AppFormatters.currency(receipt.totalAmount)}');

    var bytes = <int>[];
    bytes += gen.reset();

    // ── Logo ─────────────────────────────────────────────────────────────────
    final configuredLogoUrl =
        receiptConfig?.logoPrintUrl ?? receiptConfig?.logoUrl;
    if (receiptConfig?.showLogo == true && configuredLogoUrl != null) {
      final logoBytes = await _downloadLogo(configuredLogoUrl);
      if (logoBytes != null) {
        final image = img.decodeImage(logoBytes);
        if (image != null) {
          final maxWidth = paperSize == PaperSize.mm80 ? 280 : 200;
          final resized = img.copyResize(image, width: maxWidth, maintainAspect: true);
          final logoEscPos = ReceiptImageEncoder.encode(
            resized,
            maxBandWidth: paperSize == PaperSize.mm80
                ? ReceiptImageEncoder.maxBandWidthMm80
                : ReceiptImageEncoder.maxBandWidthMm58,
          );
          await ReceiptDebugLogger.log(
              'abono',
              'LOGO decoded=${image.width}x${image.height} '
              'resized=${resized.width}x${resized.height} rotated=none mode=33 '
              'escPos=${logoEscPos.length}B '
              '${ReceiptDebugLogger.describeImageCommands(logoEscPos)}');
          bytes += gen.setStyles(const PosStyles(align: PosAlign.center));
          bytes += logoEscPos;
          bytes += gen.setStyles(const PosStyles(align: PosAlign.left));
          bytes += gen.emptyLines(1);
        }
      }
    }

    // ── Cabecera del comercio ────────────────────────────────────────────────
    final businessName = receiptConfig?.businessName?.trim();
    bytes += gen.text(
      _s(businessName != null && businessName.isNotEmpty ? businessName : 'AURA POS'),
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    if (receiptConfig?.showTaxId ?? true) {
      final taxId = receiptConfig?.taxId?.trim();
      if (taxId != null && taxId.isNotEmpty) {
        bytes += gen.text(_s('NIT/RFC: $taxId'),
            styles: const PosStyles(align: PosAlign.center));
      }
    }

    if (receiptConfig?.showAddress ?? true) {
      final address = receiptConfig?.address?.trim();
      if (address != null && address.isNotEmpty) {
        bytes += gen.text(_s(address),
            styles: const PosStyles(align: PosAlign.center));
      }
    }

    if (receiptConfig?.showPhone ?? true) {
      final phone = receiptConfig?.phone?.trim();
      if (phone != null && phone.isNotEmpty) {
        bytes += gen.text(_s('Tel: $phone'),
            styles: const PosStyles(align: PosAlign.center));
      }
    }

    bytes += gen.text(_s('COMPROBANTE DE ABONO'),
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += gen.hr();

    // ── Datos del comprobante ────────────────────────────────────────────────
    bytes += gen.text(_s('Comprobante: ${receipt.receiptNumber}'));
    bytes += gen.text(_s('Fecha: ${AppFormatters.dateTime(receipt.createdAt)}'));
    if (receipt.customerName != null && receipt.customerName!.isNotEmpty) {
      bytes += gen.text(_s('Cliente: ${receipt.customerName}'));
    }
    bytes += gen.hr();

    // ── Tickets aplicados ────────────────────────────────────────────────────
    if (ticketNumbers.isNotEmpty) {
      bytes += gen.text(_s('Abono aplicado a:'),
          styles: const PosStyles(bold: true));
      for (final tn in ticketNumbers) {
        bytes += gen.text(_s('  - $tn'));
      }
      bytes += gen.hr();
    }

    // ── Total abono ──────────────────────────────────────────────────────────
    bytes += gen.row([
      PosColumn(
        text: 'TOTAL ABONO',
        width: 8,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: AppFormatters.currency(receipt.totalAmount),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += _amountRow(gen, 'Metodo', receipt.methodLabel);
    if (receipt.reference != null && receipt.reference!.isNotEmpty) {
      bytes += _amountRow(gen, 'Referencia', receipt.reference!);
    }

    bytes += gen.hr();

    // ── Pie del recibo ───────────────────────────────────────────────────────
    final footer = receiptConfig?.footer?.trim().isNotEmpty ?? false
        ? receiptConfig!.footer
        : printer.footerText;
    if (footer != null && footer.trim().isNotEmpty) {
      for (final line in footer.split('\n')) {
        bytes += gen.text(_s(line.trim()),
            styles: const PosStyles(align: PosAlign.center));
      }
    }

    final thankYou = receiptConfig?.thankYou ?? 'Gracias por su abono!';
    bytes += gen.text(_s(thankYou),
        styles: const PosStyles(align: PosAlign.center));

    bytes += gen.emptyLines(3);
    if (printer.autoCut) {
      bytes += gen.cut();
    }
    await ReceiptDebugLogger.log(
        'abono',
        'END total=${bytes.length}B '
        '${ReceiptDebugLogger.describeImageCommands(bytes)}');
    return bytes;
  }

  static List<int> _amountRow(Generator gen, String label, String value) {
    return gen.row([
      PosColumn(text: label, width: 8),
      PosColumn(
        text: value,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }

  static Future<Uint8List?> _downloadLogo(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      if (response.data != null && response.statusCode == 200) {
        return Uint8List.fromList(response.data!);
      }
    } catch (_) {}
    return null;
  }

  /// Versión en texto plano del comprobante (útil para compartir).
  static String buildPlainText(
    PaymentReceipt receipt, {
    ReceiptConfigEntity? receiptConfig,
    List<String> ticketNumbers = const [],
  }) {
    final businessName = receiptConfig?.businessName?.trim();
    final b = StringBuffer()
      ..writeln(businessName != null && businessName.isNotEmpty
          ? businessName
          : 'AURA POS')
      ..writeln('COMPROBANTE DE ABONO')
      ..writeln('------------------------')
      ..writeln('Comprobante: ${receipt.receiptNumber}')
      ..writeln('Fecha: ${AppFormatters.dateTime(receipt.createdAt)}');
    if (receipt.customerName != null && receipt.customerName!.isNotEmpty) {
      b.writeln('Cliente: ${receipt.customerName}');
    }
    b.writeln();
    if (ticketNumbers.isNotEmpty) {
      b.writeln('Abono aplicado a:');
      for (final tn in ticketNumbers) {
        b.writeln('  - $tn');
      }
    }
    b.writeln('------------------------');
    b.writeln('TOTAL ABONO: ${AppFormatters.currency(receipt.totalAmount)}');
    b.writeln('Metodo: ${receipt.methodLabel}');
    if (receipt.reference != null && receipt.reference!.isNotEmpty) {
      b.writeln('Referencia: ${receipt.reference}');
    }
    b.writeln('------------------------');
    final footer = receiptConfig?.footer?.trim().isNotEmpty ?? false
        ? receiptConfig!.footer
        : null;
    if (footer != null && footer.trim().isNotEmpty) {
      for (final line in footer.split('\n')) {
        b.writeln(line.trim());
      }
    }
    b
      ..writeln()
      ..writeln(receiptConfig?.thankYou ?? 'Gracias por su abono!');
    return b.toString();
  }
}
