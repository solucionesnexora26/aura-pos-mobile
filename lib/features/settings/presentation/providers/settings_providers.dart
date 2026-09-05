import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/providers.dart';

/// Controla el [ThemeMode] activo (claro / oscuro / sistema) y lo persiste
/// en Hive para que sobreviva entre sesiones.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final Box<dynamic> box = ref.watch(preferencesBoxProvider);
    final String? stored = box.get(PreferenceKeys.themeMode) as String?;
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final Box<dynamic> box = ref.read(preferencesBoxProvider);
    await box.put(PreferenceKeys.themeMode, mode.name);
  }
}

final NotifierProvider<ThemeModeNotifier, ThemeMode> themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
