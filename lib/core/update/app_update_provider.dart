import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_update_service.dart';
import 'app_update_controller.dart';

const _tag = '[AURA-UPDATE]';

/// Holds the pending update result that a widget inside the Navigator tree
/// should display as a dialog.  After the dialog is dismissed, the consumer
/// must call [clearPendingUpdate].
final pendingUpdateProvider = StateProvider<UpdateCheckResult?>((ref) {
  return null;
});

/// The singleton controller used for all silent / periodic checks.
/// It owns the debounce timer and caches the last result.
final appUpdateControllerProvider = Provider<AppUpdateController>((ref) {
  final ctrl = AppUpdateController();
  ref.onDispose(ctrl.dispose);
  return ctrl;
});

/// Performs a silent check.  If an update is found, it is stored in
/// [pendingUpdateProvider] so that a widget inside the Navigator tree can
/// show the dialog.
Future<void> performSilentUpdateCheck(WidgetRef ref) async {
  final ctrl = ref.read(appUpdateControllerProvider);
  print('$_tag [PROVIDER] performSilentUpdateCheck');
  final result = await ctrl.silentCheck();
  print('$_tag [PROVIDER] result: hasUpdate=${result.hasUpdate}');
  if (result.hasUpdate) {
    ref.read(pendingUpdateProvider.notifier).state = result;
  }
}

/// Forced check (bypasses debounce) for manual "check for updates" button.
/// Always stores the result in [pendingUpdateProvider] regardless of outcome
/// so the dialog can show "up to date" or "error" feedback.
Future<void> performForcedUpdateCheck(WidgetRef ref) async {
  final ctrl = ref.read(appUpdateControllerProvider);
  print('$_tag [PROVIDER] performForcedUpdateCheck');
  final result = await ctrl.forceCheck();
  print('$_tag [PROVIDER] forced result: hasUpdate=${result.hasUpdate}');
  // Store always so MainShell shows feedback (update available or snackbar)
  ref.read(pendingUpdateProvider.notifier).state = result;
}

/// Clears the pending update (called after dialog is dismissed).
void clearPendingUpdate(WidgetRef ref) {
  ref.read(pendingUpdateProvider.notifier).state = null;
}
