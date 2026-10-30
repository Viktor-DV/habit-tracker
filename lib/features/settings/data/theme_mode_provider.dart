import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';
import 'package:habit_tracker/features/settings/domain/theme_mode.dart';

const _kThemeMode = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeModeOption> {
  @override
  ThemeModeOption build() {
    final prefs = ref.watch(sharedPreferencesProvider).requireValue;
    final raw = prefs.getString(_kThemeMode) ?? 'system';
    return ThemeModeOption.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ThemeModeOption.light,
    );
  }

  Future<void> set(ThemeModeOption mode) async {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    await prefs.setString(_kThemeMode, mode.name);
    state = mode;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeModeOption>(ThemeModeNotifier.new);

ThemeMode flutterThemeMode(ThemeModeOption mode) => switch (mode) {
      ThemeModeOption.light => ThemeMode.light,
      ThemeModeOption.dark => ThemeMode.dark,
      ThemeModeOption.system => ThemeMode.system,
    };
