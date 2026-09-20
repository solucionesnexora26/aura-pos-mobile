import 'package:flutter/material.dart';
import 'app_update_service.dart';

class UpdateDialog extends StatefulWidget {
  final RemoteVersion version;
  final bool mandatory;
  final VoidCallback? onDismiss;

  const UpdateDialog({
    super.key,
    required this.version,
    required this.mandatory,
    this.onDismiss,
  });

  static Future<void> showIfNeeded(BuildContext context) async {
    final service = AppUpdateService();
    final result = await service.checkForUpdate();

    if (!result.hasUpdate || result.remote == null) return;
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: !result.remote!.isMandatory,
      builder: (_) => UpdateDialog(
        version: result.remote!,
        mandatory: result.remote!.isMandatory,
        onDismiss: result.remote!.isMandatory ? null : () => Navigator.pop(context),
      ),
    );
  }

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double _progress = 0;
  String _status = 'idle';
  String? _errorMsg;

  Future<void> _startUpdate() async {
    final service = AppUpdateService();
    setState(() {
      _status = 'downloading';
      _progress = 0;
      _errorMsg = null;
    });

    try {
      final filePath = await service.downloadApk(
        widget.version.apkUrl,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );

      if (!mounted) return;
      setState(() => _status = 'installing');

      await service.installApk(filePath);

      if (!mounted) return;
      setState(() => _status = 'done');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'error';
        _errorMsg = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !widget.mandatory,
      child: AlertDialog(
        icon: Icon(
          _status == 'error' ? Icons.error_outline : Icons.system_update,
          size: 48,
          color: _status == 'error' ? scheme.error : scheme.primary,
        ),
        title: Text(
          _status == 'error'
              ? 'Error de actualización'
              : _status == 'done'
                  ? 'Instalación iniciada'
                  : 'Nueva versión disponible',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_status == 'idle') ...[
              Text(
                'Versión ${widget.version.versionName}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.version.changelog.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.version.changelog,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
              if (widget.mandatory) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: scheme.error),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Esta actualización es obligatoria.',
                        style: TextStyle(
                          color: scheme.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
            if (_status == 'downloading') ...[
              const Text('Descargando actualización...'),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                _progress > 0 ? '${(_progress * 100).toInt()}%' : 'Iniciando...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (_status == 'installing') ...[
              const Text('Descarga completa. Iniciando instalador...'),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_status == 'done') ...[
              const Text(
                'El instalador se ha abierto. Sigue las instrucciones en pantalla para completar la actualización.',
              ),
            ],
            if (_status == 'error') ...[
              Text(
                _errorMsg ?? 'Ocurrió un error desconocido.',
                style: TextStyle(color: scheme.error, fontSize: 13),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verifica tu conexión e intenta de nuevo.',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ],
        ),
        actions: [
          if (!widget.mandatory && (_status == 'idle' || _status == 'error'))
            TextButton(
              onPressed: widget.onDismiss,
              child: const Text('Ahora no'),
            ),
          if (_status == 'idle' || _status == 'error')
            FilledButton.icon(
              onPressed: _startUpdate,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Actualizar'),
            ),
          if (_status == 'done')
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          if (_status == 'installing')
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
