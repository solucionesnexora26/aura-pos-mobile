import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/cash_register_providers.dart';

class CashRegisterOpenPage extends HookConsumerWidget {
  const CashRegisterOpenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountCtrl = useTextEditingController(text: '0');
    final shiftCtrl = useTextEditingController();
    final isLoading = useState(false);
    final error = useState<String?>(null);
    final scheme = Theme.of(context).colorScheme;

    Future<void> open() async {
      final amount = double.tryParse(amountCtrl.text.replaceAll(',', '.')) ?? 0;
      if (amount < 0) { error.value = 'El monto inicial no puede ser negativo.'; return; }
      isLoading.value = true;
      error.value = null;
      final session = ref.read(authSessionProvider);
      if (session.user == null || session.user!.id.isEmpty) {
        isLoading.value = false;
        error.value = 'Debes tener una sesión activa para abrir caja.';
        return;
      }
      final result = await ref.read(cashRegisterRepositoryProvider).openRegister(
        userId: session.user!.id,
        openingAmount: amount,
        shiftLabel: shiftCtrl.text.trim().isEmpty ? null : shiftCtrl.text.trim(),
      );
      isLoading.value = false;
      result.fold(
        (f) => error.value = f.message,
        (_) {
          ref.invalidate(openCashRegisterProvider);
          ref.invalidate(cashRegisterHistoryProvider);
          if (context.mounted) context.goNamed(RouteNames.cashRegister);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Abrir Caja')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.lock_open_outlined, size: 56, color: scheme.primary),
                const SizedBox(height: 16),
                Text('Apertura de Caja', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 32),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monto inicial en caja', prefixIcon: Icon(Icons.attach_money)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: shiftCtrl,
                  decoration: const InputDecoration(labelText: 'Etiqueta de turno (opcional)', prefixIcon: Icon(Icons.label_outline)),
                ),
                if (error.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(error.value!, style: TextStyle(color: scheme.error)),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isLoading.value ? null : open,
                    icon: isLoading.value
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.lock_open_outlined),
                    label: const Text('Abrir Caja'),
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
