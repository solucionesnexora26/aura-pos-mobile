import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/sync/sync_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/update/app_update_provider.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(syncControllerProvider.notifier).startRealtimeIfLinked();
    });

    // Auto-update: solo en release mode. En debug (flutter run) no se verifica.
    if (kReleaseMode) {
      // Startup update check: wait two frames so GoRouter's Navigator is mounted.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          performSilentUpdateCheck(ref);
        });
      });

      _startPeriodicUpdateChecks();
    }
  }

  void _startPeriodicUpdateChecks() {
    Timer.periodic(const Duration(minutes: 30), (_) {
      if (!mounted) return;
      performSilentUpdateCheck(ref);
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

  void _onAppResumed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref.read(tpvHeartbeatServiceProvider).tickOnce();
      ref.read(syncControllerProvider.notifier).push();
      ref.read(syncControllerProvider.notifier).startRealtimeIfLinked();

      // Auto-update on resume: solo en release mode.
      if (kReleaseMode) {
        performSilentUpdateCheck(ref);
      }

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
