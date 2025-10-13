import 'package:flutter/material.dart';

/// Constants untuk aplikasi
class AppConstants {
  // Colors
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color connectedGreen = Color(0xFF2E7D32);
  static const Color disconnectedRed = Color(0xFFD32F2F);
  static const Color shadowColor = Color(0x1F000000);
  static const Color greyBackground = Color(0xFFF5F5F5);

  // Sizes
  static const double cloudWidth = 200.0;
  static const double cloudHeight = 140.0;
  static const double toggleWidth = 150.0;
  static const double toggleHeight = 60.0;
  static const double toggleButtonSize = 50.0;
  static const double iconSize = 28.0;
  static const double borderRadius = 16.0;
  static const double toggleBorderRadius = 50.0;
  static const double shadowBlur = 12.0;
  static const double shadowOffset = 6.0;

  // Durations
  static const Duration toggleAnimationDuration = Duration(milliseconds: 250);
  static const Duration textAnimationDuration = Duration(milliseconds: 200);
  static const Duration cloudLoadDelay = Duration(milliseconds: 100);

  // Spacing
  static const double verticalSpacing = 24.0;
  static const double horizontalPadding = 8.0;
  static const double bottomOffset = 20.0;

  // Text
  static const String connectedText = 'Terhubung';
  static const String disconnectedText = 'Tidak Terhubung';
  static const String appTitle = 'Check Internet Connection';
  static const String appName = 'Menampilkan Button Off/On';
}
