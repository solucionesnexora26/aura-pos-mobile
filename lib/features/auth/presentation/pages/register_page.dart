import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_providers.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullNameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmPasswordCtrl = useTextEditingController();
    final pinCtrl = useTextEditingController();
    final confirmPinCtrl = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Future<void> onRegister() async {
      errorMessage.value = null;

      final fullName = fullNameCtrl.text.trim();
      final email = emailCtrl.text.trim();
      final password = passwordCtrl.text;
      final confirmPassword = confirmPasswordCtrl.text;
      final pin = pinCtrl.text.trim();
      final confirmPin = confirmPinCtrl.text.trim();

      if (fullName.isEmpty) {
        errorMessage.value = 'El nombre es obligatorio.';
        return;
      }
      if (Validators.email(email) != null) {
        errorMessage.value = 'Correo electrónico inválido.';
        return;
      }
      if (password.isEmpty) {
        errorMessage.value = 'La contraseña es obligatoria.';
        return;
      }
      if (password != confirmPassword) {
        errorMessage.value = 'Las contraseñas no coinciden.';
        return;
      }
      if (pin.length != AppConstants.pinLength || !RegExp(r'^\d+$').hasMatch(pin)) {
        errorMessage.value = 'El PIN debe tener exactamente 4 dígitos.';
        return;
      }
      if (pin != confirmPin) {
        errorMessage.value = 'Los PINs no coinciden.';
        return;
      }

      isLoading.value = true;
      await ref.read(authSessionProvider.notifier).registerEmployee(
            fullName: fullName,
            email: email,
            password: password,
            pin: pin,
          );
      isLoading.value = false;

      if (!context.mounted) return;
      final session = ref.read(authSessionProvider);
      if (session.isAuthenticated) {
        context.go(RoutePaths.dashboard);
      } else {
        final message = session.errorMessage ?? 'No se pudo crear la cuenta.';
        final needsConfirmation = message.toLowerCase().contains('correo') &&
            message.toLowerCase().contains('confirma');
        if (needsConfirmation) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.mark_email_read_outlined),
              title: const Text('Confirma tu correo'),
              content: Text(message),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(RoutePaths.login);
                  },
                  child: const Text('Ir al inicio de sesión'),
                ),
              ],
            ),
          );
        } else {
          errorMessage.value = message;
        }
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
                        Icons.person_add_outlined,
                        size: 40,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text('Crear cuenta', style: text.headlineLarge),
                  ),
                  Center(
                    child: Text(
                      'Registra un nuevo empleado',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('Nombre completo', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: fullNameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: 'Nombre del empleado',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Correo electrónico', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'empleado@tienda.com',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Contraseña', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      hintText: 'Contraseña',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Confirmar contraseña', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPasswordCtrl,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: 'Repite la contraseña',
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    onSubmitted: (_) => onRegister(),
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
                      onPressed: isLoading.value ? null : onRegister,
                      icon: isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person_add),
                      label: const Text('Crear cuenta'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => context.go(RoutePaths.login),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver al inicio de sesión'),
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
