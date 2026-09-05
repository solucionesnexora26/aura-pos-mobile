import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Log estructural para la instrumentación de impresión (FASE 2 del
/// diagnóstico PT210). Escribe cada evento en Logcat (debugPrint) y en el
/// archivo `<Documentos>/receipt_debug.log` para recoger evidencia del
/// dispositivo durante las pruebas aisladas.
class ReceiptDebugLogger {
  ReceiptDebugLogger._();

  static const String fileName = 'receipt_debug.log';

  static final List<String> _buffer = <String>[];

  /// Registra un evento y lo persiste inmediatamente en el archivo.
  static Future<void> log(String section, String message) async {
    final line = '[${DateTime.now().toIso8601String()}] [$section] $message';
    debugPrint(line);
    _buffer.add(line);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$fileName');
      await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
    } catch (_) {}
  }

  /// Limpia el archivo de log (para iniciar una sesión de diagnóstico nueva).
  static Future<void> clear() async {
    _buffer.clear();
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$fileName');
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  /// Representación hex de [bytes] entre [start] y [end], mostrando a lo
  /// sumo [max] bytes.
  static String hex(List<int> bytes, {int start = 0, int? end, int max = 16}) {
    final e = (end ?? bytes.length).clamp(0, bytes.length).toInt();
    final s = start.clamp(0, e).toInt();
    final slice = bytes.sublist(s, e);
    final shown = slice.take(max).toList();
    final extra = slice.length > max ? ' +${slice.length - max}' : '';
    return '${shown.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}$extra';
  }

  /// Posiciones (offset en bytes) donde aparece [needle] dentro de [bytes].
  static List<int> findAll(List<int> bytes, List<int> needle) {
    final res = <int>[];
    if (needle.isEmpty || bytes.length < needle.length) return res;
    var i = 0;
    while (i <= bytes.length - needle.length) {
      var same = true;
      for (var j = 0; j < needle.length; j++) {
        if (bytes[i + j] != needle[j]) {
          same = false;
          break;
        }
      }
      if (same) {
        res.add(i);
        i += needle.length;
      } else {
        i++;
      }
    }
    return res;
  }

  /// Inspecciona un buffer ESC/POS sin buscar LF dentro del bitmap.
  ///
  /// Los datos de ESC * son binarios y pueden contener 0x0A legítimamente;
  /// por eso el scanner avanza según la longitud definida por m y n, nunca
  /// hasta el primer LF. Para m=32/33 la longitud esperada es n*3; para m=0/1
  /// es n.
  static String describeImageCommands(List<int> bytes) {
    final b = StringBuffer();
    final imageParts = <String>[];
    var escStarCount = 0;
    var i = 0;
    while (i + 5 <= bytes.length) {
      if (bytes[i] != 27 || bytes[i + 1] != 42) {
        i++;
        continue;
      }

      escStarCount++;
      final mode = bytes[i + 2];
      final n = bytes[i + 3] + bytes[i + 4] * 256;
      final bytesPerColumn = (mode == 32 || mode == 33) ? 3 : 1;
      final knownMode = mode == 0 || mode == 1 || mode == 32 || mode == 33;
      final expected = n * bytesPerColumn;
      final dataStart = i + 5;
      final dataEnd = dataStart + expected;

      if (!knownMode) {
        imageParts.add('@$i(m$mode n$n UNSUPPORTED)');
        i += 2;
        continue;
      }
      if (dataEnd > bytes.length) {
        imageParts.add('@$i(m$mode n$n expected$expected TRUNCATED)');
        i = bytes.length;
        continue;
      }

      final hasLf = dataEnd < bytes.length && bytes[dataEnd] == 10;
      imageParts.add(
          '@$i(m$mode n$n expected$expected data$expected ${hasLf ? 'OK' : 'NO-LF'})');
      i = dataEnd + (hasLf ? 1 : 0);
    }

    if (escStarCount == 0) {
      b.write('ESC*:0');
    } else {
      b.write('ESC* x$escStarCount: ${imageParts.join(' ')}');
    }
    b.write(' | GSv0 x${_countGsv0(bytes)}');
    b.write(' | GS( x${findAll(bytes, [29, 40]).length}');
    b.write(' | ESC@ x${findAll(bytes, [27, 64]).length}');
    b.write(' | ESC3 x${findAll(bytes, [27, 51]).length}');
    b.write(' | ESC2 x${findAll(bytes, [27, 50]).length}');
    b.write(' | GSV x${findAll(bytes, [29, 86]).length}');
    return b.toString();
  }

  static int _countGsv0(List<int> bytes) {
    var count = 0;
    var i = 0;
    while (i + 8 <= bytes.length) {
      if (bytes[i] == 29 &&
          bytes[i + 1] == 118 &&
          bytes[i + 2] == 48) {
        final widthBytes = bytes[i + 4] + bytes[i + 5] * 256;
        final height = bytes[i + 6] + bytes[i + 7] * 256;
        final end = i + 8 + widthBytes * height;
        count++;
        i = end <= bytes.length ? end : bytes.length;
      } else {
        i++;
      }
    }
    return count;
  }
}
