import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Helper class untuk mengakses warna tema dengan mudah
class ThemeHelper {
  /// Dapatkan warna background sesuai tema saat ini
  static Color backgroundColor(BuildContext context) {
    return AppColors.background(context);
  }

  /// Dapatkan warna surface sesuai tema saat ini
  static Color surfaceColor(BuildContext context) {
    return AppColors.surface(context);
  }

  /// Dapatkan warna surface yang elevated sesuai tema saat ini
  static Color surfaceElevatedColor(BuildContext context) {
    return AppColors.surfaceElevated(context);
  }

  /// Dapatkan warna teks utama sesuai tema saat ini
  static Color textPrimaryColor(BuildContext context) {
    return AppColors.textPrimary(context);
  }

  /// Dapatkan warna teks muted sesuai tema saat ini
  static Color textMutedColor(BuildContext context) {
    return AppColors.textMuted(context);
  }

  /// Dapatkan warna border sesuai tema saat ini
  static Color borderColor(BuildContext context) {
    return AppColors.border(context);
  }

  /// Dapatkan warna brand (oranye)
  static Color brandColor() {
    return AppColors.brand;
  }

  /// Dapatkan gradient colors sesuai tema saat ini
  static List<Color> gradientColors(BuildContext context) {
    return AppColors.gradient(context);
  }

  /// Cek apakah tema saat ini adalah dark theme
  static bool isDarkTheme(BuildContext context) {
    return AppColors.isDark(context);
  }
}
