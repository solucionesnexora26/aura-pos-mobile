import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Muestra el diálogo de confirmación de salida de la aplicación.
///
/// Se invoca desde el `onExit` de las rutas raíz de GoRouter, que solo se
/// consulta cuando no hay nada más que hacer pop (modales, bottom sheets,
/// drawer y rutas secundarias se cierran antes). Retorna `true` si el
/// usuario confirma salir y `false` en caso contrario.
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.logout),
      title: const Text('¿Salir de ${AppConstants.appName}?'),
      content: const Text('¿Deseas salir de la aplicación?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Salir'),
        ),
      ],
    ),
  );
  return result ?? false;
}
