import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/usecases/recover_pin_usecase.dart';
import '../providers/auth_providers.dart';
import '../widgets/pin_pad.dart';

class PinRecoveryPage extends HookConsumerWidget {
  const PinRecoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameCtrl = useTextEditingController();
    final masterPin = useState('');
    final newPin = useState('');
    final step = useState(1);
    final error = useState<String?>(null);
    final loading = useState(false);

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final String currentPinValue = step.value == 2 ? masterPin.value : newPin.value;

    void addDigit(String d) {
      if (currentPinValue.length >= AppConstants.pinLength) return;
      error.value = null;
      if (step.value == 2) {
        masterPin.value += d;
      } else if (step.value == 3) {
        newPin.value += d;
      }
    }

    void removeDigit() {
      if (step.value == 2 && masterPin.value.isNotEmpty) {
        masterPin.value = masterPin.value.substring(0, masterPin.value.length - 1);
      } else if (step.value == 3 && newPin.value.isNotEmpty) {
        newPin.value = newPin.value.substring(0, newPin.value.length - 1);
      }
    }

    Future<void> submit() async {
      error.value = null;
      if (step.value == 1) {
        if (usernameCtrl.text.trim().isEmpty) {
          error.value = 'El usuario es obligatorio.';
          return;
        }
        step.value = 2;
      } else if (step.value == 2) {
        if (masterPin.value.length != AppConstants.pinLength) {
          error.value = 'El PIN maestro debe tener ${AppConstants.pinLength} dígitos.';
          return;
        }
        step.value = 3;
      } else {
        if (newPin.value.length != AppConstants.pinLength) {
          error.value = 'El nuevo PIN debe tener ${AppConstants.pinLength} dígitos.';
          return;
        }
        loading.value = true;
        final result = await ref.read(recoverPinUseCaseProvider).call(
              RecoverPinParams(
                username: usernameCtrl.text.trim(),
                ownerMasterPin: masterPin.value,
                newPin: newPin.value,
              ),
            );
        loading.value = false;
        result.fold(
          (f) => error.value = f.message,
          (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN recuperado exitosamente.')),
              );
              context.go(RoutePaths.login);
            }
          },
        );
      }
    }

    final titles = ['Recuperar PIN', 'PIN Maestro del Supervisor', 'Nuevo PIN'];
    final subtitles = [
      'Ingresa el usuario cuyo PIN deseas restablecer.',
      'Pide al propietario o administrador que ingrese su PIN para autorizar el cambio.',
      'Establece el nuevo PIN de 6 dígitos.',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          if (step.value == 1) {
            context.go(RoutePaths.login);
          } else {
            step.value--;
            masterPin.value = '';
            newPin.value = '';
            error.value = null;
          }
        }),
        title: Text(titles[step.value - 1]),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitles[step.value - 1],
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),

                if (step.value == 1)
                  TextField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  )
                else ...[
                  // Indicador de PIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(AppConstants.pinLength, (i) {
                      final filled = i < currentPinValue.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled ? scheme.primary : scheme.outlineVariant,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  PinPad(onDigit: addDigit, onBackspace: removeDigit),
                ],

                if (error.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      error.value!,
                      style: text.bodyMedium?.copyWith(color: scheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: loading.value ? null : submit,
                    icon: Icon(step.value == 3 ? Icons.check : Icons.arrow_forward),
                    label: Text(step.value == 3 ? 'Recuperar PIN' : 'Continuar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
