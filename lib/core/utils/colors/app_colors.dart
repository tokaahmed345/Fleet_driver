import 'package:flutter/material.dart';

abstract class AppColors {
  // ===== Core neutrals =====
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color whiteColor70 = Colors.white70;

  // ===== Brand colors (Fleet Driver) =====
  static const Color primary = Color(0xFF1ABC9C); // teal — primary actions
  static const Color primaryDark = Color(0xFF13987E);
  static const Color primaryLight = Color(0xFF4FD3B8);
  static const Color secondary = Color(0xFF6B7A99); // muted slate-blue
  static const Color accentBlue = Color(0xFF3D8BFD);

  // ===== Surfaces (dark-first app) =====
  static const Color background = Color(0xFF0B1220);
  static const Color surface = Color(0xFF131B2E);
  static const Color surfaceElevated = Color(0xFF182238);
  static const Color surfaceBorder = Color(0xFF24304A);

  // ===== Text =====
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF8C97AE);
  static const Color textMuted = Color(0xFF5F6A82);

  // ===== Status colors =====
  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0xFF132A1E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFF2E1F0C);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFF2C1416);
  static const Color info = Color(0xFF3D8BFD);

  // Legacy aliases
  static const Color redColor = danger;
  static const Color greenColor = success;
  static const Color greyColor = textSecondary;
  static const Color charcoal = textPrimary;
  static const Color lightBackground = background;
  static const Color darkBackground = background;
  static const Color darkSurface = surface;
}

extension AppColorsExtension on BuildContext {
  Color get backgroundColor => AppColors.background;
  Color get surfaceColor => AppColors.surface;
  Color get surfaceElevatedColor => AppColors.surfaceElevated;
  Color get borderColor => AppColors.surfaceBorder;

  Color get primaryTextColor => AppColors.textPrimary;
  Color get secondaryTextColor => AppColors.textSecondary;
  Color get mutedTextColor => AppColors.textMuted;

  Color get primaryColor => AppColors.primary;
  Color get secondaryColor => AppColors.secondary;
  Color get accentColor => AppColors.accentBlue;

  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get dangerColor => AppColors.danger;
}