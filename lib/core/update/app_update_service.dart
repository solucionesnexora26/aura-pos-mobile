import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Información de una versión remota disponible.
class RemoteVersion {
  final int versionCode;
  final String versionName;
  final String apkUrl;
  final String changelog;
  final bool isMandatory;
  final int minRequired;

  const RemoteVersion({
    required this.versionCode,
    required this.versionName,
    required this.apkUrl,
    required this.changelog,
    required this.isMandatory,
    required this.minRequired,
  });

  factory RemoteVersion.fromMap(Map<String, dynamic> m) => RemoteVersion(
    versionCode: m['version_code'] as int,
    versionName: m['version_name'] as String,
    apkUrl: m['apk_url'] as String,
    changelog: m['changelog'] as String? ?? '',
    isMandatory: m['is_mandatory'] as bool? ?? false,
    minRequired: m['min_required'] as int? ?? 0,
  );
}

/// Resultado del chequeo de actualización.
class UpdateCheckResult {
  final bool hasUpdate;
  final RemoteVersion? remote;
  final String? error;

  const UpdateCheckResult._({required this.hasUpdate, this.remote, this.error});

  factory UpdateCheckResult.update(RemoteVersion v) =>
      UpdateCheckResult._(hasUpdate: true, remote: v);
  factory UpdateCheckResult.upToDate() =>
      const UpdateCheckResult._(hasUpdate: false);
  factory UpdateCheckResult.error(String e) =>
      UpdateCheckResult._(hasUpdate: false, error: e);
}

/// Servicio de auto-actualización in-app.
///
/// Flujo:
/// 1. [checkForUpdate] → Compara versionCode local vs remoto
/// 2. [downloadApk] → Descarga con progreso a directorio cache
/// 3. [installApk] → Lanza el instalador nativo vía MethodChannel
class AppUpdateService {
  AppUpdateService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const _channel = MethodChannel('com.aura_pos/installer');

  /// Obtiene el versionCode local desde pubspec.yaml.
  Future<int> getLocalVersionCode() async {
    final info = await PackageInfo.fromPlatform();
    return int.tryParse(info.buildNumber) ?? 0;
  }

  /// Obtiene el versionName local.
  Future<String> getLocalVersionName() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// Consulta Supabase y compara con la versión local.
  Future<UpdateCheckResult> checkForUpdate() async {
    try {
      final localCode = await getLocalVersionCode();
      debugPrint('[AppUpdate] versionCode local=$localCode');

      final response = await Supabase.instance.client
          .rpc<List<dynamic>>('get_latest_app_version');

      if (response.isEmpty) {
        debugPrint('[AppUpdate] no hay versiones en el servidor');
        return UpdateCheckResult.upToDate();
      }

      final data = response.first as Map<String, dynamic>;
      final remote = RemoteVersion.fromMap(data);

      debugPrint('[AppUpdate] versionCode remoto=${remote.versionCode} '
          'nombre=${remote.versionName} mandatory=${remote.isMandatory}');

      if (remote.versionCode > localCode) {
        return UpdateCheckResult.update(remote);
      }
      return UpdateCheckResult.upToDate();
    } catch (e) {
      debugPrint('[AppUpdate] error al consultar versión: $e');
      return UpdateCheckResult.error(e.toString());
    }
  }

  /// Descarga el APK mostrando progreso.
  /// Devuelve la ruta local del archivo descargado.
  Future<String> downloadApk(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final updatesDir = Directory('${dir.path}/updates');
    if (!updatesDir.existsSync()) {
      updatesDir.createSync(recursive: true);
    }
    final filePath = '${updatesDir.path}/aura_pos_update.apk';

    debugPrint('[AppUpdate] descargando APK desde: $url');

    await _dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0 && onProgress != null) {
          onProgress(received / total);
        }
      },
      options: Options(
        receiveTimeout: const Duration(minutes: 10),
        headers: {'Connection': 'keep-alive'},
      ),
    );

    debugPrint('[AppUpdate] APK descargado en: $filePath');
    return filePath;
  }

  /// Lanza el instalador nativo de Android vía MethodChannel.
  Future<void> installApk(String filePath) async {
    try {
      debugPrint('[AppUpdate] solicitando instalación: $filePath');
      await _channel.invokeMethod('installApk', {'filePath': filePath});
    } on PlatformException catch (e) {
      throw Exception('No se pudo iniciar la instalación: ${e.message}');
    }
  }

  /// Limpia APKs descargados previamente.
  Future<void> clearOldDownloads() async {
    try {
      final dir = await getTemporaryDirectory();
      final updatesDir = Directory('${dir.path}/updates');
      if (updatesDir.existsSync()) {
        await updatesDir.delete(recursive: true);
      }
    } catch (_) {}
  }
}
