import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/providers.dart';
import '../sync/supabase_providers.dart';
import 'backup_service.dart';

/// Servicio de respaldo local de la base de datos (Fase 5).
final Provider<BackupService> backupServiceProvider =
    Provider<BackupService>((ref) {
  return BackupService(
    db: ref.watch(appDatabaseProvider),
    deviceId: ref.watch(deviceIdServiceProvider),
  );
});

/// Lista de respaldos existentes en el almacenamiento local.
/// Se invalida tras crear o eliminar un respaldo para refrescar la UI.
final FutureProvider<List<BackupFileInfo>> backupsListProvider =
    FutureProvider<List<BackupFileInfo>>((ref) async {
  return ref.watch(backupServiceProvider).listBackups();
});
