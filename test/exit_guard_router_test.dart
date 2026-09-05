import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:aura_pos/core/widgets/main_shell.dart';

void main() {
  GoRouter buildRouter() => GoRouter(
        initialLocation: '/pos',
        routes: [
          ShellRoute(
            builder: (context, state, child) => MainShell(child: child),
            routes: [
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
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('POS'), findsOneWidget);

    router.goNamed('settings');
    await tester.pumpAndSettle();

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('¿Salir de Aura POS?'), findsNothing);
  });

  testWidgets('Back at a root route shows exit dialog instead of closing',
      (WidgetTester tester) async {
    final router = buildRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('¿Salir de Aura POS?'), findsOneWidget);
    expect(find.text('POS'), findsOneWidget);
  });
}
