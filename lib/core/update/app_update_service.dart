import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _tag = '[AURA-UPDATE]';

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

  factory RemoteVersion.fromMap(Map<String, dynamic> m) {
    print('$_tag RemoteVersion.fromMap raw=$m');
    return RemoteVersion(
      versionCode: (m['version_code'] as num?)?.toInt() ?? 0,
      versionName: (m['version_name'] ?? '').toString(),
      apkUrl: (m['apk_url'] ?? '').toString(),
      changelog: (m['changelog'] ?? '').toString(),
      isMandatory: m['is_mandatory'] == true,
      minRequired: (m['min_required'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() => 'RemoteVersion(v$versionName, code=$versionCode, '
      'mandatory=$isMandatory, minRequired=$minRequired, apk=$apkUrl)';
}

class UpdateCheckResult {
  final bool hasUpdate;
  final bool isUpToDate;
  final RemoteVersion? remote;
  final String? error;

  const UpdateCheckResult._({
    required this.hasUpdate,
    this.isUpToDate = false,
    this.remote,
    this.error,
  });

  factory UpdateCheckResult.update(RemoteVersion v) =>
      UpdateCheckResult._(hasUpdate: true, remote: v);

  factory UpdateCheckResult.upToDate() =>
      const UpdateCheckResult._(hasUpdate: false, isUpToDate: true);

  factory UpdateCheckResult.noVersions() =>
      const UpdateCheckResult._(hasUpdate: false);

  factory UpdateCheckResult.error(String e) =>
      UpdateCheckResult._(hasUpdate: false, error: e);

  @override
  String toString() => 'UpdateCheckResult(hasUpdate=$hasUpdate, '
      'isUpToDate=$isUpToDate, remote=$remote, error=$error)';
}

class AppUpdateService {
  AppUpdateService({Dio? dio}) : _dio = dio ?? _createDio();

  late final Dio _dio;
  static const _channel = MethodChannel('com.aura_pos/installer');

  static Dio _createDio() {
    final d = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 10),
      headers: {
        'User-Agent': 'AuraPOS/1.0 (Android; Flutter)',
        'Accept': '*/*',
      },
    ));
    d.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (o) => print('$_tag [DIO] $o'),
    ));
    return d;
  }

  Future<int> getLocalVersionCode() async {
    final info = await PackageInfo.fromPlatform();
    final code = int.tryParse(info.buildNumber) ?? 0;
    print('$_tag getLocalVersionCode: buildNumber="${info.buildNumber}" '
        'parsed=$code version="${info.version}" packageName="${info.packageName}"');
    return code;
  }

  Future<String> getLocalVersionName() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<bool> canInstallPackages() async {
    try {
      final result = await _channel.invokeMethod<bool>('canInstallPackages');
      print('$_tag canInstallPackages: $result');
      return result ?? true;
    } catch (e) {
      print('$_tag canInstallPackages ERROR: $e');
      return true;
    }
  }

  Future<void> requestInstallPermission() async {
    try {
      print('$_tag requestInstallPermission: calling native...');
      await _channel.invokeMethod('requestInstallPermission');
      print('$_tag requestInstallPermission: done');
    } catch (e) {
      print('$_tag requestInstallPermission ERROR: $e');
    }
  }

  Future<UpdateCheckResult> checkForUpdate() async {
    print('$_tag ========================================');
    print('$_tag checkForUpdate() START');

    try {
      final localCode = await getLocalVersionCode();
      print('$_tag local versionCode = $localCode');

      print('$_tag Supabase instance exists: ${Supabase.instance.isInitialized}');

      print('$_tag calling .from("app_versions").select()...');
      final response = await Supabase.instance.client
          .from('app_versions')
          .select('version_code, version_name, apk_url, changelog, is_mandatory, min_required')
          .order('version_code', ascending: false)
          .limit(1);

      print('$_tag query response type: ${response.runtimeType}');
      print('$_tag query response: $response');

      if (response == null) {
        print('$_tag response is NULL → noVersions');
        return UpdateCheckResult.noVersions();
      }

      if (response is List && response.isEmpty) {
        print('$_tag response is empty List → noVersions');
        return UpdateCheckResult.noVersions();
      }

      final data = (response is List) ? response.first : response;
      print('$_tag data type: ${data.runtimeType}');
      print('$_tag data value: $data');

      if (data is! Map<String, dynamic>) {
        print('$_tag data is NOT Map<String, dynamic> → noVersions');
        return UpdateCheckResult.noVersions();
      }

      final remote = RemoteVersion.fromMap(data);
      print('$_tag remote parsed: $remote');

      if (remote.apkUrl.isEmpty) {
        print('$_tag apkUrl is EMPTY → noVersions');
        return UpdateCheckResult.noVersions();
      }

      if (remote.minRequired > 0 && localCode < remote.minRequired) {
        print('$_tag FORCED update: local=$localCode < min=${remote.minRequired}');
        return UpdateCheckResult.update(remote);
      }

      if (remote.versionCode > localCode) {
        print('$_tag UPDATE AVAILABLE: remote=${remote.versionCode} > local=$localCode');
        return UpdateCheckResult.update(remote);
      }

      print('$_tag UP TO DATE: remote=${remote.versionCode} <= local=$localCode');
      return UpdateCheckResult.upToDate();
    } on DioException catch (e) {
      final msg = _friendlyError(e);
      print('$_tag DIO ERROR: type=${e.type} statusCode=${e.response?.statusCode} msg=$msg');
      return UpdateCheckResult.error(msg);
    } catch (e, st) {
      print('$_tag UNEXPECTED ERROR: $e');
      print('$_tag STACK: $st');
      return UpdateCheckResult.error(_friendlyErrorMessage(e));
    } finally {
      print('$_tag checkForUpdate() END');
      print('$_tag ========================================');
    }
  }

  Future<String> downloadApk(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    await clearOldDownloads();

    final dir = await getTemporaryDirectory();
    final updatesDir = Directory('${dir.path}/updates');
    if (!updatesDir.existsSync()) {
      updatesDir.createSync(recursive: true);
    }
    final filePath = '${updatesDir.path}/aura_pos_update.apk';

    print('$_tag downloadApk: url=$url');
    print('$_tag downloadApk: saving to $filePath');

    final response = await _dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0 && onProgress != null) {
          onProgress(received / total);
        }
      },
      options: Options(
        receiveTimeout: const Duration(minutes: 10),
        headers: {
          'Connection': 'keep-alive',
          'User-Agent': 'AuraPOS/1.0 (Android; Flutter)',
        },
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    print('$_tag downloadApk: statusCode=${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Error del servidor: ${response.statusCode}');
    }

    final file = File(filePath);
    if (!file.existsSync() || file.lengthSync() < 1024 * 1024) {
      await file.delete();
      throw Exception('Archivo APK inválido o incompleto');
    }

    print('$_tag downloadApk: downloaded ${file.lengthSync()} bytes');
    return filePath;
  }

  Future<bool> installApk(String filePath) async {
    try {
      print('$_tag installApk: $filePath');
      final result = await _channel.invokeMethod<bool>('installApk', {'filePath': filePath});
      print('$_tag installApk result: $result');
      return result ?? true;
    } on PlatformException catch (e) {
      print('$_tag installApk PlatformException: ${e.message}');
      throw Exception('No se pudo iniciar la instalación: ${e.message}');
    }
  }

  Future<void> clearOldDownloads() async {
    try {
      final dir = await getTemporaryDirectory();
      final updatesDir = Directory('${dir.path}/updates');
      if (updatesDir.existsSync()) {
        await updatesDir.delete(recursive: true);
        print('$_tag old downloads cleared');
      }
    } catch (e) {
      print('$_tag clearOldDownloads error: $e');
    }
  }

  String _friendlyError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Sin conexión. Verifica tu red e intenta de nuevo.';
      case DioExceptionType.connectionError:
        return 'Sin conexión a internet.';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 404) return 'El archivo no se encontró. Contacta al administrador.';
        if (code == 403) return 'Acceso denegado al servidor de descarga.';
        if (code != null && code >= 500) return 'Error del servidor. Intenta más tarde.';
        return 'Error de red ($code). Intenta de nuevo.';
      default:
        return 'Error de red. Verifica tu conexión.';
    }
  }

  String _friendlyErrorMessage(Object e) {
    final s = e.toString();
    if (s.contains('SocketException')) return 'Sin conexión a internet.';
    if (s.contains('TimeoutException')) return 'La conexión tardó demasiado.';
    if (s.contains('HandshakeException')) return 'Error de seguridad SSL.';
    return 'Error inesperado. Intenta de nuevo.';
  }
}
