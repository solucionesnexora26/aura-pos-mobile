import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura_pos/core/widgets/app_exit_guard.dart';

void main() {
  testWidgets('Back at root shows exit dialog and keeps the page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppExitGuard(
          child: Scaffold(body: Center(child: Text('root'))),
        ),
      ),
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('¿Salir de Aura POS?'), findsOneWidget);
    expect(find.text('root'), findsOneWidget);
  });

  testWidgets('Back with drawer open closes the drawer without dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppExitGuard(
          child: Scaffold(
            drawer: Drawer(child: Text('drawer content')),
            body: Center(child: Text('root')),
          ),
        ),
      ),
    );

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
    expect(find.text('drawer content'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('drawer content'), findsNothing);
    expect(find.text('¿Salir de Aura POS?'), findsNothing);
  });

  testWidgets('Back with a nested route pops it without dialog',
      (WidgetTester tester) async {
    final navKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navKey,
        home: const AppExitGuard(
          child: Scaffold(body: Center(child: Text('root'))),
        ),
      ),
    );

    unawaited(navKey.currentState!.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Center(child: Text('nested'))),
      ),
    ),);
    await tester.pumpAndSettle();
    expect(find.text('nested'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('nested'), findsNothing);
    expect(find.text('¿Salir de Aura POS?'), findsNothing);
  });

  testWidgets('Cancelar dismisses the dialog and nothing else happens',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppExitGuard(
          child: Scaffold(body: Center(child: Text('root'))),
        ),
      ),
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('¿Salir de Aura POS?'), findsNothing);
    expect(find.text('root'), findsOneWidget);
  });

  testWidgets('Salir triggers SystemNavigator.pop after confirmation',
      (WidgetTester tester) async {
    final List<MethodCall> calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall call) async {
        calls.add(call);
        return null;
      },
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: AppExitGuard(
          child: Scaffold(body: Center(child: Text('root'))),
        ),
      ),
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salir'));
    await tester.pump();

    expect(
      calls.any((MethodCall call) => call.method == 'SystemNavigator.pop'),
      isTrue,
    );
  });
}
