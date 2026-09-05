import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aura_pos/app.dart';
import 'package:aura_pos/core/constants/app_constants.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'placeholder-anon-key',
    );
    await initializeDateFormatting('es');
    final tmp = await Directory.systemTemp.createTemp('aura_pos_test');
    Hive.init(tmp.path);
    await Hive.openBox<dynamic>(AppConstants.hiveBoxPreferences);
  });

  testWidgets('App bootstrap smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AuraPosApp()));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
}
