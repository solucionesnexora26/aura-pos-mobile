import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../database/app_database.dart';

/// Instancia única de la base de datos Drift para toda la app.
/// Se mantiene viva durante todo el ciclo de vida (keepAlive) porque el
/// acceso a datos offline-first es transversal a todas las features.
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Caja de Hive para preferencias no sensibles (tema, idioma, impresora
/// favorita, etc). Debe abrirse en `main.dart` antes de correr la app.
final Provider<Box<dynamic>> preferencesBoxProvider = Provider<Box<dynamic>>((ref) {
  return Hive.box<dynamic>(AppConstants.hiveBoxPreferences);
});

/// Almacenamiento seguro cifrado para datos sensibles (ej. tokens futuros
/// de sincronización, claves de recuperación de PIN).
final Provider<FlutterSecureStorage> secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

/// Cliente Dio preparado para el futuro backend FastAPI. No se usa
/// activamente todavía: la app es 100% offline-first en esta fase.
final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  return dio;
});
