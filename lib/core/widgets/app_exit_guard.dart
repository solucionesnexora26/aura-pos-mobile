import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../router/route_names.dart';
import 'exit_confirmation_dialog.dart';

/// Guardia de salida para rutas raíz.
///
/// En el Dashboard (ruta raíz del shell), muestra el diálogo de confirmación
/// al presionar Atrás cuando no hay nada que hacer pop.
/// En otras rutas del shell, navega al Dashboard en vez de cerrar la app.
class AppExitGuard extends StatelessWidget {
  const AppExitGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    final bool canPopNormally = (route?.willHandlePopInternally ?? false) ||
        Navigator.of(context).canPop();

    return PopScope(
      canPop: canPopNormally,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        final currentPath = GoRouterState.of(context).matchedLocation;

        // Si estamos en el dashboard, preguntar si desea salir
        if (currentPath == RoutePaths.dashboard) {
          showExitConfirmationDialog(context).then((exit) {
            if (exit == true) {
              SystemNavigator.pop();
            }
          });
        } else {
          // En cualquier otra ruta del shell, ir al dashboard
          context.go(RoutePaths.dashboard);
        }
      },
      child: child,
    );
  }
}
