/// Configuración central de Supabase para la app móvil.
///
/// Los valores por defecto se compilan desde `--dart-define` en build
/// (Android/iOS) para no exponer secretos en el repo. Se pueden sobrescribir
/// con:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
abstract class SupabaseConfig {
  SupabaseConfig._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ofzsdjqqzdbqcblbjrev.supabase.co',
  );

  /// Publishable key (rol anon): usada por los TPVs para autenticarse con el
  /// header `x-device-id` y activarse con el código QR.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_pJd2ZtFNXmM0g9dWpeVRIw_SuJouIGw',
  );

  /// Header custom que identifica el dispositivo ante el RLS del backend.
  static const String deviceIdHeader = 'x-device-id';

  /// Clave en SecureStorage donde se guarda el device_id del dispositivo.
  static const String deviceIdStorageKey = 'aura_secure_device_id';

  /// Clave en SecureStorage del tpv_id vinculado a este dispositivo.
  static const String tpvIdStorageKey = 'aura_secure_tpv_id';
}
