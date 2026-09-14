import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/sync/sync_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

/// Widget raíz de Aura POS. Configura MaterialApp.router con el tema M3
/// (claro/oscuro) y el árbol de rutas de GoRouter. También restaura Realtime,
/// escucha cambios de conectividad y maneja el ciclo de vida de la app para
/// mantener el TPV conectado.
class AuraPosApp extends ConsumerStatefulWidget {
  const AuraPosApp({super.key});

  @override
  ConsumerState<AuraPosApp> createState() => _AuraPosAppState();
}

class _AuraPosAppState extends ConsumerState<AuraPosApp>
    with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);

    // Start Realtime and heartbeat after the first frame. The Supabase
    // client is already initialized in main.dart, so there's no need to
    // wait for a FutureProvider — we can start immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(syncControllerProvider.notifier).startRealtimeIfLinked();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  /// Called when the app returns from background.
  void _onAppResumed() {
    debugPrint('[APP] resumed');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref.read(tpvHeartbeatServiceProvider).tickOnce();
      ref.read(syncControllerProvider.notifier).push();
      ref.read(syncControllerProvider.notifier).startRealtimeIfLinked();
      // Pull silencioso al volver: captura ediciones hechas en la web
      // mientras la app estaba en background (sin depender de Realtime).
      // ignore: discarded_futures
      ref.read(syncRepositoryProvider).pullAll().then((r) {
        debugPrint('[APP] resumed pull: ${r.total} rows (custs=${r.customers})');
      });
    });
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (r) => r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet,
    );
    if (!hasConnection) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Reconciliación completa (push + pull) en background al recuperar red:
      // sube operaciones pendientes y descarga cambios hechos desde la web.
      // ignore: discarded_futures
      ref.read(syncControllerProvider.notifier).reconcileInBackground();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(appRouterProvider);
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
