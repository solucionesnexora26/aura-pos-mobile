import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:aura_pos/core/widgets/main_shell.dart';

void main() {
  GoRouter buildRouter() => GoRouter(
        initialLocation: '/dashboard',
        routes: [
          ShellRoute(
            builder: (context, state, child) => MainShell(child: child),
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('DASHBOARD'))),
              ),
              GoRoute(
                path: '/pos',
                name: 'pos',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('POS'))),
              ),
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('SETTINGS'))),
              ),
            ],
          ),
        ],
      );

  testWidgets('Navigating between root routes does not show exit dialog',
      (WidgetTester tester) async {
    final router = buildRouter();
    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));
    await tester.pumpAndSettle();

    expect(find.text('DASHBOARD'), findsOneWidget);

    router.goNamed('settings');
    await tester.pumpAndSettle();

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('¿Salir de Aura POS?'), findsNothing);
  });

  testWidgets('Back at dashboard root route shows exit dialog instead of closing',
      (WidgetTester tester) async {
    final router = buildRouter();
    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('¿Salir de Aura POS?'), findsOneWidget);
    expect(find.text('DASHBOARD'), findsOneWidget);
  });

  testWidgets('Back at non-dashboard shell route navigates to dashboard',
      (WidgetTester tester) async {
    final router = buildRouter();
    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));
    await tester.pumpAndSettle();

    router.goNamed('pos');
    await tester.pumpAndSettle();
    expect(find.text('POS'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('DASHBOARD'), findsOneWidget);
    expect(find.text('¿Salir de Aura POS?'), findsNothing);
  });
}
