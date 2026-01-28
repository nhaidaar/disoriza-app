import 'package:flutter/material.dart';

import '../common/colors.dart';

/// App theme definitions for light and dark modes.
class AppTheme {
  AppTheme._();

  /// Light theme configuration.
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: backgroundCanvasLight,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: neutral10Light,
          foregroundColor: neutral100Light,
          surfaceTintColor: neutral10Light,
          elevation: 0,
        ),

        // Cards & Dialogs
        cardColor: neutral10Light,
        dialogTheme: const DialogThemeData(
          backgroundColor: neutral10Light,
        ),

        // Dividers & Borders
        dividerColor: neutral30Light,

        // Bottom Navigation
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: neutral10Light,
          selectedItemColor: accentGreenMain,
          unselectedItemColor: neutral60Light,
        ),

        // Text selection
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: accentGreenMain,
          selectionColor: accentGreenSurface,
        ),

        // Color scheme
        colorScheme: const ColorScheme.light(
          primary: accentGreenMain,
          secondary: accentOrangeMain,
          error: dangerMain,
          surface: neutral10Light,
          onSurface: neutral100Light,
        ),
      );

  /// Dark theme configuration.
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundCanvasDark,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: neutral10Dark,
          foregroundColor: neutral100Dark,
          surfaceTintColor: neutral10Dark,
          elevation: 0,
        ),

        // Cards & Dialogs
        cardColor: neutral10Dark,
        dialogTheme: const DialogThemeData(
          backgroundColor: neutral10Dark,
        ),

        // Dividers & Borders
        dividerColor: neutral30Dark,

        // Bottom Navigation
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: neutral10Dark,
          selectedItemColor: accentGreenMain,
          unselectedItemColor: neutral60Dark,
        ),

        // Text selection
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: accentGreenMain,
          selectionColor: accentGreenSurface,
        ),

        // Color scheme
        colorScheme: const ColorScheme.dark(
          primary: accentGreenMain,
          secondary: accentOrangeMain,
          error: dangerMain,
          surface: neutral10Dark,
          onSurface: neutral100Dark,
        ),
      );
}
