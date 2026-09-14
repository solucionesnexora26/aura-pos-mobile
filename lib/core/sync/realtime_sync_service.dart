import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Estado de suscripción de una tabla individual.
enum TableStatus {
  /// Suscripción activa y funcionando.
  subscribed,

  /// Error al suscribirse (ej: Realtime no habilitado).
  /// No se reintentará esta tabla.
  error,

  /// Tabla deshabilitada por configuración (sin Realtime en el servidor).
  disabled,
}

/// Servicio centralizado de Supabase Realtime para la app móvil.
///
/// Escucha cambios PostgresChanges en las tablas relevantes y ejecuta un
/// callback de sincronización (debounced) cuando llegan eventos. El debounce
/// coalesce ráfagas de eventos (p. ej. sale + sale_items + payments en
/// milisegundos) en una sola llamada de sync.
///
/// Incluye monitoreo de salud de canales y reconexión automática:
/// - Escucha el estado de cada canal (subscribed/closed/timedOut).
/// - Si un canal se desconecta, intenta reconectarse automáticamente.
/// - Si la reconexión falla tras múltiples intentos, notifica vía callback.
/// - Las tablas con error permanente (Realtime no habilitado) se excluyen
///   de reconexiones futuras para no generar ruido.
class RealtimeSyncService {
  RealtimeSyncService({
    required SupabaseClient client,
  }) : _client = client;

  final SupabaseClient _client;

  final List<RealtimeChannel> _channels = [];
  Timer? _debounceTimer;
  Timer? _healthCheckTimer;
  bool _active = false;
  int _reconnectAttempts = 0;

  /// Estado de suscripción por tabla. Las tablas en estado [TableStatus.error]
  /// o [TableStatus.disabled] no se reintantan en reconexiones.
  final Map<String, TableStatus> _tableStatus = {};

  /// Callback que se ejecuta cuando todos los canales activos fallan tras
  /// múltiples intentos de reconexión. Las tablas permanentemente fallidas
  /// (error / disabled) no cuentan para este cálculo.
  VoidCallback? _onAllChannelsFailed;

  /// Duración del debounce. Eventos dentro de esta ventana se coalescen
  /// en una sola llamada de [onSync].
  static const Duration _debounceDuration = Duration(milliseconds: 1500);

  /// Intervalo del health check de canales.
  static const Duration _healthCheckInterval = Duration(minutes: 2);

  /// Máximo de intentos de reconexión antes de reportar fallo.
  static const int _maxReconnectAttempts = 5;

  /// Delay base entre reintentos (exponential backoff).
  static const Duration _reconnectBaseDelay = Duration(seconds: 2);

  /// Mensaje que Supabase retorna cuando una tabla no tiene Realtime habilitado.
  static const String _realtimeNotEnabledMsg =
      'Please check Realtime is enabled for the given connect parameters';

  /// Tablas que el móvil escucha. Deben estar en la publicación
  /// `supabase_realtime` (migraciones 0001, 0015, 0018, 0024, 0042).
  static const List<String> _watchedTables = [
    'products',
    'product_variants',
    'categories',
    'customers',
    'profiles',
    'sales',
    'sale_items',
    'payments',
    'receipt_configs',
    'tpv_inventory',
  ];

  /// Inicia las suscripciones Realtime. [onSync] se ejecuta cuando llega
  /// un evento relevante (debounced). [onAllChannelsFailed] se ejecuta
  /// si todos los canales activos fallan tras múltiples intentos.
  /// Llamar solo cuando el TPV está vinculado.
  void start({
    required Future<void> Function() onSync,
    VoidCallback? onAllChannelsFailed,
  }) {
    if (_active) return;
    _active = true;
    _reconnectAttempts = 0;
    _onAllChannelsFailed = onAllChannelsFailed;

    _subscribeAll(onSync);

    // Health check periódico para detectar canales muertos.
    _healthCheckTimer = Timer.periodic(_healthCheckInterval, (_) {
      _checkChannelHealth(onSync);
    });
  }

  /// Detiene todas las suscripciones y limpia recursos. Llamar cuando el
  /// TPV se desvincula o la app se cierra.
  void stop() {
    _active = false;
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
    _onAllChannelsFailed = null;
    _reconnectAttempts = 0;
    for (final ch in _channels) {
      _client.removeChannel(ch);
    }
    _channels.clear();
    _tableStatus.clear();
  }

  /// Programa una sincronización con debounce. Si ya hay un timer activo,
  /// lo resetea — así múltiples eventos en ráfaga se coalescen en uno solo.
  void _scheduleSync(Future<void> Function() onSync) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () async {
      try {
        await onSync();
      } catch (e) {
        debugPrint('[RealtimeSync] Error en sync: $e');
      }
    });
  }

  /// Suscribe todas las tablas vigiladas que no estén en estado permanente
  /// de error (error o disabled).
  void _subscribeAll(Future<void> Function() onSync) {
    for (final table in _watchedTables) {
      final status = _tableStatus[table];
      // No reintentar tablas que ya fallaron permanentemente.
      if (status == TableStatus.error || status == TableStatus.disabled) {
        continue;
      }
      _subscribeTable(table, onSync);
    }
  }

  /// Suscribe una tabla individual con manejo de errores aislado.
  ///
  /// Si la suscripción falla porque Realtime no está habilitado para esa
  /// tabla, se marca como [TableStatus.error] permanentemente y no se
  /// reintenta. Esto evita ruido en logs y reconexiones innecesarias.
  void _subscribeTable(String table, Future<void> Function() onSync) {
    final channelName = 'realtime-mobile-$table';
    final channel = _client.channel(channelName);

    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      callback: (payload) {
        _reconnectAttempts = 0;
        debugPrint('[RealtimeSync] event $table ${payload.eventType} id=${payload.newRecord['id']}');
        _scheduleSync(onSync);
      },
    );

    channel.subscribe((status, [error]) {
      if (error != null) {
        final errorMsg = error.toString();
        if (errorMsg.contains(_realtimeNotEnabledMsg)) {
          _tableStatus[table] = TableStatus.error;
          debugPrint(
            '[RealtimeSync] $table: Realtime no habilitado — '
            'excluida de reconexiones futuras',
          );
        } else {
          debugPrint('[RealtimeSync][ERROR] $table: $error');
        }
      } else if (status == RealtimeSubscribeStatus.subscribed) {
        _tableStatus[table] = TableStatus.subscribed;
        debugPrint('[RealtimeSync] $table subscribed OK');
      } else {
        debugPrint('[RealtimeSync] $table status=$status');
      }
    });

    _channels.add(channel);
  }

  /// Verifica la salud de los canales. Solo reconecta tablas que estén
  /// en estado [TableStatus.subscribed] o sin estado previo.
  void _checkChannelHealth(Future<void> Function() onSync) {
    if (!_active || _channels.isEmpty) return;

    final client = _client;
    try {
      final channels = client.getChannels();
      if (channels.isEmpty && _active) {
        debugPrint('[RealtimeSync] no channels — reconnecting');
        _reconnect(onSync);
      }
    } catch (e) {
      debugPrint('[RealtimeSync][ERROR] health check failed: $e');
      if (_active) {
        _reconnect(onSync);
      }
    }
  }

  /// Intenta reconectar todas las tablas que no estén en estado permanente
  /// de error, con exponential backoff.
  void _reconnect(Future<void> Function() onSync) {
    if (!_active) return;
    _reconnectAttempts++;

    if (_reconnectAttempts > _maxReconnectAttempts) {
      debugPrint('[RealtimeSync] max reconnect attempts reached');
      _onAllChannelsFailed?.call();
      return;
    }

    // Contar cuántas tablas activas tenemos (excluyendo error/disabled).
    final activeTables = _watchedTables.where((t) {
      final s = _tableStatus[t];
      return s != TableStatus.error && s != TableStatus.disabled;
    }).length;

    if (activeTables == 0) {
      debugPrint(
        '[RealtimeSync] todas las tablas en estado permanente de error — '
        'sin tablas que reconectar',
      );
      _onAllChannelsFailed?.call();
      return;
    }

    final delay = _reconnectBaseDelay * _reconnectAttempts;
    debugPrint(
      '[RealtimeSync] reconectando $activeTables tablas en '
      '${delay.inSeconds}s (intento $_reconnectAttempts/$_maxReconnectAttempts)',
    );

    Timer(delay, () {
      if (!_active) return;
      // Remover canales antiguos.
      for (final ch in _channels) {
        _client.removeChannel(ch);
      }
      _channels.clear();
      // Re-suscribir solo tablas activas.
      _subscribeAll(onSync);
    });
  }

  /// Indica si el servicio está activo.
  bool get isActive => _active;

  /// Mapa de estado de suscripción por tabla (solo lectura).
  Map<String, TableStatus> get tableStatus =>
      Map.unmodifiable(_tableStatus);
}
