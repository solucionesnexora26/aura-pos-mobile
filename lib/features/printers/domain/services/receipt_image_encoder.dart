import 'package:image/image.dart' as img;

/// Error producido cuando el payload ESC/POS no puede ser construido de forma
/// matemáticamente consistente.
class InvalidEscPosImageException implements Exception {
  const InvalidEscPosImageException(this.message);

  final String message;

  @override
  String toString() => 'Invalid ESC/POS image payload: $message';
}

/// Generador controlado para ESC * en modo 24-dot double-density (m=33).
///
/// El formato de cada bloque es:
///
///   ESC * 33 nL nH [n * 3 bytes] LF
///
/// [n] es el ancho horizontal en dots. Cada columna contiene tres bytes:
/// bits 0..7, 8..15 y 16..23 de la imagen. No se rota la imagen: la primera
/// fila de [src] es la primera fila impresa del bloque.
class ReceiptImageEncoder {
  ReceiptImageEncoder._();

  /// Cap inicial conservador para una PT-210 de papel 57/58 mm.
  static const int maxBandWidthMm58 = 256;

  /// Cap inicial conservador para papel 80 mm.
  static const int maxBandWidthMm80 = 256;

  static const int _mode24DotDoubleDensity = 33;
  static const int _bytesPerColumn = 3;
  static const int _dotsPerBlock = 24;

  /// Codifica [src] a ESC * m=33 validando cada bloque antes de devolverlo.
  static List<int> encode(
    img.Image src, {
    required int maxBandWidth,
  }) {
    if (src.width < 1 || src.height < 1) {
      throw const InvalidEscPosImageException('image dimensions are invalid');
    }
    if (maxBandWidth < 1 || maxBandWidth > 65535) {
      throw InvalidEscPosImageException(
          'maxBandWidth=$maxBandWidth is outside the ESC/POS range');
    }

    final image = src.width > maxBandWidth
        ? img.copyResize(src, width: maxBandWidth, maintainAspect: true)
        : src;
    final width = image.width;
    final expectedDataBytesPerBlock = width * _bytesPerColumn;
    final bytes = <int>[27, 51, 0]; // ESC 3 0: bloques verticales contiguos.

    for (var top = 0; top < image.height; top += _dotsPerBlock) {
      final block = <int>[];
      for (var x = 0; x < width; x++) {
        for (var plane = 0; plane < _bytesPerColumn; plane++) {
          var value = 0;
          for (var bit = 0; bit < 8; bit++) {
            final y = top + plane * 8 + bit;
            if (_isDark(image, x, y)) {
              value |= 1 << (7 - bit);
            }
          }
          block.add(value);
        }
      }

      if (block.length != expectedDataBytesPerBlock) {
        throw InvalidEscPosImageException(
          'expected $expectedDataBytesPerBlock bytes, got ${block.length}',
        );
      }

      final nL = width & 0xFF;
      final nH = (width >> 8) & 0xFF;
      bytes
        ..addAll([27, 42, _mode24DotDoubleDensity, nL, nH])
        ..addAll(block)
        ..add(10); // LF finaliza el bloque ESC *.
    }

    bytes.addAll([27, 50]); // ESC 2: restaura el espaciado normal.
    return bytes;
  }

  /// Genera GS v 0 únicamente para pruebas A/B. No es el método usado por
  /// los recibos de producción mientras la PT-210 no lo confirme físicamente.
  static List<int> encodeGsV0(img.Image src) {
    if (src.width < 1 || src.height < 1) {
      throw const InvalidEscPosImageException('image dimensions are invalid');
    }
    final widthBytes = (src.width + 7) ~/ 8;
    final expected = widthBytes * src.height;
    final bytes = <int>[
      29, 118, 48, 0,
      widthBytes & 0xFF,
      (widthBytes >> 8) & 0xFF,
      src.height & 0xFF,
      (src.height >> 8) & 0xFF,
    ];
    final data = <int>[];
    for (var y = 0; y < src.height; y++) {
      for (var byteX = 0; byteX < widthBytes; byteX++) {
        var value = 0;
        for (var bit = 0; bit < 8; bit++) {
          if (_isDark(src, byteX * 8 + bit, y)) {
            value |= 1 << (7 - bit);
          }
        }
        data.add(value);
      }
    }
    if (data.length != expected) {
      throw InvalidEscPosImageException(
          'GS v 0 expected $expected bytes, got ${data.length}');
    }
    return bytes..addAll(data);
  }

  static bool _isDark(img.Image image, int x, int y) {
    if (x < 0 || y < 0 || x >= image.width || y >= image.height) {
      return false;
    }
    final pixel = image.getPixel(x, y);
    final alpha = pixel.a / 255;
    if (alpha < 0.01) return false;

    // Componer contra blanco antes del threshold para que un alpha parcial no
    // se convierta accidentalmente en negro sólido.
    final red = pixel.r * alpha + 255 * (1 - alpha);
    final green = pixel.g * alpha + 255 * (1 - alpha);
    final blue = pixel.b * alpha + 255 * (1 - alpha);
    final gray = 0.299 * red + 0.587 * green + 0.114 * blue;
    return gray <= 127;
  }
}
