import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio de heartbeat para el TPV.
///
/// Actualiza `last_seen_at` en el backend periódicamente (cada 5 min) para que:
/// 1. La web sepa que el dispositivo está online.
/// 2. La app verifique su propia conexión (si la RPC falla, el TPV se
///    desconectó).
/// 3. Sirve como health check: si el device_id no coincide con ningún tpvs,
///    la RPC devuelve `false` y la app puede reaccionar.
class TpvHeartbeatService {
  TpvHeartbeatService({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  Timer? _timer;
  bool _active = false;
  int _consecutiveFailures = 0;

  /// Intervalo entre heartbeats.
  static const Duration _interval = Duration(minutes: 5);

  /// Número máximo de fallos consecutivos antes de reportar desconexión.
  static const int _maxFailures = 3;

  /// Callback que se ejecuta cuando el heartbeat detecta desconexión.
  /// Se pasa desde el SyncController para notificar al usuario.
  VoidCallback? _onDisconnected;

  /// Inicia el heartbeat periódico. Llamar cuando el TPV está vinculado.
  /// [onDisconnected] se ejecuta si el heartbeat falla _maxFailures veces
  /// seguidas (el TPV se desconectó del backend).
  void start({VoidCallback? onDisconnected}) {
    if (_active) return;
    _active = true;
    _onDisconnected = onDisconnected;
    _consecutiveFailures = 0;

    // Primer heartbeat inmediato para validar la conexión.
    _tick();

    // Heartbeats periódicos.
    _timer = Timer.periodic(_interval, (_) => _tick());
  }

  /// Detiene el heartbeat. Llamar cuando el TPV se desvincula.
  void stop() {
    _active = false;
    _timer?.cancel();
    _timer = null;
    _onDisconnected = null;
    _consecutiveFailures = 0;
  }

  /// Ejecuta un heartbeat manual. Útil al reanudar la app desde background.
  Future<bool> tickOnce() async {
    return _tick();
  }

  /// Número de fallos consecutivos actuales.
  int get consecutiveFailures => _consecutiveFailures;

  /// Indica si el servicio está activo.
  bool get isActive => _active;

  Future<bool> _tick() async {
    try {
      final result = await _client.rpc<bool>('update_tpv_heartbeat');
      if (result == true) {
        _consecutiveFailures = 0;
        debugPrint('[HEARTBEAT] ok');
        return true;
      } else {
        // La RPC devolvió false → el device_id no matcha ningún TPV activo.
        _consecutiveFailures++;
        debugPrint('[HEARTBEAT] no_tpv_match (failures=$_consecutiveFailures)');
        _checkDisconnected();
        return false;
      }
    } catch (e) {
      _consecutiveFailures++;
      debugPrint('[HEARTBEAT][ERROR] failure=$_consecutiveFailures: $e');
      _checkDisconnected();
      return false;
    }
  }

  void _checkDisconnected() {
    if (_consecutiveFailures >= _maxFailures && _onDisconnected != null) {
      debugPrint('[HEARTBEAT] disconnected after $_consecutiveFailures failures');
      _onDisconnected!();
    }
  }
}
