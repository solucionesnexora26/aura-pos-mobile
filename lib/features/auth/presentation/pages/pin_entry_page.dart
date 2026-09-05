import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/state_views.dart';
import '../providers/auth_providers.dart';
import '../widgets/pin_pad.dart';

class PinEntryPage extends HookConsumerWidget {
  const PinEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final username = session.user?.username ?? session.user?.email ?? '';

    final ValueNotifier<String> pin = useState<String>('');
    final ValueNotifier<String?> errorMessage = useState<String?>(null);
    final ValueNotifier<int> failedAttempts = useState<int>(0);
    final ValueNotifier<bool> isLocked = useState<bool>(false);
    final ValueNotifier<bool> isLoading = useState<bool>(false);

    void addDigit(String digit) {
      if (pin.value.length < AppConstants.pinLength) {
        pin.value += digit;
        errorMessage.value = null;

        if (pin.value.length == AppConstants.pinLength) {
          _attemptLogin(pin, username, ref, isLoading, failedAttempts, isLocked, errorMessage, context);
        }
      }
    }

    void removeDigit() {
      if (pin.value.isNotEmpty) {
        pin.value = pin.value.substring(0, pin.value.length - 1);
      }
    }

    if (session.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RoutePaths.login);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => ref.read(authSessionProvider.notifier).logout(),
        ),
        title: const Text('Aura POS'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  session.user!.fullName.isNotEmpty
                      ? session.user!.fullName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Hola, ${session.user!.fullName}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Ingresa tu PIN',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AppConstants.pinLength,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < pin.value.length
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (errorMessage.value != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    errorMessage.value!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!isLocked.value)
                PinPad(
                  onDigit: addDigit,
                  onBackspace: removeDigit,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: AppErrorView(
                    message:
                        'Demasiados intentos fallidos. La sesión está bloqueada durante ${AppConstants.pinLockoutDuration.inMinutes} minutos.',
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => ref.read(authSessionProvider.notifier).logout(),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Cambiar de usuario'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _attemptLogin(
    ValueNotifier<String> pin,
    String username,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
    ValueNotifier<int> failedAttempts,
    ValueNotifier<bool> isLocked,
    ValueNotifier<String?> errorMessage,
    BuildContext context,
  ) async {
    if (isLocked.value) return;

    isLoading.value = true;
    await ref.read(authSessionProvider.notifier).loginWithPin(username, pin.value);
    isLoading.value = false;

    final authState = ref.read(authSessionProvider);
    if (authState.isAuthenticated) {
      if (context.mounted) {
        context.go(RoutePaths.dashboard);
      }
    } else {
      failedAttempts.value++;
      pin.value = '';
      final realMessage = authState.errorMessage ?? 'PIN incorrecto';
      errorMessage.value = realMessage.endsWith('.')
          ? '$realMessage Intento ${failedAttempts.value}/${AppConstants.maxPinAttempts}'
          : '$realMessage. Intento ${failedAttempts.value}/${AppConstants.maxPinAttempts}';

      if (failedAttempts.value >= AppConstants.maxPinAttempts) {
        isLocked.value = true;
      }
    }
  }
}
