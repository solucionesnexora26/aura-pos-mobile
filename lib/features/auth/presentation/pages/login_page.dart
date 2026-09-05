import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_providers.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final diagLines = useState<List<String>>([]);

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    /// Ejecuta el login y, si el primer intento falla por credenciales, hace un
    /// único reintento automático. Cada intento queda registrado en [diagLines]
    /// (bytes enviados y respuesta del servidor) para diagnóstico en pantalla.
    Future<void> performLogin({
      required String email,
      required String password,
      required bool allowRetry,
    }) async {
      diagLines.value = [
        ...diagLines.value,
        'intento${diagLines.value.length + 1} envio email${email.length}/pwd${password.length}',
      ];

      await ref.read(authSessionProvider.notifier).loginWithEmailPassword(
            email: email,
            password: password,
          );

      if (!context.mounted) return;
      final session = ref.read(authSessionProvider);
      if (session.requiresPinSetup) {
        if (context.mounted) context.go(RoutePaths.setupPin);
        return;
      }
      if (session.isAuthenticated) {
        context.go(RoutePaths.dashboard);
        return;
      }

      final errorInfo = session.errorMessage ?? '(sin detalle)';
      diagLines.value = [...diagLines.value, '  -> $errorInfo'];

      if (allowRetry && session.errorMessage != null) {
        // Esperamos a que el teclado entregue/confirme el último carácter y al
        // asentamiento del primer intento en el servidor.
        await Future<void>.delayed(const Duration(milliseconds: 700));
        if (!context.mounted) return;
        final freshEmail = emailCtrl.text.trim();
        final freshPassword = passwordCtrl.text;
        if (freshEmail.isNotEmpty && freshPassword.isNotEmpty) {
          await performLogin(
            email: freshEmail,
            password: freshPassword,
            allowRetry: false,
          );
          return;
        }
      }

      final baseMessage = session.errorMessage ?? 'Correo o contraseña incorrectos.';
      errorMessage.value = '$baseMessage\n${diagLines.value.join('\n')}';
    }

    Future<void> onLogin() async {
      errorMessage.value = null;
      diagLines.value = [];

      // NO hacer unfocus aquí: en Android, forzar la pérdida de foco mientras
      // el teclado tiene una composición pendiente la CANCELA y borra el
      // último carácter del controlador. Se lee tal cual; si falta el último
      // carácter, el reintento lo recupera tras la confirmación natural.
      final email = emailCtrl.text.trim();
      final password = passwordCtrl.text;

      if (Validators.email(email) != null) {
        errorMessage.value = 'Correo electrónico inválido.';
        return;
      }
      if (password.isEmpty) {
        errorMessage.value = 'La contraseña es obligatoria.';
        return;
      }

      isLoading.value = true;
      await performLogin(email: email, password: password, allowRetry: true);
      isLoading.value = false;
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
                        Icons.point_of_sale_rounded,
                        size: 40,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text('Aura POS', style: text.headlineLarge),
                  ),
                  Center(
                    child: Text(
                      'Punto de Venta',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text('Correo electrónico', style: text.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
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
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onLogin(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      hintText: 'Contraseña',
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
                      onPressed: isLoading.value ? null : onLogin,
                      icon: isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: const Text('Iniciar sesión'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(RoutePaths.register),
                      icon: const Icon(Icons.person_add_outlined),
                      label: const Text('Crear cuenta'),
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
