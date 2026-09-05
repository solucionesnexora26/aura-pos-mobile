import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../router/route_names.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _items = [
    _DrawerItem(path: RoutePaths.dashboard, icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'Panel'),
    _DrawerItem(path: RoutePaths.pos, icon: Icons.point_of_sale_outlined, selectedIcon: Icons.point_of_sale, label: 'Venta'),
    _DrawerItem(path: RoutePaths.products, icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, label: 'Productos'),
    _DrawerItem(path: RoutePaths.customers, icon: Icons.people_outline, selectedIcon: Icons.people, label: 'Clientes'),
    _DrawerItem(path: RoutePaths.cartera, icon: Icons.account_balance_wallet_outlined, selectedIcon: Icons.account_balance_wallet, label: 'Cartera'),
    _DrawerItem(path: RoutePaths.cashRegister, icon: Icons.savings_outlined, selectedIcon: Icons.savings, label: 'Caja'),
    _DrawerItem(path: RoutePaths.receiptsHistory, icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: 'Recibos'),
    _DrawerItem(path: RoutePaths.settings, icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.storefront, size: 40, color: scheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ..._items.map((item) {
              final selected = location.startsWith(item.path);
              return ListTile(
                leading: Icon(
                  selected ? item.selectedIcon : item.icon,
                  color: selected ? scheme.primary : null,
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? scheme.primary : null,
                    fontWeight: selected ? FontWeight.bold : null,
                  ),
                ),
                selected: selected,
                selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(item.path);
                },
              );
            }),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  const _DrawerItem({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
