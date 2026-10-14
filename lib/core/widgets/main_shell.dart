import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../update/app_update_provider.dart';
import '../update/app_update_service.dart';
import '../update/update_dialog.dart';
import 'app_exit_guard.dart';

/// Contenedor de navegación principal. Pasa el child directamente.
/// Cada página maneja su propio Scaffold, AppBar y Drawer.
///
/// Also watches [pendingUpdateProvider] to show the update dialog at the
/// right time — after the Navigator tree is fully mounted and stable.
class MainShell extends ConsumerWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for pending updates. When set, show the dialog / feedback.
    final pending = ref.watch(pendingUpdateProvider);
    if (pending != null) {
      // Clear immediately so we don't re-show on rebuild.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePendingResult(context, ref, pending);
      });
    }

    return AppExitGuard(child: SafeArea(child: child));
  }

  void _handlePendingResult(
    BuildContext context,
    WidgetRef ref,
    UpdateCheckResult result,
  ) {
    // Always clear first to avoid re-triggering.
    clearPendingUpdate(ref);

    if (result.hasUpdate && result.remote != null) {
      final remote = result.remote!;
      final isMandatory = remote.isMandatory || remote.minRequired > 0;

      if (isMandatory) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => UpdateDialog(version: remote, mandatory: true),
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (_) => UpdateDialog(version: remote, mandatory: false),
        );
      }
      return;
    }

    // No update available — show feedback snackbar for manual checks.
    if (result.isUpToDate) {
      _showSnackBar(context, 'Tu versión está actualizada', Icons.check_circle, Colors.green.shade700);
    } else if (result.error != null) {
      _showSnackBar(context, result.error!, Icons.error_outline, Colors.red.shade700);
    }
  }

  void _showSnackBar(BuildContext context, String msg, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
