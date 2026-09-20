import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/sales_tables.dart';
import '../../../../core/database/tables/system_tables.dart';
import '../../../../core/utils/formatters.dart';
import '../../../pos/data/repositories/sale_repository_impl.dart';
import '../../presentation/providers/printer_providers.dart';
import '../../presentation/providers/receipt_config_provider.dart';
import 'receipt_debug_logger.dart';
import 'receipt_image_encoder.dart';

/// Construye el recibo en formato térmico ESC/POS y una versión en texto
/// plano (para compartir), respetando la configuración de la impresora
/// (ancho de papel, encabezado/pie de recibo y corte automático).
abstract class ReceiptTicketBuilder {
  ReceiptTicketBuilder._();

  /// Sanitiza un string para que solo contenga caracteres válidos en CP437.
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
    required SaleEntity sale,
    required PrinterConfigEntity printer,
    ReceiptConfigEntity? receiptConfig,
    String? customerName,
  }) async {
    final profile = await CapabilityProfile.load();
    final paperSize = printer.paperWidth == PrinterPaperWidth.mm58
        ? PaperSize.mm58
        : PaperSize.mm80;
    final gen = Generator(paperSize, profile);

    await ReceiptDebugLogger.log(
        'ticket',
        'BEGIN sale=${sale.ticketNumber} paper=${printer.paperWidth.name} '
        'items=${sale.items.length} total=${AppFormatters.currency(sale.total)}');

    var bytes = <int>[];
    bytes += gen.reset();

    final saleItems = sale.items.where((i) => !i.isReturn).toList();
    final returnItems = sale.items.where((i) => i.isReturn).toList();
    final hasReturns = returnItems.isNotEmpty;

    if (receiptConfig == null) {
      // ignore: avoid_print
      print('[ReceiptTicketBuilder] WARNING: receiptConfig is null, using defaults');
    }

    // ── Logo ─────────────────────────────────────────────────────────────────
    final configuredLogoUrl =
        receiptConfig?.logoPrintUrl ?? receiptConfig?.logoUrl;
    if (receiptConfig?.showLogo == true && configuredLogoUrl != null) {
      final logoBytes = await _downloadLogo(configuredLogoUrl);
      if (logoBytes != null) {
        final image = img.decodeImage(logoBytes);
        if (image != null) {
          // Logo centrado a resolución de dots con el encoder corregido
          // (ESC * por bandas con k == dataLen). El ancho máximo conserva las
          // proporciones originales del logo.
          final maxWidth = paperSize == PaperSize.mm80 ? 280 : 200;
          final resized = img.copyResize(image, width: maxWidth, maintainAspect: true);
          final logoEscPos = ReceiptImageEncoder.encode(
            resized,
            maxBandWidth: paperSize == PaperSize.mm80
                ? ReceiptImageEncoder.maxBandWidthMm80
                : ReceiptImageEncoder.maxBandWidthMm58,
          );
          await ReceiptDebugLogger.log(
              'ticket',
              'LOGO original=${logoBytes.length}B decoded=${image.width}x'
              '${image.height} resized=${resized.width}x${resized.height} '
              'rotated=none mode=33 '
              'escPos=${logoEscPos.length}B first=['
              '${ReceiptDebugLogger.hex(logoEscPos)}] '
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

    bytes += gen.text(
      _s('RECIBO DE VENTA'),
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    if (hasReturns) {
      bytes += gen.text(_s('CON DEVOLUCION'),
          styles: const PosStyles(align: PosAlign.center, bold: true));
    }

    final header = receiptConfig?.header?.trim().isNotEmpty ?? false
        ? receiptConfig!.header
        : printer.headerText;
    if (header != null && header.trim().isNotEmpty) {
      for (final line in header.split('\n')) {
        bytes += gen.text(_s(line.trim()),
            styles: const PosStyles(align: PosAlign.center));
      }
    }

    bytes += gen.hr();

    // ── Datos del ticket ─────────────────────────────────────────────────────
    bytes += gen.text(_s('Ticket: ${sale.ticketNumber}'));
    bytes += gen.text(_s(
        'Fecha: ${AppFormatters.dateTime(sale.paidAt ?? sale.createdAt)}'));
    if (sale.employeeName != null && sale.employeeName!.isNotEmpty) {
      bytes += gen.text(_s('Cajero: ${sale.employeeName}'));
    }
    if (sale.tpvName != null && sale.tpvName!.isNotEmpty) {
      bytes += gen.text(_s('TPV: ${sale.tpvName}'));
    }
    if (customerName != null && customerName.isNotEmpty) {
      bytes += gen.text(_s('Cliente: $customerName'));
    } else if (sale.customerId != null && sale.customerId!.isNotEmpty) {
      bytes += gen.text(_s('Cliente: ${sale.customerId}'));
    }
    if (sale.ticketLabel != null && sale.ticketLabel!.isNotEmpty) {
      bytes += gen.text(_s('Nota: ${sale.ticketLabel}'));
    }
    bytes += gen.hr();

    // ── Ítems ────────────────────────────────────────────────────────────────
    if (returnItems.isEmpty) {
      for (final item in sale.items) {
        bytes += _itemRow(gen, item);
      }
    } else {
      bytes += gen.text(_s('VENTA'),
          styles: const PosStyles(bold: true));
      for (final item in saleItems) {
        bytes += _itemRow(gen, item);
      }
      bytes += gen.text(_s('DEVOLUCION'),
          styles: const PosStyles(bold: true));
      for (final item in returnItems) {
        bytes += _itemRow(gen, item);
        final reason = item.returnReasonLabel;
        if (reason != null && reason.isNotEmpty) {
          bytes += gen.text(_s('  Motivo: $reason'),
              styles: const PosStyles(bold: false));
        }
      }
    }

    bytes += gen.hr();

    // ── Totales ──────────────────────────────────────────────────────────────
    bytes += _amountRow(gen, 'Subtotal', AppFormatters.currency(sale.subtotal));
    if (returnItems.isNotEmpty) {
      final returnsAbs =
          returnItems.fold<double>(0.0, (s, i) => s + i.lineTotal).abs();
      bytes += _amountRow(
          gen, 'Devoluciones', '-${AppFormatters.currency(returnsAbs)}');
    }
    if (sale.discountTotal > 0) {
      bytes += _amountRow(
          gen, 'Descuento', '-${AppFormatters.currency(sale.discountTotal)}');
    }
    if (sale.taxTotal > 0) {
      bytes += _amountRow(gen, 'Impuestos', AppFormatters.currency(sale.taxTotal));
    }
    final hasNegativeTotal = sale.total < 0;
    bytes += gen.row([
      PosColumn(
          text: hasNegativeTotal ? 'A FAVOR DEL CLIENTE' : 'TOTAL',
          width: 8,
          styles: const PosStyles(bold: true)),
      PosColumn(
        text: AppFormatters.currency(
            hasNegativeTotal ? sale.total.abs() : sale.total),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    if (sale.changeGiven > 0) {
      bytes += _amountRow(
          gen, 'Cambio', AppFormatters.currency(sale.changeGiven));
    }
    final paymentLabels = sale.payments
        .map((p) => p.method.label)
        .join(', ');
    if (paymentLabels.isNotEmpty) {
      bytes += _amountRow(gen, 'Metodo', paymentLabels);
    }

    bytes += gen.hr();

    // ── Pie del recibo ───────────────────────────────────────────────────────
    final footer = receiptConfig?.footer?.trim().isNotEmpty ?? false
        ? receiptConfig!.footer
        : printer.footerText;
    if (footer != null && footer.trim().isNotEmpty) {
      for (final line in footer.split('\n')) {
        bytes +=
            gen.text(_s(line.trim()), styles: const PosStyles(align: PosAlign.center));
      }
    }

    final thankYou = receiptConfig?.thankYou ?? 'Gracias por su compra!';
    bytes += gen.text(_s(thankYou),
        styles: const PosStyles(align: PosAlign.center));

    bytes += gen.emptyLines(3);
    if (printer.autoCut) {
      bytes += gen.cut();
    }
    await ReceiptDebugLogger.log(
        'ticket',
        'END total=${bytes.length}B '
        '${ReceiptDebugLogger.describeImageCommands(bytes)}');
    return bytes;
  }

  static List<int> _itemRow(Generator gen, SaleItemRow item) {
  final left = _s(
      '${AppFormatters.quantity(item.quantity.abs())} x ${item.productNameSnapshot}');
  final discountLabel = item.discount > 0 ? ' (-${item.discount.toInt()}%)' : '';
  return gen.row([
    PosColumn(text: left + discountLabel, width: 8),
    PosColumn(
      text: AppFormatters.currency(item.lineTotal),
      width: 4,
      styles: const PosStyles(align: PosAlign.right),
    ),
  ]);
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

  /// Descarga el logo desde una URL pública. Devuelve los bytes decodificados
  /// o null si falla (timeout, red, formato inválido).
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

  /// Versión en texto plano del recibo (útil para compartir).
  static String buildPlainText(SaleEntity sale, {ReceiptConfigEntity? receiptConfig, String? customerName}) {
    final businessName = receiptConfig?.businessName?.trim();
    final saleItems = sale.items.where((i) => !i.isReturn).toList();
    final returnItems = sale.items.where((i) => i.isReturn).toList();
    final hasReturns = returnItems.isNotEmpty;
    final b = StringBuffer()
      ..writeln(businessName != null && businessName.isNotEmpty ? businessName : 'AURA POS')
      ..writeln('RECIBO DE VENTA' + (hasReturns ? ' (CON DEVOLUCION)' : ''))
      ..writeln('------------------------')
      ..writeln('Ticket: ${sale.ticketNumber}')
      ..writeln('Fecha: ${AppFormatters.dateTime(sale.paidAt ?? sale.createdAt)}');
    if (sale.employeeName != null && sale.employeeName!.isNotEmpty) {
      b.writeln('Cajero: ${sale.employeeName}');
    }
    if (sale.tpvName != null && sale.tpvName!.isNotEmpty) {
      b.writeln('TPV: ${sale.tpvName}');
    }
    if (customerName != null && customerName.isNotEmpty) {
      b.writeln('Cliente: $customerName');
    } else if (sale.customerId != null && sale.customerId!.isNotEmpty) {
      b.writeln('Cliente: ${sale.customerId}');
    }
    b.writeln();
    if (hasReturns) {
      b.writeln('VENTA');
      for (final item in saleItems) {
        b.writeln('${AppFormatters.quantity(item.quantity)} x ${item.productNameSnapshot}');
        b.writeln('      ${AppFormatters.currency(item.lineTotal)}');
      }
      b.writeln('DEVOLUCION');
      for (final item in returnItems) {
        b.writeln('${AppFormatters.quantity(item.quantity.abs())} x ${item.productNameSnapshot}');
        b.writeln('      ${AppFormatters.currency(item.lineTotal)}');
        final reason = item.returnReasonLabel;
        if (reason != null && reason.isNotEmpty) {
          b.writeln('      Motivo: $reason');
        }
      }
    } else {
      for (final item in sale.items) {
        b.writeln('${AppFormatters.quantity(item.quantity)} x ${item.productNameSnapshot}');
        b.writeln('      ${AppFormatters.currency(item.lineTotal)}');
      }
    }
    b.writeln('------------------------');
    b.writeln('Subtotal: ${AppFormatters.currency(sale.subtotal)}');
    if (hasReturns) {
      final returnsAbs =
          returnItems.fold<double>(0.0, (s, i) => s + i.lineTotal).abs();
      b.writeln('Devoluciones: -${AppFormatters.currency(returnsAbs)}');
    }
    if (sale.discountTotal > 0) {
      b.writeln('Descuento: -${AppFormatters.currency(sale.discountTotal)}');
    }
    if (sale.taxTotal > 0) {
      b.writeln('Impuestos: ${AppFormatters.currency(sale.taxTotal)}');
    }
    if (sale.total < 0) {
      b.writeln('A FAVOR DEL CLIENTE: ${AppFormatters.currency(sale.total.abs())}');
    } else {
      b.writeln('TOTAL: ${AppFormatters.currency(sale.total)}');
    }
    if (sale.changeGiven > 0) {
      b.writeln('Cambio: ${AppFormatters.currency(sale.changeGiven)}');
    }
    final paymentLabels = sale.payments
        .map((p) => p.method.label)
        .join(', ');
    if (paymentLabels.isNotEmpty) {
      b.writeln('Metodo: $paymentLabels');
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
      ..writeln(receiptConfig?.thankYou ?? '¡Gracias por su compra!');
    return b.toString();
  }
}

/// Etiqueta legible de un motivo de devolución de una línea de recibo.
extension SaleItemReturnReasonLabel on SaleItemRow {
  String? get returnReasonLabel => switch (returnReason) {
        'deterioro' => 'Deterioro',
        'vencimiento' => 'Vencimiento',
        'no_aceptacion' => 'No aceptacion',
        'otro' => 'Otro',
        _ => returnReason,
      };
}
