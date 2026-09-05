import 'package:flutter/material.dart';

import 'app_exit_guard.dart';

/// Contenedor de navegación principal. Pasa el child directamente.
/// Cada página maneja su propio Scaffold, AppBar y Drawer.
class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      AppExitGuard(child: SafeArea(child: child));
}
