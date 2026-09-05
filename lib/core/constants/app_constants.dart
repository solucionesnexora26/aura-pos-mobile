/// Constantes globales de Aura POS.
abstract class AppConstants {
  AppConstants._();

  static const String appName = 'Aura POS';
  static const String dbFileName = 'aura_pos.sqlite';
  static const String hiveBoxPreferences = 'aura_preferences';
  static const String secureStorageKeyPrefix = 'aura_secure_';

  // Seguridad
  static const int pinLength = 4;
  static const int maxPinAttempts = 5;
  static const Duration pinLockoutDuration = Duration(minutes: 5);
  static const Duration sessionTimeout = Duration(minutes: 30);

  // Paginación
  static const int defaultPageSize = 30;

  // Formato
  static const String defaultCurrencySymbol = '\$';
  static const String defaultLocale = 'es_CO';

  // Breakpoints responsivos (para tablets 8", 10", 12" y teléfonos)
  static const double breakpointPhone = 600;
  static const double breakpointTabletSmall = 840;
  static const double breakpointTabletLarge = 1200;

  // Impresión
  static const int printerWidth58mm = 32; // caracteres por línea aprox.
  static const int printerWidth80mm = 48;
}

/// Claves usadas en Hive para preferencias no sensibles.
abstract class PreferenceKeys {
  PreferenceKeys._();

  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String rememberedUsername = 'remembered_username';
  static const String favoritePrinterId = 'favorite_printer_id';
  static const String lastOpenCashRegisterId = 'last_open_cash_register_id';
}
