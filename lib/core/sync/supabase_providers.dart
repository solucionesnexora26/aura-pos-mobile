import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../di/providers.dart';
import 'device_id_service.dart';

/// Servicio de device_id persistente (genera/lee el id del dispositivo).
final Provider<DeviceIdService> deviceIdServiceProvider =
    Provider<DeviceIdService>((ref) {
  return DeviceIdService(secureStorage: ref.watch(secureStorageProvider));
});

/// Cliente Supabase.
///
/// Es un [Provider] síncrono porque `main.dart` ya llama a
/// `Supabase.initialize()` antes de `runApp()`. No hay necesidad de un
/// FutureProvider encima: el cliente está disponible inmediatamente.
///
/// En entornos de test donde Supabase no está inicializado, lanza un
/// [StateError] descriptivo en vez de [SupabaseException].
final Provider<SupabaseClient> supabaseClientProvider =
    Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Devuelve el device_id actual (sin generar). Útil para construir headers.
final Provider<Future<String?>> deviceIdFutureProvider =
    Provider<Future<String?>>((ref) {
  return ref.read(deviceIdServiceProvider).getDeviceId();
});
