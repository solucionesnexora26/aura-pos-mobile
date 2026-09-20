import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/update/update_dialog.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final syncState = ref.watch(syncControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final bool syncing = syncState is SyncPushing || syncState is SyncPulling;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Apariencia ────────────────────────────────────────────────────
          _SectionTitle('Apariencia'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Tema'),
                  subtitle: Text(themeMode.name == 'system'
                      ? 'Automático (sistema)'
                      : themeMode.name == 'light'
                          ? 'Claro'
                          : 'Oscuro'),
                  trailing: SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto, size: 16)),
                      ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode, size: 16)),
                      ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode, size: 16)),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (s) =>
                        ref.read(themeModeProvider.notifier).setThemeMode(s.first),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Impresoras ────────────────────────────────────────────────────
          _SectionTitle('Impresión'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.print_outlined),
                  title: const Text('Configurar impresoras'),
                  subtitle: const Text('Bluetooth, USB y Red'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed(RouteNames.printerSettings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Sincronización ────────────────────────────────────────────────
          _SectionTitle('Sincronización'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.sync_alt),
                  title: const Text('Sincronizar ahora'),
                  subtitle: Text(
                    syncing
                        ? 'Sincronizando…'
                        : 'Sube ventas, productos y descarga el catálogo',
                  ),
                  trailing: syncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: syncing
                      ? null
                      : () async {
                          final notifier =
                              ref.read(syncControllerProvider.notifier);
                          await notifier.syncAll();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sincronización completada'),
                              ),
                            );
                          }
                        },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Vincular este TPV'),
                  subtitle: const Text('Activar terminal y descargar catálogo'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.pushNamed(RouteNames.linkTpv),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Cuenta ────────────────────────────────────────────────────────
          _SectionTitle('Cuenta y seguridad'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Cambiar PIN'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed(RouteNames.pinRecovery),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: const Text('Cambiar usuario'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed(RouteNames.switchUser),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Información ───────────────────────────────────────────────────
          _SectionTitle('Información'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Versión'),
                  trailing: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      final v = snap.data?.version ?? '...';
                      final build = snap.data?.buildNumber ?? '';
                      return Text(
                        '$v+$build',
                        style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.system_update),
                  title: const Text('Buscar actualizaciones'),
                  subtitle: const Text('Verificar si hay una nueva versión'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await UpdateDialog.showIfNeeded(context);
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Base de datos'),
                  subtitle: const Text('SQLite local · Offline First'),
                  trailing: const Icon(Icons.check_circle_outline, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
