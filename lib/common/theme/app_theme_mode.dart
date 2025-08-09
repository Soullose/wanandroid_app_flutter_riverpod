import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/shared_preferences_provider.dart';

class AppThemeMode extends AutoDisposeAsyncNotifier<ThemeMode> {
  late SharedPreferences sharedPreferences;

  @override
  ThemeMode build() {
    ref.keepAlive();
    sharedPreferences = ref.watch(sharedPreferencesProvider);
    _persistenceRefreshThemeMode();

    switch (sharedPreferences.getInt('themeMode')) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.system;
      case 2:
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  Future<void> change(ThemeMode value) async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(value);
  }

  void _persistenceRefreshThemeMode() {
    listenSelf((previous, next) {
      if (next.isLoading) return;
      switch (next.value!) {
        case ThemeMode.light:
          sharedPreferences.setInt('themeMode', 0);
          break;
        case ThemeMode.system:
          sharedPreferences.setInt('themeMode', 1);
          break;
        case ThemeMode.dark:
          sharedPreferences.setInt('themeMode', 2);
          break;
      }
    });
  }
}

//
final themeModeProvider =
    AutoDisposeAsyncNotifierProvider<AppThemeMode, ThemeMode>(
        () => AppThemeMode());
