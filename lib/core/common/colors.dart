import 'package:flutter/material.dart';

// =============================================================================
// LIGHT MODE COLORS
// =============================================================================

const Color neutral10Light = Color(0xffffffff);
const Color neutral20Light = Color(0xfff6f6f6);
const Color neutral30Light = Color(0xffe3e3e3);
const Color neutral40Light = Color(0xffeeeeee);
const Color neutral50Light = Color(0xffc6c6c6);
const Color neutral60Light = Color(0xffa5a5a5);
const Color neutral70Light = Color(0xff7f7f7f);
const Color neutral80Light = Color(0xff6c6c6c);
const Color neutral90Light = Color(0xff4d4d4d);
const Color neutral100Light = Color(0xff1b1b1b);

const Color backgroundCanvasLight = Color(0xFFF6F6F9);
const Color backgroundComponentLight = Color(0xFFFFFFFF);

// =============================================================================
// DARK MODE COLORS
// =============================================================================

const Color neutral10Dark = Color(0xff1b1b1b);
const Color neutral20Dark = Color(0xff252525);
const Color neutral30Dark = Color(0xff333333);
const Color neutral40Dark = Color(0xff404040);
const Color neutral50Dark = Color(0xff525252);
const Color neutral60Dark = Color(0xff6b6b6b);
const Color neutral70Dark = Color(0xff8a8a8a);
const Color neutral80Dark = Color(0xffa3a3a3);
const Color neutral90Dark = Color(0xffc7c7c7);
const Color neutral100Dark = Color(0xffffffff);

const Color backgroundCanvasDark = Color(0xFF121212);
const Color backgroundComponentDark = Color(0xFF1E1E1E);

// =============================================================================
// LEGACY CONSTANTS (for backward compatibility during migration)
// =============================================================================

const Color neutral10 = neutral10Light;
const Color neutral20 = neutral20Light;
const Color neutral30 = neutral30Light;
const Color neutral40 = neutral40Light;
const Color neutral50 = neutral50Light;
const Color neutral60 = neutral60Light;
const Color neutral70 = neutral70Light;
const Color neutral80 = neutral80Light;
const Color neutral90 = neutral90Light;
const Color neutral100 = neutral100Light;

const Color backgroundCanvas = backgroundCanvasLight;
const Color backgroundComponent = backgroundComponentLight;

// =============================================================================
// SEMANTIC COLORS (same for both themes - sufficient contrast)
// =============================================================================

const Color successMain = Color(0xFF43936C);
const Color successSurface = Color(0xFFF7F7F7);
const Color successBorder = Color(0xFFB7DBC9);
const Color successHover = Color(0xFF357A59);
const Color successPressed = Color(0xFF20563C);

const Color dangerMain = Color(0xFFCB3A31);
const Color dangerSurface = Color(0xFFFFF4F2);
const Color dangerBorder = Color(0xFFEEB4B0);
const Color dangerHover = Color(0xFFBC251C);
const Color dangerPressed = Color(0xFF731912);

// Accent Green - Light mode
const Color accentGreenMain = Color(0xFF0B3E3F);
const Color accentGreenSurface = Color(0xFFC3CEB2);
const Color accentGreenBorder = Color(0xFF3E5914);
const Color accentGreenHover = Color(0xFF3E5914);
const Color accentGreenPressed = Color(0xFF25360C);

// Accent Green - Dark mode (lighter variant for visibility)
const Color accentGreenMainDark = Color(0xFF4A9B9C);
const Color accentGreenSurfaceDark = Color(0xFF1E3A2F);
const Color accentGreenBorderDark = Color(0xFF5A7A3A);
const Color accentGreenHoverDark = Color(0xFF5AABAC);
const Color accentGreenPressedDark = Color(0xFF3A8B8C);

const Color accentOrangeMain = Color(0xFFE3892D);
const Color accentOrangeSurface = Color(0xFFF6D8B9);
const Color accentOrangeBorder = Color(0xFFBD7226);
const Color accentOrangeHover = Color(0xFFE89D50);
const Color accentOrangePressed = Color(0xFFCF7D29);

// =============================================================================
// THEME-AWARE COLOR EXTENSION
// =============================================================================

/// Extension for accessing theme-aware colors via BuildContext.
///
/// Usage:
/// ```dart
/// Container(color: context.neutral10)
/// Text('Hello', style: TextStyle(color: context.neutral100))
/// ```
extension ThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Neutral colors
  Color get neutral10 => isDarkMode ? neutral10Dark : neutral10Light;
  Color get neutral20 => isDarkMode ? neutral20Dark : neutral20Light;
  Color get neutral30 => isDarkMode ? neutral30Dark : neutral30Light;
  Color get neutral40 => isDarkMode ? neutral40Dark : neutral40Light;
  Color get neutral50 => isDarkMode ? neutral50Dark : neutral50Light;
  Color get neutral60 => isDarkMode ? neutral60Dark : neutral60Light;
  Color get neutral70 => isDarkMode ? neutral70Dark : neutral70Light;
  Color get neutral80 => isDarkMode ? neutral80Dark : neutral80Light;
  Color get neutral90 => isDarkMode ? neutral90Dark : neutral90Light;
  Color get neutral100 => isDarkMode ? neutral100Dark : neutral100Light;

  // Background colors
  Color get backgroundCanvas =>
      isDarkMode ? backgroundCanvasDark : backgroundCanvasLight;
  Color get backgroundComponent =>
      isDarkMode ? backgroundComponentDark : backgroundComponentLight;

  // Accent green colors (theme-aware)
  Color get accentGreen => isDarkMode ? accentGreenMainDark : accentGreenMain;
  Color get accentGreenSurface_ =>
      isDarkMode ? accentGreenSurfaceDark : accentGreenSurface;
  Color get accentGreenBorder_ =>
      isDarkMode ? accentGreenBorderDark : accentGreenBorder;
  Color get accentGreenHover_ =>
      isDarkMode ? accentGreenHoverDark : accentGreenHover;
  Color get accentGreenPressed_ =>
      isDarkMode ? accentGreenPressedDark : accentGreenPressed;
}
