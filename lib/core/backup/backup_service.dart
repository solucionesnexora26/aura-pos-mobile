import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/app_constants.dart';
import '../database/app_database.dart';
import '../sync/device_id_service.dart';

/// Error controlado durante la generación o restauración de un respaldo.
class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Resultado de un respaldo recién generado.
class BackupResult {
  const BackupResult({
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
    required this.checksum,
    required this.copies,
    required this.rowCount,
    required this.tableCount,
    required this.tables,
  });

  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;
  final String checksum;
  final List<String> copies;
  final int rowCount;
  final int tableCount;
  final Map<String, int> tables;
}

/// Instantánea local de un respaldo existente en disco.
class BackupFileInfo {
  const BackupFileInfo({
    required this.path,
    required this.fileName,
    required this.sizeBytes,
    required this.modifiedAt,
  });

  final String path;
  final String fileName;
  final int sizeBytes;
  final DateTime modifiedAt;
}

/// Metadatos de un respaldo preparado para restaurar en el próximo arranque.
class RestoreStageResult {
  const RestoreStageResult({
    required this.sourceFileName,
    required this.backupCreatedAt,
    required this.version,
    required this.schemaVersion,
  });

  final String sourceFileName;
  final String? backupCreatedAt;
  final String? version;
  final int? schemaVersion;
}

/// Servicio de respaldo local de la base de datos SQLite (Fase 5).
///
/// Genera un archivo ZIP con:
///  - `aura_pos.sqlite` (copia consistente de la base de datos),
///  - `manifest.json` (metadatos + conteo de filas por tabla + checksum).
///
/// También escribe un sidecar `.sha256` con el checksum del ZIP y guarda
/// **dos copias** del respaldo en ubicaciones físicas distintas.
class BackupService {
  BackupService({required AppDatabase db, required DeviceIdService deviceId})
      : _db = db,
        _deviceId = deviceId;

  static const String _formatTag = 'aura-pos-backup';
  static const int _formatVersion = 1;
  static const String _backupFolderName = 'backups';
  static const String _rootFolderName = 'AuraPOS';
  static const String _pendingFolderName = 'restore_pending';

  final AppDatabase _db;
  final DeviceIdService _deviceId;

  /// Carpeta primaria (almacenamiento interno de la app).
  Future<Directory> _primaryDir() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final Directory dir =
        Directory(p.join(docs.path, _rootFolderName, _backupFolderName));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Carpeta secundaria (almacenamiento externo si está disponible).
  /// Devuelve `null` cuando la plataforma no ofrece una ruta distinta.
  Future<Directory?> _secondaryDir() async {
    Directory? base;
    try {
      base = await getExternalStorageDirectory();
    } catch (_) {
      base = null;
    }
    if (base == null) {
      try {
        base = await getDownloadsDirectory();
      } catch (_) {
        base = null;
      }
    }
    if (base == null) return null;
    final Directory dir =
        Directory(p.join(base.path, _rootFolderName, _backupFolderName));
    try {
      if (!await dir.exists()) await dir.create(recursive: true);
    } catch (_) {
      return null;
    }
    return dir;
  }

  /// Genera un respaldo completo y lo guarda en dos ubicaciones.
  Future<BackupResult> createBackup() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final File dbFile = File(p.join(docs.path, AppConstants.dbFileName));
    if (!await dbFile.exists()) {
      throw const BackupException('No se encontró la base de datos local.');
    }

    final Directory tmpRoot = await getTemporaryDirectory();
    final Directory stage = Directory(
      p.join(tmpRoot.path, 'aura_backup_${DateTime.now().millisecondsSinceEpoch}'),
    );
    if (await stage.exists()) await stage.delete(recursive: true);
    await stage.create(recursive: true);

    try {
      final File dbCopy = File(p.join(stage.path, AppConstants.dbFileName));
      final String copyMethod = await _consistentDbCopy(dbFile, dbCopy);

      final Uint8List dbBytes = await dbCopy.readAsBytes();
      final String dbSha = sha256.convert(dbBytes).toString();

      final Map<String, int> tableCounts = await _tableCounts();
      final int totalRows =
          tableCounts.values.fold<int>(0, (int a, int b) => a + b);

      final PackageInfo pkg = await PackageInfo.fromPlatform();
      final DateTime now = DateTime.now();
      final String stamp = _timestamp(now);
      final String fileName = 'aura_backup_$stamp.zip';

      final Map<String, dynamic> manifest = <String, dynamic>{
        'format': _formatTag,
        'formatVersion': _formatVersion,
        'app': AppConstants.appName,
        'appId': pkg.packageName,
        'version': pkg.version,
        'buildNumber': pkg.buildNumber,
        'schemaVersion': _db.schemaVersion,
        'deviceId': await _deviceId.getDeviceId(),
        'tpvId': await _deviceId.getTpvId(),
        'tpvName': await _deviceId.getTpvName(),
        'createdAt': now.toUtc().toIso8601String(),
        'copyMethod': copyMethod,
        'database': <String, dynamic>{
          'file': AppConstants.dbFileName,
          'sizeBytes': dbBytes.length,
          'sha256': dbSha,
        },
        'tables': tableCounts,
        'summary': <String, dynamic>{
          'tableCount': tableCounts.length,
          'rowCount': totalRows,
        },
      };

      final Uint8List manifestBytes = Uint8List.fromList(
        utf8.encode(const JsonEncoder.withIndent('  ').convert(manifest)),
      );

      final Archive archive = Archive()
        ..addFile(
          ArchiveFile(
            AppConstants.dbFileName,
            dbBytes.length,
            dbBytes,
          ),
        )
        ..addFile(
          ArchiveFile(
            'manifest.json',
            manifestBytes.length,
            manifestBytes,
          ),
        );

      final List<int>? encoded = ZipEncoder().encode(archive);
      if (encoded == null) {
        throw const BackupException('No se pudo comprimir el respaldo.');
      }
      final Uint8List zipBytes = Uint8List.fromList(encoded);
      final String zipSha = sha256.convert(zipBytes).toString();
      final String sidecar = '$zipSha  $fileName\n';

      final List<String> copies = <String>[];

      final Directory primary = await _primaryDir();
      final File primaryFile = File(p.join(primary.path, fileName));
      await primaryFile.writeAsBytes(zipBytes, flush: true);
      await File('${primaryFile.path}.sha256').writeAsString(sidecar, flush: true);
      copies.add(primaryFile.path);

      final Directory? secondary = await _secondaryDir();
      if (secondary != null &&
          p.canonicalize(secondary.path) != p.canonicalize(primary.path)) {
        final File secondaryFile = File(p.join(secondary.path, fileName));
        await secondaryFile.writeAsBytes(zipBytes, flush: true);
        await File('${secondaryFile.path}.sha256')
            .writeAsString(sidecar, flush: true);
        copies.add(secondaryFile.path);
      }

      return BackupResult(
        fileName: fileName,
        createdAt: now,
        sizeBytes: zipBytes.length,
        checksum: zipSha,
        copies: copies,
        rowCount: totalRows,
        tableCount: tableCounts.length,
        tables: tableCounts,
      );
    } finally {
      try {
        await stage.delete(recursive: true);
      } catch (_) {}
    }
  }

  /// Lista los respaldos (`.zip`) presentes en la carpeta primaria,
  /// del más reciente al más antiguo.
  Future<List<BackupFileInfo>> listBackups() async {
    final Directory dir = await _primaryDir();
    final List<BackupFileInfo> result = <BackupFileInfo>[];
    await for (final FileSystemEntity entity in dir.list()) {
      if (entity is! File || !entity.path.toLowerCase().endsWith('.zip')) {
        continue;
      }
      final FileStat stat = await entity.stat();
      result.add(
        BackupFileInfo(
          path: entity.path,
          fileName: p.basename(entity.path),
          sizeBytes: stat.size,
          modifiedAt: stat.modified,
        ),
      );
    }
    result.sort(
      (BackupFileInfo a, BackupFileInfo b) =>
          b.modifiedAt.compareTo(a.modifiedAt),
    );
    return result;
  }

  /// Comparte un respaldo mediante la hoja de compartir del sistema.
  Future<void> shareBackup(String path) async {
    final File file = File(path);
    if (!await file.exists()) {
      throw const BackupException('El archivo de respaldo ya no existe.');
    }
    await Share.shareXFiles(
      <XFile>[XFile(path)],
      subject: 'Respaldo ${AppConstants.appName}',
      text: 'Respaldo de la base de datos ${AppConstants.appName}.',
    );
  }

  /// Elimina un respaldo (ZIP + su sidecar `.sha256`).
  Future<void> deleteBackup(String path) async {
    final File file = File(path);
    if (await file.exists()) await file.delete();
    final File sidecar = File('$path.sha256');
    if (await sidecar.exists()) await sidecar.delete();
  }

  /// Prepara la restauración de un respaldo `.zip` seleccionado por el usuario.
  ///
  /// Valida el manifiesto y el checksum SHA-256, comprueba que el contenido sea
  /// una base SQLite y guarda una copia de seguridad del estado actual antes de
  /// dejar el respaldo "en espera". La sustitución del archivo se aplica en el
  /// **próximo arranque** mediante [applyPendingRestoreIfAny], cuando la base de
  /// datos todavía no está abierta, evitando así cualquier corrupción.
  Future<RestoreStageResult> stageRestore(String zipPath) async {
    final File zipFile = File(zipPath);
    if (!await zipFile.exists()) {
      throw const BackupException('El archivo seleccionado no existe.');
    }

    final Uint8List zipBytes = await zipFile.readAsBytes();
    final Archive archive = ZipDecoder().decodeBytes(zipBytes);

    final ArchiveFile? manifestEntry = _findEntry(archive, 'manifest.json');
    if (manifestEntry == null) {
      throw const BackupException(
        'El archivo no es un respaldo válido (falta manifest.json).',
      );
    }

    Map<String, dynamic> manifest;
    try {
      manifest = jsonDecode(utf8.decode(manifestEntry.content as List<int>))
          as Map<String, dynamic>;
    } catch (_) {
      throw const BackupException('El manifiesto del respaldo está dañado.');
    }
    if (manifest['format'] != _formatTag) {
      throw const BackupException(
        'El archivo no es un respaldo de ${AppConstants.appName}.',
      );
    }

    final Map<String, dynamic> dbMeta =
        (manifest['database'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final String dbName =
        (dbMeta['file'] as String?) ?? AppConstants.dbFileName;
    final String? expectedSha = dbMeta['sha256'] as String?;

    final ArchiveFile? dbEntry = _findEntry(archive, dbName);
    if (dbEntry == null) {
      throw const BackupException('El respaldo no contiene la base de datos.');
    }
    final List<int> dbBytes = dbEntry.content as List<int>;
    final String actualSha = sha256.convert(dbBytes).toString();
    if (expectedSha != null && expectedSha != actualSha) {
      throw const BackupException(
        'El checksum no coincide: el respaldo está corrupto o fue alterado.',
      );
    }
    if (!_looksLikeSqlite(dbBytes)) {
      throw const BackupException(
        'El contenido no es una base de datos SQLite válida.',
      );
    }

    // Copia de seguridad del estado actual antes de aplicar la restauración.
    await createBackup();

    final Directory docs = await getApplicationDocumentsDirectory();
    final Directory pendingDir = Directory(
      p.join(docs.path, _rootFolderName, _pendingFolderName),
    );
    if (await pendingDir.exists()) await pendingDir.delete(recursive: true);
    await pendingDir.create(recursive: true);
    await File(p.join(pendingDir.path, AppConstants.dbFileName))
        .writeAsBytes(dbBytes, flush: true);

    final Map<String, dynamic> marker = <String, dynamic>{
      'sourceZip': p.basename(zipPath),
      'stagedAt': DateTime.now().toUtc().toIso8601String(),
      'backupCreatedAt': manifest['createdAt'],
      'version': manifest['version'],
      'schemaVersion': manifest['schemaVersion'],
      'sha256': actualSha,
    };
    await File(p.join(pendingDir.path, 'restore.json'))
        .writeAsString(jsonEncode(marker), flush: true);

    return RestoreStageResult(
      sourceFileName: p.basename(zipPath),
      backupCreatedAt: manifest['createdAt']?.toString(),
      version: manifest['version']?.toString(),
      schemaVersion: manifest['schemaVersion'] is num
          ? (manifest['schemaVersion'] as num).toInt()
          : null,
    );
  }

  /// Aplica, si existe, una restauración pendiente. Debe invocarse en el
  /// arranque de la app **antes** de abrir la base de datos Drift.
  ///
  /// Devuelve `true` si se restauró un respaldo, `null` si no había nada
  /// pendiente y `false` si el intento falló (se conserva la base actual).
  static Future<bool?> applyPendingRestoreIfAny() async {
    try {
      final Directory docs = await getApplicationDocumentsDirectory();
      final Directory pendingDir = Directory(
        p.join(docs.path, _rootFolderName, _pendingFolderName),
      );
      final File staged = File(p.join(pendingDir.path, AppConstants.dbFileName));
      final File marker = File(p.join(pendingDir.path, 'restore.json'));
      if (!await marker.exists() || !await staged.exists()) return null;

      final Uint8List stagedBytes = await staged.readAsBytes();
      if (!_looksLikeSqlite(stagedBytes)) return null;

      final File dbFile = File(p.join(docs.path, AppConstants.dbFileName));
      for (final String suffix in <String>['-wal', '-shm']) {
        final File side = File('${dbFile.path}$suffix');
        if (await side.exists()) await side.delete();
      }
      await staged.copy(dbFile.path);
      await pendingDir.delete(recursive: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  ArchiveFile? _findEntry(Archive archive, String name) {
    for (final ArchiveFile file in archive.files) {
      if (file.name == name || p.basename(file.name) == name) return file;
    }
    return null;
  }

  static bool _looksLikeSqlite(List<int> bytes) {
    const String header = 'SQLite format 3\u0000';
    if (bytes.length < header.length) return false;
    return utf8.decode(bytes.sublist(0, header.length), allowMalformed: true) ==
        header;
  }

  /// Crea una copia consistente de la base de datos.
  ///
  /// Se intenta primero `VACUUM INTO`, que produce una copia íntegra incluso
  /// con la base abierta. Si no está disponible, se hace checkpoint del WAL
  /// y se copia el archivo directamente.
  Future<String> _consistentDbCopy(File source, File dest) async {
    try {
      if (await dest.exists()) await dest.delete();
      await _db.customStatement('VACUUM INTO ?', <Object?>[dest.path]);
      return 'vacuum-into';
    } catch (_) {
      try {
        await _db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
      } catch (_) {}
      await source.copy(dest.path);
      return 'file-copy';
    }
  }

  /// Cuenta las filas de cada tabla de usuario.
  Future<Map<String, int>> _tableCounts() async {
    final Map<String, int> counts = <String, int>{};
    final List<QueryRow> tables = await _db.customSelect(
      'SELECT name FROM sqlite_master '
      "WHERE type = 'table' AND name NOT LIKE 'sqlite_%' "
      'ORDER BY name',
    ).get();
    for (final QueryRow row in tables) {
      final String name = row.read<String>('name');
      final QueryRow countRow = await _db
          .customSelect('SELECT COUNT(*) AS c FROM "$name"')
          .getSingle();
      counts[name] = countRow.read<int>('c');
    }
    return counts;
  }

  String _timestamp(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}${two(d.month)}${two(d.day)}_'
        '${two(d.hour)}${two(d.minute)}${two(d.second)}';
  }
}
