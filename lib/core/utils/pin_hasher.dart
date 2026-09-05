import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Genera y verifica hashes de PIN con salt aleatorio (SHA-256), evitando
/// almacenar el PIN en texto plano en la base de datos local.
abstract class PinHasher {
  PinHasher._();

  static String generateSalt({int length = 16}) {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String hash(String pin, String salt) {
    final Digest digest = sha256.convert(utf8.encode('$salt::$pin'));
    return digest.toString();
  }

  static bool verify(String pin, String salt, String storedHash) {
    if (hash(pin, salt) == storedHash) return true;
    // Compatibilidad con hashes generados por la web (formato 'salt:pin').
    return sha256.convert(utf8.encode('$salt:$pin')).toString() == storedHash;
  }
}
