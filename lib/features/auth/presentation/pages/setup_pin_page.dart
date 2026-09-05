import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../providers/auth_providers.dart';

class SetupPinPage extends HookConsumerWidget {
  const SetupPinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinCtrl = useTextEditingController();
    final confirmPinCtrl = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Future<void> onSave() async {
      errorMessage.value = null;
      final pin = pinCtrl.text.trim();
      final confirmPin = confirmPinCtrl.text.trim();

      if (pin.length != AppConstants.pinLength || !RegExp(r'^\d+$').hasMatch(pin)) {
        errorMessage.value = 'El PIN debe tener exactamente 4 dígitos.';
        return;
      }
      if (pin != confirmPin) {
        errorMessage.value = 'Los PINs no coinciden.';
        return;
      }

      isLoading.value = true;
      await ref.read(authSessionProvider.notifier).setupPin(pin);
      isLoading.value = false;

      if (!context.mounted) return;
      final session = ref.read(authSessionProvider);
      if (session.isAuthenticated) {
        context.go(RoutePaths.dashboard);
      } else {
        errorMessage.value = session.errorMessage ?? 'No se pudo guardar el PIN.';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Icons.pin_outlined,
                        size: 40,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text('Crear PIN', style: text.headlineLarge),
                  ),
                  Center(
                    child: Text(
                      'Configura un PIN de acceso rápido',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('PIN de ${AppConstants.pinLength} dígitos', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: AppConstants.pinLength,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.pin_outlined),
                      hintText: '1234',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Confirmar PIN', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: AppConstants.pinLength,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onSave(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.pin_outlined),
                      hintText: 'Repite el PIN',
                      counterText: '',
                    ),
                  ),
                  if (errorMessage.value != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      errorMessage.value!,
                      style: text.bodyMedium?.copyWith(color: scheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isLoading.value ? null : onSave,
                      icon: isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Guardar PIN'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
