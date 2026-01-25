import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for managing app theme state.
///
/// Supports three theme modes:
/// - [ThemeMode.system] - Follows Android system setting (default)
/// - [ThemeMode.light] - Always light theme
/// - [ThemeMode.dark] - Always dark theme
///
/// Persists user preference to SharedPreferences.
class ThemeController extends GetxController {
  static const String _storageKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Loads saved theme preference from SharedPreferences.
  Future<void> _loadThemeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved != null) {
        themeMode.value = ThemeMode.values.byName(saved);
        Get.changeThemeMode(themeMode.value);
      }
    } catch (_) {
      // If loading fails, keep default (system)
    }
  }

  /// Sets the theme mode and persists to storage.
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, mode.name);
    } catch (_) {
      // If saving fails, theme still changes for current session
    }
  }

  /// Returns localized label for the given theme mode.
  String getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Sistem';
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
    }
  }
}
