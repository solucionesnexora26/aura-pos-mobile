import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Pantalla de arranque: se muestra mientras se restaura la sesión guardada
/// (lectura de SecureStorage + Drift) para evitar el parpadeo de /login.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.point_of_sale_rounded,
                size: 40,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}