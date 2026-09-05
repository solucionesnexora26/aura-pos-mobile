import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../di/providers.dart';
import 'realtime_sync_service.dart';
import 'sync_push_service.dart';
import 'sync_queue_service.dart';
import 'sync_repository.dart';
import 'supabase_providers.dart';
import 'tpv_activation_service.dart';
import 'tpv_heartbeat_service.dart';

export 'tpv_activation_service.dart' show LinkedTpvInfo;

/// Estado del TPV en el servidor (devuelto por verify_tpv_link RPC).
class TpvServerStatus {
  const TpvServerStatus({
    required this.linked,
    required this.tpvId,
    required this.tpvName,
    required this.status,
    this.lastSeenAt,
    this.activationCode,
    this.deviceId,
  });

  final bool linked;
  final String tpvId;
  final String tpvName;
  final int status;
  final DateTime? lastSeenAt;
  final String? activationCode;
  final String? deviceId;
}

/// Repositorio de sync con cliente y BD inyectados.
final Provider<SyncRepository> syncRepositoryProvider =
    Provider<SyncRepository>((ref) {
  return SyncRepository(
    client: ref.watch(supabaseClientProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

/// Servicio de activación del TPV.
final Provider<TpvActivationService> tpvActivationServiceProvider =
    Provider<TpvActivationService>((ref) {
  return TpvActivationService(
    client: ref.watch(supabaseClientProvider),
    deviceIdService: ref.watch(deviceIdServiceProvider),
  );
});

/// Escritor de la cola offline (enqueue de ventas, caja, inventario).
final Provider<SyncQueueService> syncQueueServiceProvider =
    Provider<SyncQueueService>((ref) {
  return SyncQueueService(ref.watch(appDatabaseProvider));
});

/// Servicio de push: sube la cola offline a Supabase.
final Provider<SyncPushService> syncPushServiceProvider =
    Provider<SyncPushService>((ref) {
  return SyncPushService(
    client: ref.watch(supabaseClientProvider),
    db: ref.watch(appDatabaseProvider),
    deviceIdService: ref.watch(deviceIdServiceProvider),
  );
});

/// Servicio de Realtime centralizado. Escucha cambios en tablas relevantes
/// y dispara sync debounced. Se inicializa una sola vez.
final Provider<RealtimeSyncService> realtimeSyncServiceProvider =
    Provider<RealtimeSyncService>((ref) {
  return RealtimeSyncService(client: ref.watch(supabaseClientProvider));
});

/// Servicio de heartbeat del TPV. Actualiza `last_seen_at` periódicamente
/// y detecta desconexiones.
final Provider<TpvHeartbeatService> tpvHeartbeatServiceProvider =
    Provider<TpvHeartbeatService>((ref) {
  return TpvHeartbeatService(client: ref.watch(supabaseClientProvider));
});

/// Estado del estado de sincronización del dispositivo.
sealed class SyncState {
  const SyncState();
}

class SyncIdle extends SyncState {
  const SyncIdle();
}

class SyncLinking extends SyncState {
  const SyncLinking();
}

class SyncLinked extends SyncState {
  const SyncLinked({required this.tpvId, required this.tpvName});
  final String tpvId;
  final String tpvName;
}

class SyncActivationFailed extends SyncState {
  const SyncActivationFailed(this.message);
  final String message;
}

class SyncPulling extends SyncState {
  const SyncPulling();
}

class SyncPushing extends SyncState {
  const SyncPushing();
}

class SyncUnlinking extends SyncState {
  const SyncUnlinking();
}

class SyncCompleted extends SyncState {
  const SyncCompleted({required this.result});
  final SyncPullResult result;
}

class SyncError extends SyncState {
  const SyncError(this.message);
  final String message;
}

/// Notifier that orchestrates TPV linking, sync, heartbeat, and realtime.
class SyncController extends Notifier<SyncState> {
  Timer? _periodicPushTimer;
  Future<void> _syncChain = Future<void>.value();

  @override
  SyncState build() {
    return const SyncIdle();
  }

  Future<void> activateAndPull(String code) async {
    state = const SyncLinking();
    try {
      final service = ref.read(tpvActivationServiceProvider);
      final result = await service.activate(code);
      ref.invalidate(linkedTpvInfoProvider);
      state = SyncLinked(tpvId: result.tpvId, tpvName: result.name);
      state = const SyncPushing();
      final futures = <Future<void>>[
        ref.read(syncQueueServiceProvider).enqueueAllCatalog().then((_) =>
            ref.read(syncPushServiceProvider).pushAll(),),
        ref.read(syncRepositoryProvider).pullAll(),
      ];
      await Future.wait(futures);
      state = const SyncIdle();
      _startRealtime();
      _startHeartbeat();
    } on TpvActivationException catch (e) {
      state = SyncActivationFailed(e.message);
    } catch (e) {
      state = SyncActivationFailed('Error inesperado: $e');
    }
  }

  Future<void> pull() async {
    await _pull();
  }

  /// Inicia Realtime y heartbeat si el dispositivo ya está vinculado.
  /// Llamar al abrir la app para restaurar la escucha después de un reinicio.
  /// Verifica el estado del TPV en el servidor para evitar suscribirse
  /// a un TPV que fue desactivado desde la web.
  Future<void> startRealtimeIfLinked() async {
    final service = ref.read(tpvActivationServiceProvider);
    final linked = await service.isLinked();
    if (!linked) return;

    // Verificar que el TPV sigue activo en el servidor.
    final serverStatus = await verifyTpvLinkOnServer();
    if (serverStatus == null || !serverStatus.linked) {
      debugPrint('[SYNC] TPV linked locally but not on server — clearing');
      await service.unlink();
      return;
    }
    if (serverStatus.status != 1) {
      debugPrint('[SYNC] TPV status on server: ${serverStatus.status} — not active');
      return;
    }

    // Asegurar que activation_code y tpv_name estén guardados localmente
    // (necesarios para el número de ticket y el recibo).
    final deviceIdService = ref.read(deviceIdServiceProvider);
    if (serverStatus.activationCode != null &&
        serverStatus.activationCode!.isNotEmpty) {
      await deviceIdService.saveActivationCode(serverStatus.activationCode!);
    }
    await deviceIdService.saveTpvName(serverStatus.tpvName);

    debugPrint('[SYNC] TPV verified on server: ${serverStatus.tpvName}');
    _startRealtime();
    _startHeartbeat();
    // Pull inicial en el arranque: descarga la configuración (métodos de pago,
    // catálogo, clientes) para que las pantallas no dependan del fallback local.
    // ignore: discarded_futures
    ref.read(syncRepositoryProvider).pullAll().catchError((Object e) {
      debugPrint('[SYNC] initial pull failed: $e');
    });
  }

  /// Verifies the TPV link status on the server using the verify_tpv_link RPC.
  Future<TpvServerStatus?> verifyTpvLinkOnServer() async {
    try {
      final client = ref.read(supabaseClientProvider);

      final result = await client.rpc<dynamic>('verify_tpv_link');
      if (result == null) return null;

      final data = result as Map<String, dynamic>;
      final linked = data['linked'] as bool? ?? false;
      if (!linked) return null;

      return TpvServerStatus(
        linked: linked,
        tpvId: data['tpv_id']?.toString() ?? '',
        tpvName: data['tpv_name']?.toString() ?? '',
        status: data['status'] is num ? (data['status'] as num).toInt() : 0,
        lastSeenAt: data['last_seen_at'] != null
            ? DateTime.tryParse(data['last_seen_at'].toString())
            : null,
        activationCode: data['activation_code']?.toString(),
        deviceId: data['device_id']?.toString(),
      );
    } catch (e) {
      debugPrint('[SYNC][ERROR] verifyTpvLinkOnServer: $e');
      return null;
    }
  }

  Future<SyncPullResult?> _pull() async {
    state = const SyncPulling();
    try {
      final repo = ref.read(syncRepositoryProvider);
      final result = await repo.pullAll();
      if (result.hasErrors) {
        state = SyncError(
          'No se pudieron descargar: ${result.failedTables.join(' | ')}',
        );
      } else {
        state = SyncCompleted(result: result);
      }
      return result;
    } catch (e) {
      state = SyncError('Error al descargar datos: $e');
      return null;
    }
  }

  /// Sube la cola offline a Supabase.
  Future<SyncPushResult?> push() async {
    debugPrint('[SYNC_CONTROLLER] push() started');
    state = const SyncPushing();
    try {
      final service = ref.read(syncPushServiceProvider);
      debugPrint('[SYNC_CONTROLLER] SyncPushService obtained');
      final result = await service.pushAll();
      debugPrint('[SYNC_CONTROLLER] pushAll result: pushed=${result.pushed} failed=${result.failed}');
      state = result.failed > 0
          ? SyncError('${result.failed} operación(es) no se pudieron subir')
          : const SyncIdle();
      return result;
    } catch (e, st) {
      debugPrint('[SYNC_CONTROLLER][ERROR] push() failed: $e');
      debugPrint('[SYNC_CONTROLLER][ERROR] stack: $st');
      state = SyncError('Error al subir datos: $e');
      return null;
    }
  }

  /// Sincronización completa: primero sube las operaciones locales y después
  /// descarga el estado remoto. Este orden es obligatorio para que un borrado
  /// local no sea reactivado por una fila remota todavía activa.
  Future<void> syncAll() async {
    return _enqueueSync(() async {
      debugPrint('[SYNC_CONTROLLER] syncAll() started');
      // Push first: a local deletion/update must reach the server before the
      // pull can reconcile the local database. Pull-first discards pending
      // local deletions when the server still returns the active row.
      final pushResult = await push();
      final pullResult = await _pull();
      if ((pushResult == null || pushResult.failed > 0) &&
          pullResult != null && !pullResult.hasErrors) {
        state = SyncError(
          pushResult == null
              ? 'No se pudieron subir las operaciones locales'
              : '${pushResult.failed} operación(es) no se pudieron subir',
        );
      }
      debugPrint('[SYNC_CONTROLLER] syncAll() finished');
    });
  }

  /// Ejecuta una sincronización en segundo plano sin modificar SyncState.
  /// Comparte la misma cola que el botón y Realtime, evitando carreras.
  Future<void> _syncInBackground() {
    return _enqueueSync(() async {
      try {
        final pushResult =
            await ref.read(syncPushServiceProvider).pushAll();
        if (pushResult.pushed > 0 || pushResult.failed > 0) {
          debugPrint(
            '[SYNC_CONTROLLER] periodic push: '
            'pushed=${pushResult.pushed} failed=${pushResult.failed}',
          );
        }
      } catch (e) {
        debugPrint('[SYNC_CONTROLLER] periodic push failed: $e');
      }
      try {
        final pullResult = await ref.read(syncRepositoryProvider).pullAll();
        debugPrint(
          '[SYNC_CONTROLLER] periodic pull: ${pullResult.total} rows '
          '(cats=${pullResult.categories} brands=${pullResult.brands} '
          'suppliers=${pullResult.suppliers} prods=${pullResult.products} '
          'vars=${pullResult.variants} custs=${pullResult.customers} '
          'users=${pullResult.users} receipts=${pullResult.receiptConfigs})'
          '${pullResult.hasErrors ? ' errors=${pullResult.failedTables}' : ''}',
        );
      } catch (e) {
        debugPrint('[SYNC_CONTROLLER] periodic pull failed: $e');
      }
    });
  }

  Future<void> _enqueueSync(Future<void> Function() operation) {
    final next = _syncChain.then((_) => operation());
    _syncChain = next.catchError((_) {});
    return next;
  }

  /// Desvincula el dispositivo del TPV. Antes sube los datos pendientes
  /// (push) para no perder ventas/catálogo; luego desvincula y deja la
  /// pantalla lista para vincular un TPV nuevo.
  Future<void> unlink() async {
    _stopRealtime();
    _stopHeartbeat();
    try {
      await push();
    } catch (_) {
      // Si el push falla, seguimos intentando desvincular; el usuario puede
      // reintentar la sincronización más tarde.
    }
    state = const SyncUnlinking();
    try {
      final service = ref.read(tpvActivationServiceProvider);
      await service.unlink();
      ref.invalidate(linkedTpvInfoProvider);
      state = const SyncIdle();
    } on TpvActivationException catch (e) {
      state = SyncError(e.message);
    } catch (e) {
      state = SyncError('Error al desvincular: $e');
    }
  }

  /// Heartbeat: actualiza last_seen_at y detecta desconexiones.
  /// También intenta push periódico de la cola offline.
  void _startHeartbeat() {
    final heartbeat = ref.read(tpvHeartbeatServiceProvider);
    if (heartbeat.isActive) return;
    heartbeat.start(
      onDisconnected: () {
        debugPrint('[SYNC_CONTROLLER] heartbeat detected disconnection');
        _stopRealtime();
        _stopPeriodicPush();
        state = const SyncError('TPV desconectado del servidor');
      },
    );
    _startPeriodicPush();
  }

  /// Sync periódico silencioso: cada 30 segundos ejecuta push + pull
  /// SIN modificar el estado global (no cambia SyncState). Así:
  /// 1. No interfiere con la UI ni con syncs manuales del usuario.
  /// 2. No se bloquea si el estado anterior fue SyncError.
  /// 3. Siempre reintenta al siguiente ciclo, sin importar errores previos.
  /// 30s es compromiso entre frescura (web→POS) y consumo batería/red.
  void _startPeriodicPush() {
    _stopPeriodicPush();
    _periodicPushTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _syncInBackground();
    });
  }

  void _stopPeriodicPush() {
    _periodicPushTimer?.cancel();
    _periodicPushTimer = null;
  }

  void _stopHeartbeat() {
    ref.read(tpvHeartbeatServiceProvider).stop();
    _stopPeriodicPush();
  }

  /// Inicia las suscripciones Realtime. Se llama después de vincular o
  /// al detectar que el TPV ya está vinculado al entrar a la app.
  void _startRealtime() {
    final realtime = ref.read(realtimeSyncServiceProvider);
    if (realtime.isActive) return;
    realtime.start(
      onSync: () async {
        await syncAll();
      },
      onAllChannelsFailed: () {
        debugPrint('[SYNC_CONTROLLER] all Realtime channels failed');
        _stopHeartbeat();
        state = const SyncError('Conexión Realtime perdida');
      },
    );
  }

  /// Detiene las suscripciones Realtime.
  void _stopRealtime() {
    ref.read(realtimeSyncServiceProvider).stop();
  }
}

final NotifierProvider<SyncController, SyncState> syncControllerProvider =
    NotifierProvider<SyncController, SyncState>(SyncController.new);

/// Información del TPV vinculado al dispositivo. `null` si no está vinculado.
/// Es `autoDispose` para que se re-ejecute cada vez que la pantalla de
/// vinculación se monta (al navegar de vuelta) y detecte el estado actual.
final AutoDisposeFutureProvider<LinkedTpvInfo?> linkedTpvInfoProvider =
    FutureProvider.autoDispose<LinkedTpvInfo?>((ref) async {
  return ref.read(tpvActivationServiceProvider).fetchLinkedInfo();
});

/// Provider de la BD (re-export para conveniencia).
final Provider<AppDatabase> dbProvider = appDatabaseProvider;
