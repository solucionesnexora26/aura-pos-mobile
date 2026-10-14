import 'package:flutter/material.dart';
import 'app_update_service.dart';

const _tag = '[AURA-UPDATE]';

class UpdateDialog extends StatefulWidget {
  final RemoteVersion version;
  final bool mandatory;

  const UpdateDialog({
    super.key,
    required this.version,
    required this.mandatory,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double _progress = 0;
  String _status = 'idle';
  String? _errorMsg;
  String? _downloadedPath;

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
      _downloadedPath = filePath;

      final hasPermission = await service.canInstallPackages();
      if (!hasPermission) {
        setState(() => _status = 'need_permission');
        return;
      }

      await _doInstall(filePath);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'error';
        _errorMsg = _friendlyError(e);
      });
    }
  }

  Future<void> _doInstall(String filePath) async {
    final service = AppUpdateService();
    setState(() => _status = 'installing');

    try {
      final started = await service.installApk(filePath);
      if (!mounted) return;
      setState(() => _status = started ? 'done' : 'install_failed');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = 'error';
        _errorMsg = _friendlyError(e);
      });
    }
  }

  Future<void> _openInstallSettings() async {
    final service = AppUpdateService();
    await service.requestInstallPermission();
  }

  Future<void> _retryAfterPermission() async {
    if (_downloadedPath == null) return;
    final service = AppUpdateService();
    final hasPermission = await service.canInstallPackages();
    if (!hasPermission) {
      setState(() => _status = 'need_permission');
      return;
    }
    await _doInstall(_downloadedPath!);
  }

  String _friendlyError(Object e) {
    final s = e.toString();
    if (s.contains('SocketException') || s.contains('Sin conexión')) {
      return 'Sin conexión a internet. Verifica tu red.';
    }
    if (s.contains('TimeoutException') || s.contains('tardó')) {
      return 'La conexión tardó demasiado. Intenta de nuevo.';
    }
    if (s.contains('404') || s.contains('no se encontró')) {
      return 'Archivo no disponible. Contacta al administrador.';
    }
    if (s.contains('403') || s.contains('denegado')) {
      return 'Acceso denegado. Contacta al administrador.';
    }
    if (s.contains('inválido') || s.contains('incompleto')) {
      return 'Error en la descarga. Intenta de nuevo.';
    }
    if (s.contains('instalación') || s.contains('install')) {
      return 'No se pudo abrir el instalador.';
    }
    return 'Error al actualizar. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final bool canDismiss =
        !widget.mandatory || _status == 'error' || _status == 'need_permission';

    return PopScope(
      canPop: canDismiss,
      child: AlertDialog(
        icon: Icon(
          _status == 'error'
              ? Icons.error_outline
              : _status == 'need_permission'
                  ? Icons.lock_outline
                  : _status == 'done'
                      ? Icons.check_circle_outline
                      : Icons.system_update,
          size: 56,
          color: _status == 'error'
              ? scheme.error
              : _status == 'need_permission'
                  ? Colors.orange
                  : _status == 'done'
                      ? Colors.green
                      : scheme.primary,
        ),
        title: Text(
          _status == 'error'
              ? 'Error de actualización'
              : _status == 'need_permission'
                  ? 'Permiso requerido'
                  : _status == 'done'
                      ? 'Instalación iniciada'
                      : _status == 'install_failed'
                          ? 'No se pudo instalar'
                          : 'Nueva versión disponible',
          textAlign: TextAlign.center,
        ),
        content: _buildContent(context, scheme, text),
        actions: _buildActions(canDismiss),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme scheme, TextTheme text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_status == 'idle') ...[
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'v${widget.version.versionName}',
                style: text.titleMedium?.copyWith(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (widget.version.changelog.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.version.changelog,
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
          if (widget.mandatory) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 20, color: scheme.onError),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Actualización obligatoria',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onError,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
        if (_status == 'downloading') ...[
          const SizedBox(height: 8),
          Text('Descargando actualización...', style: text.bodyMedium),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress > 0 ? _progress : null,
              minHeight: 10,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _progress > 0 ? '${(_progress * 100).toInt()}%' : 'Iniciando...',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
        if (_status == 'need_permission') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.shield_outlined, size: 40, color: Colors.orange),
                const SizedBox(height: 12),
                Text(
                  'Tu dispositivo requiere permiso para instalar aplicaciones desconocidas.',
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pulsa "Abrir ajustes" y activa el permiso para Aura POS.',
                  textAlign: TextAlign.center,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_status == 'installing') ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Descarga completa.\nIniciando instalador...',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
        if (_status == 'done') ...[
          const SizedBox(height: 8),
          const Center(
            child: Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'El instalador se ha abierto.\nSigue las instrucciones en pantalla.',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
        if (_status == 'install_failed') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'La instalación no se completó.\nEs posible que necesites conceder permiso o abrir el instalador manualmente.',
                    style: text.bodySmall?.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_status == 'error') ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: scheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMsg ?? 'Error desconocido.',
                    style: text.bodySmall?.copyWith(
                      color: scheme.error,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildActions(bool canDismiss) {
    return [
      if (canDismiss && (_status == 'idle' || _status == 'error'))
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ahora no'),
        ),
      if (_status == 'idle' || _status == 'error')
        FilledButton.icon(
          onPressed: _startUpdate,
          icon: Icon(_status == 'error' ? Icons.refresh : Icons.download, size: 18),
          label: Text(_status == 'error' ? 'Reintentar' : 'Actualizar'),
        ),
      if (_status == 'need_permission') ...[
        if (canDismiss)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        FilledButton.icon(
          onPressed: _openInstallSettings,
          icon: const Icon(Icons.settings, size: 18),
          label: const Text('Abrir ajustes'),
        ),
      ],
      if (_status == 'installing')
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      if (_status == 'done')
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendido'),
        ),
      if (_status == 'install_failed')
        FilledButton.icon(
          onPressed: _retryAfterPermission,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Reintentar instalación'),
        ),
    ];
  }
}
