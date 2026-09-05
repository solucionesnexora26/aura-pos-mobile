import 'package:supabase_flutter/supabase_flutter.dart';

import 'device_id_service.dart';

/// Resultado de intentar activar el TPV con un código.
class TpvActivationResult {
  const TpvActivationResult({required this.tpvId, required this.name});
  final String tpvId;
  final String name;
}

/// Información del TPV vinculado al dispositivo actual.
class LinkedTpvInfo {
  const LinkedTpvInfo({
    required this.id,
    required this.name,
    this.activationCode,
    this.deviceId,
    this.status,
    this.lastSeenAt,
  });

  final String id;
  final String name;
  final String? activationCode;
  final String? deviceId;
  final int? status;
  final DateTime? lastSeenAt;
}

/// Activa el TPV en Supabase usando el código QR de 6 caracteres y el
/// device_id persistente del dispositivo.
class TpvActivationService {
  TpvActivationService({
    required SupabaseClient client,
    required DeviceIdService deviceIdService,
  })  : _client = client,
        _deviceIdService = deviceIdService;

  final SupabaseClient _client;
  final DeviceIdService _deviceIdService;

  /// Llama a la RPC `activate_tpv`. Lanza [TpvActivationException] si el
  /// código es inválido o el dispositivo ya está vinculado a otro TPV.
  Future<TpvActivationResult> activate(String code) async {
    final String deviceId = await _deviceIdService.getOrCreateDeviceId();

    final dynamic res;
    try {
      res = await _client.rpc<dynamic>(
        'activate_tpv',
        params: {'p_code': code.trim().toUpperCase(), 'p_device_id': deviceId},
      );
    } on PostgrestException catch (e) {
      final String msg = e.message.toLowerCase();
      if (msg.contains('codigo_invalido')) {
        throw const TpvActivationException('El código es inválido o ya fue usado.');
      }
      if (msg.contains('dispositivo_ya_vinculado')) {
        throw const TpvActivationException(
          'Este dispositivo ya está vinculado a otro TPV.',
        );
      }
      throw TpvActivationException('Error de red: ${e.message}');
    }

    final Map<String, dynamic> data = (res as Map).cast<String, dynamic>();
    final String tpvId = data['id']?.toString() ?? '';
    final String name = data['name']?.toString() ?? 'TPV';
    // La RPC no retorna activation_code, pero ya lo tenemos del código QR
    // que el usuario escaneó — es el parámetro `code` que se pasó.
    final String activationCode = code.trim().toUpperCase();

    await _deviceIdService.saveTpvId(tpvId);
    await _deviceIdService.saveTpvName(name);
    await _deviceIdService.saveActivationCode(activationCode);
    return TpvActivationResult(tpvId: tpvId, name: name);
  }

  /// Verifica si este dispositivo ya está vinculado (tiene tpv_id guardado).
  Future<bool> isLinked() async {
    final String? tpvId = await _deviceIdService.getTpvId();
    return tpvId != null && tpvId.isNotEmpty;
  }

  /// Lee el tpv_id guardado.
  Future<String?> linkedTpvId() => _deviceIdService.getTpvId();

  /// Consulta la información del TPV vinculado al dispositivo. Retorna `null`
  /// si el dispositivo no está vinculado o si la fila ya no existe en el
  /// backend (p. ej. fue deshabilitada desde la web).
  ///
  /// Primero intenta leer el tpv_id del almacenamiento local seguro. Si no
  /// está disponible (p. ej. se perdió por un reinicio en Xiaomi con
  /// encryptedSharedPreferences), consulta Supabase buscando el TPV con el
  /// device_id del dispositivo actual (la RLS `tpvs_anon_read_own` lo
  /// permite). Si lo encuentra, recupera el tpv_id localmente.
  Future<LinkedTpvInfo?> fetchLinkedInfo() async {
    // 1) Intento rápido: leer tpv_id guardado localmente.
    String? tpvId = await _deviceIdService.getTpvId();

    // 2) Si no hay tpv_id local, intentar recuperar desde Supabase.
    if (tpvId == null || tpvId.isEmpty) {
      final dynamic row;
      try {
        row = await _client
            .from('tpvs')
            .select('id, name, activation_code, device_id, status, last_seen_at')
            .eq('status', 1)
            .maybeSingle();
      } catch (_) {
        return null;
      }
      if (row == null) return null;

      final Map<String, dynamic> data = (row as Map).cast<String, dynamic>();
      tpvId = data['id']?.toString() ?? '';
      if (tpvId.isNotEmpty) {
        // Recuperar el tpv_id en almacenamiento local para la próxima vez.
        await _deviceIdService.saveTpvId(tpvId);
        final String? code = data['activation_code']?.toString();
        if (code != null && code.isNotEmpty) {
          await _deviceIdService.saveActivationCode(code);
        }
        await _deviceIdService.saveTpvName(data['name']?.toString() ?? 'TPV');
      }
      return LinkedTpvInfo(
        id: tpvId,
        name: data['name']?.toString() ?? 'TPV',
        activationCode: data['activation_code']?.toString(),
        deviceId: data['device_id']?.toString(),
        status: data['status'] is num ? (data['status'] as num).toInt() : null,
        lastSeenAt: data['last_seen_at'] != null
            ? DateTime.tryParse(data['last_seen_at'].toString())?.toLocal()
            : null,
      );
    }

    // 3) Hay tpv_id local → buscar la fila completa en Supabase.
    final dynamic res;
    try {
      res = await _client.from('tpvs').select('*').eq('id', tpvId).maybeSingle();
    } catch (_) {
      return null;
    }
    if (res == null) return null;

    final Map<String, dynamic> data = (res as Map).cast<String, dynamic>();
    final String? code = data['activation_code']?.toString();
    if (code != null && code.isNotEmpty) {
      await _deviceIdService.saveActivationCode(code);
    }
    await _deviceIdService.saveTpvName(data['name']?.toString() ?? 'TPV');
    return LinkedTpvInfo(
      id: data['id']?.toString() ?? tpvId,
      name: data['name']?.toString() ?? 'TPV',
      activationCode: code,
      deviceId: data['device_id']?.toString(),
      status: data['status'] is num ? (data['status'] as num).toInt() : null,
      lastSeenAt: data['last_seen_at'] != null
          ? DateTime.tryParse(data['last_seen_at'].toString())?.toLocal()
          : null,
    );
  }

  /// Desvincula este dispositivo del TPV: llama a la RPC `unlink_self_tpv`
  /// (que genera un nuevo código de activación y deja el TPV en "pendiente")
  /// y borra el tpv_id guardado localmente.
  Future<void> unlink() async {
    try {
      await _client.rpc<dynamic>('unlink_self_tpv');
    } on PostgrestException catch (e) {
      final String msg = e.message.toLowerCase();
      if (msg.contains('no_tpv_vinculado')) {
        throw const TpvActivationException('No hay TPV vinculado.');
      }
      throw TpvActivationException('Error al desvincular: ${e.message}');
    }
    await _deviceIdService.clearTpvId();
    await _deviceIdService.clearAll();
  }
}

class TpvActivationException implements Exception {
  const TpvActivationException(this.message);
  final String message;

  @override
  String toString() => message;
}
