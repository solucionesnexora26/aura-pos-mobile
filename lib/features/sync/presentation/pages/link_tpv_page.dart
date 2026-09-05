import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/sync/sync_providers.dart';
import '../../../../core/utils/formatters.dart';

/// Pantalla de vinculación del TPV. Permite introducir el código de 6
/// caracteres (o escanearlo) para activar el terminal. Si el dispositivo ya
/// está vinculado, muestra la información de la conexión y permite
/// desvincularlo para re-vincular un TPV nuevo.
class LinkTpvPage extends HookConsumerWidget {
  const LinkTpvPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncControllerProvider);
    final linkedInfoAsync = ref.watch(linkedTpvInfoProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final busy = syncState is SyncLinking ||
        syncState is SyncPulling ||
        syncState is SyncPushing ||
        syncState is SyncUnlinking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular TPV'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.goNamed('settings'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: linkedInfoAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => _NotLinkedView(syncState: syncState, busy: busy),
                data: (info) => info == null
                    ? _NotLinkedView(syncState: syncState, busy: busy)
                    : _LinkedView(
                        info: info,
                        syncState: syncState,
                        busy: busy,
                        scheme: scheme,
                        text: text,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vista para cuando el dispositivo NO está vinculado: formulario de código,
/// escaneo QR y botón de vincular.
class _NotLinkedView extends HookConsumerWidget {
  const _NotLinkedView({required this.syncState, required this.busy});
  final SyncState syncState;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeCtrl = useTextEditingController();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final errorMessage = switch (syncState) {
      SyncActivationFailed(message: final m) => m,
      SyncError(message: final m) => m,
      _ => null,
    };

    void onSubmit() {
      final code = codeCtrl.text.trim();
      if (code.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa el código del TPV')),
        );
        return;
      }
      FocusScope.of(context).unfocus();
      ref.read(syncControllerProvider.notifier).activateAndPull(code);
    }

    void onScan() {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => _ScannerSheet(
          onCode: (code) {
            codeCtrl.text = code;
            Navigator.of(sheetContext).pop();
            onSubmit();
          },
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              size: 40,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Vincular este dispositivo',
          textAlign: TextAlign.center,
          style: text.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Escanea el código QR del TPV en la web o ingresa el '
          'código de 6 caracteres. Hasta activarlo, el terminal '
          'no puede facturar.',
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: codeCtrl,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          maxLength: 6,
          enabled: !busy,
          onSubmitted: (_) => onSubmit(),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.pin_outlined),
            hintText: 'Código (ej. 8E4682)',
            counterText: '',
          ),
          style: const TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        if (busy)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.error),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: busy ? null : onSubmit,
          icon: const Icon(Icons.link),
          label: const Text('Vincular y sincronizar'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: busy ? null : onScan,
          icon: const Icon(Icons.qr_code_scanner_rounded),
          label: const Text('Escanear código QR'),
        ),
      ],
    );
  }
}

/// Vista para cuando el dispositivo YA está vinculado: muestra la info de la
/// conexión y permite sincronizar o desconectar.
class _LinkedView extends ConsumerWidget {
  const _LinkedView({
    required this.info,
    required this.syncState,
    required this.busy,
    required this.scheme,
    required this.text,
  });

  final LinkedTpvInfo info;
  final SyncState syncState;
  final bool busy;
  final ColorScheme scheme;
  final TextTheme text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = switch (syncState) {
      SyncError(message: final m) => m,
      _ => null,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: scheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Conexión establecida',
          textAlign: TextAlign.center,
          style: text.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Este dispositivo está vinculado a un TPV.',
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.storefront,
                  label: 'TPV',
                  value: info.name,
                ),
                if (info.activationCode != null) ...[
                  const Divider(height: 16),
                  _InfoRow(
                    icon: Icons.pin_outlined,
                    label: 'Código de activación',
                    value: info.activationCode!,
                    mono: true,
                  ),
                ],
                if (info.deviceId != null) ...[
                  const Divider(height: 16),
                  _InfoRow(
                    icon: Icons.phone_android,
                    label: 'Dispositivo',
                    value: info.deviceId!,
                  ),
                ],
                if (info.lastSeenAt != null) ...[
                  const Divider(height: 16),
                  _InfoRow(
                    icon: Icons.schedule,
                    label: 'Última conexión',
                    value: AppFormatters.dateTime(info.lastSeenAt!),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (busy)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.error),
            ),
          ),
        FilledButton.icon(
          onPressed: busy
              ? null
              : () async {
                  await ref.read(syncControllerProvider.notifier).syncAll();
                },
          icon: const Icon(Icons.sync),
          label: const Text('Sincronizar'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: busy ? null : () => _confirmUnlink(context, ref),
          icon: const Icon(Icons.link_off, color: Colors.red),
          label: const Text('Desconectar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Future<void> _confirmUnlink(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Desconectar TPV'),
        content: const Text(
          'Se subirán los datos pendientes y se desvinculará el dispositivo. '
          'El TPV quedará pendiente en la web y se generará un nuevo código '
          'de activación. ¿Continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Desconectar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(syncControllerProvider.notifier).unlink();
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(
                value,
                style: mono
                    ? text.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      )
                    : text.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScannerSheet extends HookWidget {
  const _ScannerSheet({required this.onCode});
  final ValueChanged<String> onCode;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(MobileScannerController.new);
    useEffect(() {
      return controller.dispose;
    }, [controller]);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Escanea el código QR del TPV',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) async {
                  final barcode = capture.barcodes.firstOrNull?.rawValue;
                  if (barcode == null) return;
                  await controller.stop();
                  onCode(barcode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
