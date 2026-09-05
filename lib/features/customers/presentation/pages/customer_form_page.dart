import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/customer_entity.dart';
import '../providers/customer_providers.dart';

class CustomerFormPage extends HookConsumerWidget {
  const CustomerFormPage({this.customerId, super.key});
  final String? customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsync = ref.watch(customerByIdProvider(customerId));
    if (customerId != null) {
      return customerAsync.when(
        loading: () => const Scaffold(body: AppLoadingView()),
        error: (e, _) => Scaffold(body: AppErrorView(message: e.toString())),
        data: (c) => _CustomerFormBody(customer: c),
      );
    }
    return const _CustomerFormBody(customer: null);
  }
}

class _CustomerFormBody extends HookConsumerWidget {
  const _CustomerFormBody({required this.customer});
  final CustomerEntity? customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameCtrl = useTextEditingController(text: customer?.fullName ?? '');
    final docCtrl = useTextEditingController(text: customer?.documentId ?? '');
    final phoneCtrl = useTextEditingController(text: customer?.phone ?? '');
    final emailCtrl = useTextEditingController(text: customer?.email ?? '');
    final addressCtrl = useTextEditingController(text: customer?.address ?? '');
    final creditLimitCtrl = useTextEditingController(
        text: customer != null ? customer!.creditLimit.toStringAsFixed(0) : '0');
    final type = useState(customer?.type ?? CustomerTypeEntity.occasional);
    final isSaving = useState(false);
    final error = useState<String?>(null);
    final scheme = Theme.of(context).colorScheme;

    Future<void> save() async {
      if (!formKey.currentState!.validate()) return;
      isSaving.value = true;
      error.value = null;

      final entity = CustomerEntity(
        id: customer?.id ?? 'new',
        fullName: nameCtrl.text.trim(),
        documentId: docCtrl.text.trim().isEmpty ? null : docCtrl.text.trim(),
        phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
        email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
        address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
        type: type.value,
        creditLimit: double.tryParse(creditLimitCtrl.text.replaceAll(',', '.')) ?? 0,
        creditBalance: customer?.creditBalance ?? 0,
        isActive: customer?.isActive ?? true,
        createdAt: customer?.createdAt ?? DateTime.now(),
      );

      final result = await ref.read(saveCustomerUseCaseProvider).call(entity);
      isSaving.value = false;
      result.fold(
        (f) => error.value = f.message,
        (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(customer == null ? 'Cliente creado.' : 'Cliente actualizado.'),
            ));
            context.pop();
          }
        },
      );
    }

    Future<void> delete() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Eliminar cliente'),
          content: const Text('¿Estás seguro de eliminar este cliente?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogCtx, false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.pop(dialogCtx, true), child: const Text('Eliminar')),
          ],
        ),
      );
      if (confirm != true || !context.mounted) return;
      final result = await ref.read(deleteCustomerUseCaseProvider).call(customer!.id);
      result.fold(
        (f) => error.value = f.message,
        (_) { if (context.mounted) context.pop(); },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(customer == null ? 'Nuevo Cliente' : 'Editar Cliente'),
        actions: [
          if (customer != null)
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: delete, color: scheme.error),
          if (isSaving.value)
            const Padding(padding: EdgeInsets.all(16), child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)))
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.icon(onPressed: save, icon: const Icon(Icons.check), label: const Text('Guardar')),
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (error.value != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: scheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                  child: Text(error.value!, style: TextStyle(color: scheme.onErrorContainer)),
                ),

              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre completo *', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => Validators.required(v, field: 'El nombre'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: docCtrl,
                decoration: const InputDecoration(labelText: 'Documento / NIT', prefixIcon: Icon(Icons.badge_outlined)),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone_outlined)),
                  validator: Validators.phone,
                )),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo electrónico', prefixIcon: Icon(Icons.email_outlined)),
                  validator: Validators.email,
                )),
              ]),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on_outlined)),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Text('Tipo de cliente', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.primary)),
              const Divider(height: 12),
              SegmentedButton<CustomerTypeEntity>(
                segments: CustomerTypeEntity.values
                    .map((t) => ButtonSegment(value: t, label: Text(t.label)))
                    .toList(),
                selected: {type.value},
                onSelectionChanged: (s) => type.value = s.first,
              ),
              if (type.value == CustomerTypeEntity.credit) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: creditLimitCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Límite de crédito', prefixIcon: Icon(Icons.credit_card_outlined)),
                  validator: (v) => Validators.positiveNumber(v, field: 'El límite de crédito'),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
