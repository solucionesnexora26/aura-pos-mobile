import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/customer_entity.dart';
import '../providers/customer_providers.dart';

class CustomersPage extends HookConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final customersAsync = ref.watch(customersStreamProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    useEffect(() {
      void listener() =>
          ref.read(customerSearchProvider.notifier).state = searchCtrl.text;
      searchCtrl.addListener(listener);
      return () => searchCtrl.removeListener(listener);
    }, []);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Nuevo cliente',
            onPressed: () => context.goNamed(RouteNames.customerForm),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, documento o teléfono…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchCtrl.clear();
                          ref.read(customerSearchProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: customersAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando clientes…'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (customers) {
          if (customers.isEmpty) {
            return AppEmptyView(
              message: 'No hay clientes registrados.',
              icon: Icons.people_outline,
              actionLabel: 'Agregar cliente',
              onAction: () => context.goNamed(RouteNames.customerForm),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: customers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _CustomerTile(customer: customers[i]),
          );
        },
      ),
    );
  }
}

class _CustomerTile extends ConsumerWidget {
  const _CustomerTile({required this.customer});
  final CustomerEntity customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Text(
            customer.fullName[0].toUpperCase(),
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(customer.fullName, style: text.titleSmall),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customer.phone != null)
              Text(customer.phone!, style: text.bodySmall),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    customer.type.label,
                    style: text.labelSmall
                        ?.copyWith(color: scheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => context.goNamed(
            RouteNames.customerForm,
            queryParameters: {'id': customer.id},
          ),
        ),
        onTap: () => context.goNamed(
          RouteNames.customerForm,
          queryParameters: {'id': customer.id},
        ),
      ),
    );
  }
}
