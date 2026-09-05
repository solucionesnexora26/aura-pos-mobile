import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;

import '../../../../core/database/tables/system_tables.dart';
import '../../presentation/providers/printer_providers.dart';
import '../../presentation/providers/receipt_config_provider.dart';
import 'receipt_debug_logger.dart';
import 'receipt_image_encoder.dart';

/// Escenario aislado de impresión para validar la PT210 (FASE 3).
class ReceiptDiagnosticScenario {
  const ReceiptDiagnosticScenario({
    required this.id,
    required this.label,
    required this.description,
    required this.build,
    this.chunked = false,
  });

  final String id;
  final String label;
  final String description;

  /// Construye el payload ESC/POS completo para el escenario.
  final Future<List<int>> Function(
      PrinterConfigEntity printer, ReceiptConfigEntity? cfg) build;

  /// true = el runner debe enviarlo en 2 writeBytes sobre la misma conexión.
  final bool chunked;
}

/// Catálogo de pruebas aisladas.
abstract class ReceiptDiagnosticTests {
  // ─── API ────────────────────────────────────────────────────────────────────
  static List<ReceiptDiagnosticScenario> get all => [
        ReceiptDiagnosticScenario(
          id: 'TEXT_3KB',
          label: 'Texto 3KB (sin imagen)',
          description:
              '~96 líneas de texto (~3.2KB). Valida el transporte BT con un payload grande, sin imagen.',
          build: _text3k,
        ),
        ReceiptDiagnosticScenario(
          id: 'LOGO_280',
          label: 'Logo 280px (tamaño original)',
          description:
              'RESET + logo a 280px con gen.image (ESC *). Reproduce el bug reportado original.',
          build: (p, c) => _logoWithWidth(p, c, 280, addText: true),
        ),
        ReceiptDiagnosticScenario(
          id: 'LOGO_160',
          label: 'Logo 160px (tamaño actual)',
          description:
              'RESET + logo a 160px con gen.image. Estado actual: imprime mitad del logo y más pequeño.',
          build: (p, c) => _logoWithWidth(p, c, 160, addText: true),
        ),
        ReceiptDiagnosticScenario(
          id: 'LOGO_64',
          label: 'Logo 64px',
          description:
              'Logo pequeño (64px) con gen.image. ¿Imprime completo o también falla?',
          build: (p, c) => _logoWithWidth(p, c, 64, addText: true),
        ),
        ReceiptDiagnosticScenario(
          id: 'LOGO_160_CHUNKED',
          label: 'Logo 160px en 2 envíos (chunked)',
          description:
              'Mismo payload que LOGO_160 pero dividido en dos writeBytes con pausa, misma conexión.',
          build: (p, c) => _logoWithWidth(p, c, 160, addText: true),
          chunked: true,
        ),
        ReceiptDiagnosticScenario(
          id: 'PATTERN_IMAGE',
          label: 'Patrón 64x32 vía gen.image',
          description:
              'Imagen artificial 64x32 (4 franjas horizontales + borde) usando gen.image (ESC *). Revela si el trazado de la librería es correcto.',
          build: _patternImage,
        ),
        ReceiptDiagnosticScenario(
          id: 'PATTERN_ESCSTAR_MANUAL',
          label: 'Patrón 64x32 ESC * manual por bandas',
          description:
              'Construcción ESC * válida en m=33 (24 filas por bloque, n*3 bytes). Incluye texto posterior.',
          build: _patternEscStarManual,
        ),
        ReceiptDiagnosticScenario(
          id: 'IMAGE_64x32',
          label: 'Imagen manual 64x32 + texto',
          description: 'Control mínimo ESC * válido: 64x32 y texto después.',
          build: (p, _) => _manualImageTest(p, 64, 32),
        ),
        ReceiptDiagnosticScenario(
          id: 'IMAGE_128x64',
          label: 'Imagen manual 128x64 + texto',
          description: 'Control ESC * válido: 128x64 y texto después.',
          build: (p, _) => _manualImageTest(p, 128, 64),
        ),
        ReceiptDiagnosticScenario(
          id: 'IMAGE_160x80',
          label: 'Imagen manual 160x80 + texto',
          description: 'Control ESC * válido: 160x80 y texto después.',
          build: (p, _) => _manualImageTest(p, 160, 80),
        ),
        ReceiptDiagnosticScenario(
          id: 'IMAGE_256x128',
          label: 'Imagen manual 256x128 + texto',
          description: 'Control ESC * válido: 256x128 y texto después.',
          build: (p, _) => _manualImageTest(p, 256, 128),
        ),
        ReceiptDiagnosticScenario(
          id: 'IMAGE_SEQUENCE',
          label: 'Texto + 3 imágenes + texto',
          description:
              'AAAA antes, imagen, BBBB después, segunda imagen, CCCC después, tercera imagen y DDDD final.',
          build: _imageSequence,
        ),
        ReceiptDiagnosticScenario(
          id: 'PATTERN_GSV0_MANUAL',
          label: 'Patrón 64x32 GS v 0 manual',
          description:
              'Raster GS v 0 (1D 76 30 00) con header correcto (xL=8, yL=32). Verifica si la PT210 soporta GS v 0.',
          build: _patternGsv0Manual,
        ),
        ReceiptDiagnosticScenario(
          id: 'ROD_64',
          label: 'Barra 64px (k=64)',
          description:
              'Barra negra 64x16 con bandas k=64. Mide el ancho impreso para calibrar escala horizontal.',
          build: (p, _) => _barProbe(p, 64),
        ),
        ReceiptDiagnosticScenario(
          id: 'ROD_128',
          label: 'Barra 128px (k=128)',
          description:
              'Barra negra 128x16 con bandas k=128. Comprueba si bands of 128 still imprime en un solo bloque.',
          build: (p, _) => _barProbe(p, 128),
        ),
        ReceiptDiagnosticScenario(
          id: 'ROD_200',
          label: 'Barra 200px (k=200)',
          description:
              'Barra negra 200x16 con bandas k=200 (ancho natural del logo en 58mm). Determina el límite máximo de banda.',
          build: (p, _) => _barProbe(p, 200),
        ),
        ReceiptDiagnosticScenario(
          id: 'LOGO_CANONICAL',
          label: 'Logo encoder corregido (FASE 5)',
          description:
              'El logo real con ReceiptImageEncoder (ESC * por bandas, k correcto, centrado). Es el método que ahora usan los recibos.',
          build: _logoCanonical,
        ),
      ];

  // ─── Helpers ────────────────────────────────────────────────────────────────

  static Future<Generator> _gen(PrinterConfigEntity p) async {
    final profile = await CapabilityProfile.load();
    return Generator(_paper(p), profile);
  }

  static PaperSize _paper(PrinterConfigEntity p) =>
      p.paperWidth == PrinterPaperWidth.mm58 ? PaperSize.mm58 : PaperSize.mm80;

  static int _defaultLogoWidth(PrinterConfigEntity p) =>
      p.paperWidth == PrinterPaperWidth.mm58 ? 128 : 160;

  /// Descarga y decodifica el logo configurado, redimensionado a [maxWidth].
  static Future<img.Image?> _logo(
      PrinterConfigEntity p, ReceiptConfigEntity? cfg, int maxWidth) async {
    final configuredLogoUrl = cfg?.logoPrintUrl ?? cfg?.logoUrl;
    if (cfg == null || !cfg.showLogo || configuredLogoUrl == null) return null;
    try {
      final dio = Dio();
      final resp = await dio.get<List<int>>(
         configuredLogoUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      if (resp.data == null || resp.statusCode != 200) return null;
      final decoded = img.decodeImage(Uint8List.fromList(resp.data!));
      if (decoded == null) return null;
      return img.copyResize(decoded, width: maxWidth, maintainAspect: true);
    } catch (_) {
      return null;
    }
  }

  /// Patrón artificial reconocible: 4 franjas horizontales + borde negro.
  static img.Image _makePattern(int w, int h) {
    final im = img.Image(width: w, height: h, numChannels: 3);
    final stripeH = h ~/ 4;
    for (var y = 0; y < h; y++) {
      final stripe = y ~/ stripeH;
      for (var x = 0; x < w; x++) {
        final border = x == 0 || y == 0 || x == w - 1 || y == h - 1;
        final on = border || stripe.isEven;
        im.setPixelRgb(x, y, on ? 0 : 255, on ? 0 : 255, on ? 0 : 255);
      }
    }
    return im;
  }

  // ─── Escenarios ────────────────────────────────────────────────────────────

  static Future<List<int>> _text3k(
      PrinterConfigEntity p, ReceiptConfigEntity? _) async {
    final gen = await _gen(p);
    final b = <int>[];
    b.addAll(gen.reset());
    for (var i = 0; i < 96; i++) {
      b.addAll(gen.text(
          '[$i] ${'AURA POS LINEA DE PRUEBA $i'.padRight(46, '.')}'));
    }
    b.addAll(gen.emptyLines(3));
    if (p.autoCut) b.addAll(gen.cut());
    return b;
  }

  static Future<List<int>> _logoWithWidth(PrinterConfigEntity p,
      ReceiptConfigEntity? cfg, int width,
      {bool addText = true}) async {
    final gen = await _gen(p);
    final b = <int>[];
    b.addAll(gen.reset());
    final logo = await _logo(p, cfg, width);
    if (logo == null) {
      await ReceiptDebugLogger.log(
          'diag', 'LOGO_$width sin logo (cfg null o descarga fallida)');
      b.addAll(gen.text('(sin logo disponible)'));
    } else {
      final escPos = gen.image(logo, align: PosAlign.center);
      await ReceiptDebugLogger.log(
          'diag',
          'LOGO_$width logo=${logo.width}x${logo.height} escPos=${escPos.length}B '
          '${ReceiptDebugLogger.describeImageCommands(escPos)}');
      b.addAll(escPos);
    }
    b.addAll(gen.emptyLines(1));
    if (addText) {
      b.addAll(gen.text('END LOGO $width-0123456789',
          styles: const PosStyles(align: PosAlign.center)));
    }
    b.addAll(gen.emptyLines(2));
    if (p.autoCut) b.addAll(gen.cut());
    return b;
  }

  static Future<List<int>> _patternImage(
      PrinterConfigEntity p, ReceiptConfigEntity? _) async {
    final gen = await _gen(p);
    final b = <int>[];
    b.addAll(gen.reset());
    final pattern = _makePattern(64, 32);
    final escPos = gen.image(pattern, align: PosAlign.center);
    await ReceiptDebugLogger.log(
        'diag',
        'PATTERN_IMAGE escPos=${escPos.length}B '
        '${ReceiptDebugLogger.describeImageCommands(escPos)}');
    b.addAll(escPos);
    b.addAll(gen.emptyLines(1));
    b.addAll(gen.text('END PATTERN IMAGE',
        styles: const PosStyles(align: PosAlign.center)));
    b.addAll(gen.emptyLines(2));
    return b;
  }

  static Future<List<int>> _patternEscStarManual(
      PrinterConfigEntity p, ReceiptConfigEntity? _) async {
    final gen = await _gen(p);
    final pattern = _makePattern(64, 32);
    final banded = ReceiptImageEncoder.encode(
      pattern,
      maxBandWidth: pattern.width,
    );
    await ReceiptDebugLogger.log(
        'diag',
        'PATTERN_ESCSTAR_MANUAL banded=${banded.length}B '
        '${ReceiptDebugLogger.describeImageCommands(banded)}');
    final b = <int>[];
    b.addAll(gen.reset());
    b.addAll(banded);
    b.addAll(gen.emptyLines(1));
    b.addAll(gen.text('END ESC* MANUAL',
        styles: const PosStyles(align: PosAlign.center)));
    b.addAll(gen.emptyLines(2));
    return b;
  }

  static Future<List<int>> _manualImageTest(
      PrinterConfigEntity p, int width, int height) async {
    final gen = await _gen(p);
    final pattern = _makePattern(width, height);
    final imageBytes = ReceiptImageEncoder.encode(
      pattern,
      maxBandWidth: width,
    );
    await ReceiptDebugLogger.log(
        'diag',
        'IMAGE_${width}x$height escPos=${imageBytes.length}B '
        '${ReceiptDebugLogger.describeImageCommands(imageBytes)}');
    final b = <int>[];
    b.addAll(gen.reset());
    b.addAll(gen.setStyles(const PosStyles(align: PosAlign.center)));
    b.addAll(imageBytes);
    b.addAll(gen.setStyles(const PosStyles(align: PosAlign.left)));
    b.addAll(gen.text('IMAGE TEST OK'));
    b.addAll(gen.text('AFTER IMAGE $width X $height'));
    b.addAll(gen.emptyLines(2));
    if (p.autoCut) b.addAll(gen.cut());
    return b;
  }

  static Future<List<int>> _imageSequence(
      PrinterConfigEntity p, ReceiptConfigEntity? _) async {
    final gen = await _gen(p);
    final b = <int>[];
    b.addAll(gen.reset());
    b.addAll(gen.text('AAAAAA'));
    for (final label in const ['BBBBBB', 'CCCCCC', 'DDDDDD']) {
      final imageBytes = ReceiptImageEncoder.encode(
        _makePattern(64, 32),
        maxBandWidth: 64,
      );
      b.addAll(gen.setStyles(const PosStyles(align: PosAlign.center)));
      b.addAll(imageBytes);
      b.addAll(gen.setStyles(const PosStyles(align: PosAlign.left)));
      b.addAll(gen.text(label));
    }
    b.addAll(gen.emptyLines(2));
    if (p.autoCut) b.addAll(gen.cut());
    return b;
  }

  static Future<List<int>> _patternGsv0Manual(
      PrinterConfigEntity p, ReceiptConfigEntity? _) async {
    final gen = await _gen(p);
    final pattern = _makePattern(64, 32);
    final raster = ReceiptImageEncoder.encodeGsV0(pattern);
    await ReceiptDebugLogger.log(
        'diag',
        'PATTERN_GSV0_MANUAL raster=${raster.length}B primerBytes='
        '${ReceiptDebugLogger.hex(raster, max: 8)}');
    final b = <int>[];
    b.addAll(gen.reset());
    b.addAll(raster);
    b.addAll(gen.emptyLines(1));
    b.addAll(gen.text('END GSV0 MANUAL',
        styles: const PosStyles(align: PosAlign.center)));
    b.addAll(gen.emptyLines(2));
    return b;
  }

  static Future<List<int>> _barProbe(
      PrinterConfigEntity p, int width) async {
    final gen = await _gen(p);
    final bar = img.Image(width: width, height: 16, numChannels: 3);
    img.fill(bar, color: img.ColorRgb8(0, 0, 0));
    final banded = ReceiptImageEncoder.encode(
      bar,
      maxBandWidth: bar.width,
    );
    await ReceiptDebugLogger.log(
        'diag',
        'ROD_$width bar=${width}x16 banded=${banded.length}B '
        '${ReceiptDebugLogger.describeImageCommands(banded)}');
    final b = <int>[];
    b.addAll(gen.reset());
    b.addAll(banded);
    b.addAll(gen.emptyLines(1));
    b.addAll(gen.text('END BAR $width',
        styles: const PosStyles(align: PosAlign.center)));
    b.addAll(gen.emptyLines(2));
    if (p.autoCut) b.addAll(gen.cut());
    return b;
  }

  static Future<List<int>> _logoCanonical(
      PrinterConfigEntity p, ReceiptConfigEntity? cfg) async {
    final gen = await _gen(p);
    final b = <int>[];
    b.addAll(gen.reset());
    final maxWidth = p.paperWidth == PrinterPaperWidth.mm58 ? 200 : 280;
    final logo = await _logo(p, cfg, maxWidth);
    if (logo == null) {
      await ReceiptDebugLogger.log('diag', 'LOGO_CANONICAL sin logo');
      b.addAll(gen.text('(sin logo disponible)'));
    } else {
      final encoded = ReceiptImageEncoder.encode(
        logo,
        maxBandWidth: p.paperWidth == PrinterPaperWidth.mm58
            ? ReceiptImageEncoder.maxBandWidthMm58
            : ReceiptImageEncoder.maxBandWidthMm80,
      );
      await ReceiptDebugLogger.log(
          'diag',
          'LOGO_CANONICAL logo=${logo.width}x${logo.height} '
          'escPos=${encoded.length}B '
          '${ReceiptDebugLogger.describeImageCommands(encoded)}');
      b.addAll(gen.setStyles(const PosStyles(align: PosAlign.center)));
      b.addAll(encoded);
      b.addAll(gen.setStyles(const PosStyles(align: PosAlign.left)));
    }
    b.addAll(gen.emptyLines(1));
    b.addAll(gen.text('END CANONICAL',
        styles: const PosStyles(align: PosAlign.center)));
    b.addAll(gen.emptyLines(2));
    if (p.autoCut) b.addAll(gen.cut());
    return b;
  }
}
