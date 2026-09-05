import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';

/// Gestiona la identidad persistente del dispositivo.
///
/// El `device_id` se genera una sola vez y se guarda cifrado. El TPV se
/// vincula al backend enviando este id en el header `x-device-id` (RLS) y
/// al activar el código QR del TPV en la web.
class DeviceIdService {
  DeviceIdService({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  static const String _deviceIdKey =
      '${AppConstants.secureStorageKeyPrefix}device_id';
  static const String _tpvIdKey =
      '${AppConstants.secureStorageKeyPrefix}tpv_id';
  static const String _activationCodeKey =
      '${AppConstants.secureStorageKeyPrefix}activation_code';
  static const String _tpvNameKey =
      '${AppConstants.secureStorageKeyPrefix}tpv_name';

  final FlutterSecureStorage _secureStorage;

  /// Devuelve el device_id existente o genera y persiste uno nuevo.
  Future<String> getOrCreateDeviceId() async {
    final String? existing = await _secureStorage.read(key: _deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final String newId = const Uuid().v4();
    await _secureStorage.write(key: _deviceIdKey, value: newId);
    return newId;
  }

  Future<String?> getDeviceId() async {
    return _secureStorage.read(key: _deviceIdKey);
  }

  /// Guarda el tpv_id vinculado a este dispositivo tras activarlo.
  Future<void> saveTpvId(String tpvId) async {
    await _secureStorage.write(key: _tpvIdKey, value: tpvId);
  }

  Future<String?> getTpvId() async {
    return _secureStorage.read(key: _tpvIdKey);
  }

  Future<void> clearTpvId() async {
    await _secureStorage.delete(key: _tpvIdKey);
  }

  Future<void> saveActivationCode(String code) async {
    await _secureStorage.write(key: _activationCodeKey, value: code);
  }

  Future<String?> getActivationCode() async {
    return _secureStorage.read(key: _activationCodeKey);
  }

  Future<void> saveTpvName(String name) async {
    await _secureStorage.write(key: _tpvNameKey, value: name);
  }

  Future<String?> getTpvName() async {
    return _secureStorage.read(key: _tpvNameKey);
  }

  Future<void> clearAll() async {
    await _secureStorage.delete(key: _tpvIdKey);
    await _secureStorage.delete(key: _activationCodeKey);
    await _secureStorage.delete(key: _tpvNameKey);
  }
}
