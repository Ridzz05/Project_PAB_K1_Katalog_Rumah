import 'package:flutter/material.dart';

class AppColors {
  // Brand Color (Orange)
  static const Color brand = Color(0xFFFF7643);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFAFAFA);
  static const Color lightText = Color(0xFF212121);
  static const Color lightMuted = Color(0xFF757575);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceElevated = Color(0xFF2A2A2A);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkMuted = Color(0xFFBDBDBD);
  static const Color darkBorder = Color(0xFF373737);

  // Gradient Colors
  static const List<Color> darkGradient = [
    Color(0xFF121212),
    Color(0xFF1E1E1E),
    Color(0xFF2A2A2A),
  ];
  static const List<Color> lightGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFFAFAFA),
    Color(0xFFF5F5F5),
  ];

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color background(BuildContext context) {
    return isDark(context) ? darkBackground : lightBackground;
  }

  static Color surface(BuildContext context) {
    return isDark(context) ? darkSurface : lightSurface;
  }

  static Color surfaceElevated(BuildContext context) {
    return isDark(context) ? darkSurfaceElevated : lightSurfaceElevated;
  }

  static Color textPrimary(BuildContext context) {
    return isDark(context) ? darkText : lightText;
  }

  static Color textMuted(BuildContext context) {
    return isDark(context) ? darkMuted : lightMuted;
  }

  static Color border(BuildContext context) {
    return isDark(context) ? darkBorder : lightBorder;
  }

  static List<Color> gradient(BuildContext context) {
    return isDark(context) ? darkGradient : lightGradient;
  }
}
