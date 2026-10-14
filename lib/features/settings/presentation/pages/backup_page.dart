import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/backup/backup_providers.dart';
import '../../../../core/backup/backup_service.dart';
import '../../../../core/widgets/app_drawer.dart';

/// Pantalla de respaldo de la base de datos (Fase 5).
///
/// Permite generar una copia de seguridad consistente (SQLite + manifiesto
/// con checksum), lista los respaldos existentes y permite compartirlos o
/// eliminarlos. Guarda dos copias en ubicaciones distintas automáticamente.
class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _creating = false;
  bool _restoring = false;
  BackupResult? _last;

  Future<void> _createBackup() async {
    setState(() => _creating = true);
    try {
      final BackupResult result =
          await ref.read(backupServiceProvider).createBackup();
      ref.invalidate(backupsListProvider);
      if (!mounted) return;
      setState(() => _last = result);
      _snack('Respaldo creado (${result.copies.length} copia(s)).');
    } on BackupException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (e) {
      if (mounted) _snack('Error al crear el respaldo: $e', error: true);
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _share(String path) async {
    try {
      await ref.read(backupServiceProvider).shareBackup(path);
    } catch (e) {
      if (mounted) _snack('No se pudo compartir: $e', error: true);
    }
  }

  Future<void> _delete(BackupFileInfo file) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar respaldo'),
        content: Text('¿Eliminar "${file.fileName}"? Esta acción no se puede '
            'deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(backupServiceProvider).deleteBackup(file.path);
    ref.invalidate(backupsListProvider);
    if (mounted) _snack('Respaldo eliminado.');
  }

  Future<void> _restore() async {
    if (_restoring) return;
    final FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['zip'],
    );
    final String? path = picked?.files.single.path;
    if (path == null || !mounted) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restaurar respaldo'),
        content: const Text(
          'Se reemplazará la base de datos actual por la del respaldo '
          'seleccionado al reiniciar la app. Se guardará automáticamente una '
          'copia del estado actual por seguridad. ¿Continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _restoring = true);
    try {
      final RestoreStageResult info =
          await ref.read(backupServiceProvider).stageRestore(path);
      if (!mounted) return;
      await _showRestartDialog(info);
    } on BackupException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (e) {
      if (mounted) _snack('No se pudo preparar la restauración: $e', error: true);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _showRestartDialog(RestoreStageResult info) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Restauración preparada'),
        content: Text(
          'El respaldo del ${info.backupCreatedAt ?? '—'} '
          '(v${info.version ?? '?'}) se aplicará al reiniciar la app. '
          'Se guardó una copia de seguridad del estado actual.\n\n'
          'Cierra la aplicación para completar la restauración.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Más tarde'),
          ),
          FilledButton(
            onPressed: SystemNavigator.pop,
            child: const Text('Cerrar app ahora'),
          ),
        ],
      ),
    );
  }

  void _snack(String message, {bool error = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? scheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final AsyncValue<List<BackupFileInfo>> backups =
        ref.watch(backupsListProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Respaldo de datos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined, color: scheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Copia de seguridad local',
                          style: text.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Genera un archivo ZIP con la base de datos y un '
                    'manifiesto JSON (versión, TPV, checksum SHA-256 y conteo '
                    'de filas). Se guardan dos copias en ubicaciones distintas.',
                    style: text.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _creating ? null : _createBackup,
                      icon: _creating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.backup_outlined),
                      label: Text(
                        _creating
                            ? 'Generando respaldo…'
                            : 'Crear respaldo ahora',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_last != null) ...[
            const SizedBox(height: 16),
            _ResultCard(result: _last!),
          ],
          const SizedBox(height: 24),
          Text('Respaldos en este dispositivo', style: text.titleSmall),
          const SizedBox(height: 8),
          backups.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Card(
              child: ListTile(
                leading: Icon(Icons.error_outline, color: scheme.error),
                title: const Text('No se pudieron cargar los respaldos'),
                subtitle: Text('$e'),
              ),
            ),
            data: (list) {
              if (list.isEmpty) {
                return const Card(
                  child: ListTile(
                    leading: Icon(Icons.inbox_outlined),
                    title: Text('Aún no hay respaldos'),
                    subtitle: Text('Crea el primero con el botón de arriba.'),
                  ),
                );
              }
              return Card(
                child: Column(
                  children: [
                    for (int i = 0; i < list.length; i++) ...[
                      if (i > 0) const Divider(height: 1, indent: 56),
                      _BackupTile(
                        file: list[i],
                        onShare: () => _share(list[i].path),
                        onDelete: () => _delete(list[i]),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restore, color: scheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Restaurar respaldo', style: text.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona un archivo .zip de respaldo para restaurarlo. '
                    'Por seguridad se guarda una copia del estado actual y el '
                    'reemplazo se aplica al reiniciar la app.',
                    style: text.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: _restoring ? null : _restore,
                      icon: _restoring
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_file_outlined),
                      label: Text(
                        _restoring
                            ? 'Preparando restauración…'
                            : 'Seleccionar respaldo (.zip)',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final BackupResult result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Respaldo completado', style: text.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _kv(context, 'Archivo', result.fileName),
            _kv(context, 'Tamaño', _formatBytes(result.sizeBytes)),
            _kv(context, 'Filas', '${result.rowCount} en ${result.tableCount} tablas'),
            _kv(context, 'Copias', '${result.copies.length}'),
            const SizedBox(height: 8),
            Text('SHA-256', style: text.labelMedium),
            SelectableText(
              result.checksum,
              style: text.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(BuildContext context, String key, String value) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              key,
              style: text.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({
    required this.file,
    required this.onShare,
    required this.onDelete,
  });

  final BackupFileInfo file;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd HH:mm');
    return ListTile(
      leading: const Icon(Icons.archive_outlined),
      title: Text(file.fileName),
      subtitle: Text(
        '${_formatBytes(file.sizeBytes)} · ${df.format(file.modifiedAt)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Compartir',
            onPressed: onShare,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const List<String> units = <String>['KB', 'MB', 'GB'];
  double value = bytes / 1024;
  int i = 0;
  while (value >= 1024 && i < units.length - 1) {
    value /= 1024;
    i++;
  }
  return '${value.toStringAsFixed(1)} ${units[i]}';
}
