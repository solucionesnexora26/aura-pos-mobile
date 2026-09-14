import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/sync/device_id_service.dart';
import 'core/sync/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FLUTTER_ERROR >> ${details.exception.runtimeType}: '
        '${details.exception}');
    debugPrint('FLUTTER_ERROR_STACK >> ${details.toString()}');
  };

  await initializeDateFormatting('es');

  // Hive se usa únicamente para preferencias no sensibles (tema, idioma,
  // impresora favorita). Los datos operativos viven en Drift (SQLite).
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AppConstants.hiveBoxPreferences);

  final deviceIdService = DeviceIdService(
    secureStorage: const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
  final String deviceId = await deviceIdService.getOrCreateDeviceId();

  // Supabase: el TPV se identifica ante el RLS con el header x-device-id.
  // Los headers se pasan aquí porque `SupabaseClient.headers` es inmutable.
  // Estos headers se propagan automáticamente a REST y a Realtime (via
  // SupabaseClient._headers -> RealtimeClient headers), por lo que
  // is_active_tpv() funciona también para eventos PostgresChanges.
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabaseAnonKey,
    headers: {SupabaseConfig.deviceIdHeader: deviceId},
  );

  runApp(
    const ProviderScope(
      child: AuraPosApp(),
    ),
  );
}
