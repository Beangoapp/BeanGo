import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.cream,
    fontFamilyFallback: AppTypography.fontFallback,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.espresso,
      brightness: Brightness.light,
      surface: AppColors.milk,
      error: AppColors.error,
    ),
    textTheme: AppTypography.textTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.milk,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.espresso,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.caramel,
      brightness: Brightness.dark,
      surface: AppColors.espresso,
      error: AppColors.error,
    ),
    fontFamilyFallback: AppTypography.fontFallback,
    textTheme: AppTypography.textTheme.apply(
      bodyColor: AppColors.cream,
      displayColor: AppColors.cream,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.roast,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
    ),
  );
}
