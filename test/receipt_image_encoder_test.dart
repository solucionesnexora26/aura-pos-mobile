import 'package:aura_pos/features/printers/domain/services/receipt_image_encoder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('ESC * m=33 declares n dots and emits n*3 bytes per block', () {
    final image = img.Image(width: 64, height: 32, numChannels: 3);
    final bytes = ReceiptImageEncoder.encode(image, maxBandWidth: 64);
    final blocks = _parseEscStar(bytes);

    expect(blocks, hasLength(2));
    for (final block in blocks) {
      expect(block.mode, 33);
      expect(block.n, 64);
      expect(block.dataLength, 64 * 3);
      expect(block.hasLf, isTrue);
    }
  });

  for (final dimensions in const [
    (64, 32),
    (128, 64),
    (160, 80),
    (256, 128),
  ]) {
    test('validates ${dimensions.$1}x${dimensions.$2} payload', () {
      final image = img.Image(
        width: dimensions.$1,
        height: dimensions.$2,
        numChannels: 3,
      );
      final bytes = ReceiptImageEncoder.encode(
        image,
        maxBandWidth: dimensions.$1,
      );
      final blocks = _parseEscStar(bytes);
      expect(blocks, hasLength((dimensions.$2 + 23) ~/ 24));
      expect(blocks.every((b) => b.n == dimensions.$1), isTrue);
      expect(
        blocks.every((b) => b.dataLength == dimensions.$1 * 3),
        isTrue,
      );
    });
  }

  test('reduces oversized image without exceeding the configured width', () {
    final image = img.Image(width: 512, height: 32, numChannels: 3);
    final bytes = ReceiptImageEncoder.encode(image, maxBandWidth: 256);
    final blocks = _parseEscStar(bytes);

    expect(blocks, isNotEmpty);
    expect(blocks.every((b) => b.n == 256), isTrue);
  });

  test('GS v 0 declares width in bytes and exact raster length', () {
    final image = img.Image(width: 65, height: 32, numChannels: 3);
    final bytes = ReceiptImageEncoder.encodeGsV0(image);
    final widthBytes = (65 + 7) ~/ 8;

    expect(bytes.sublist(0, 8), [29, 118, 48, 0, widthBytes, 0, 32, 0]);
    expect(bytes.length, 8 + widthBytes * 32);
  });
}

class _EscStarBlock {
  _EscStarBlock({
    required this.mode,
    required this.n,
    required this.dataLength,
    required this.hasLf,
  });

  final int mode;
  final int n;
  final int dataLength;
  final bool hasLf;
}

List<_EscStarBlock> _parseEscStar(List<int> bytes) {
  final blocks = <_EscStarBlock>[];
  var offset = 0;
  while (offset + 5 <= bytes.length) {
    if (bytes[offset] != 27 || bytes[offset + 1] != 42) {
      offset++;
      continue;
    }
    final mode = bytes[offset + 2];
    final n = bytes[offset + 3] + bytes[offset + 4] * 256;
    final expected = (mode == 32 || mode == 33) ? n * 3 : n;
    final dataStart = offset + 5;
    final dataEnd = dataStart + expected;
    expect(dataEnd <= bytes.length, isTrue);
    final hasLf = dataEnd < bytes.length && bytes[dataEnd] == 10;
    blocks.add(_EscStarBlock(
      mode: mode,
      n: n,
      dataLength: expected,
      hasLf: hasLf,
    ));
    offset = dataEnd + (hasLf ? 1 : 0);
  }
  return blocks;
}
