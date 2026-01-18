import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Application theme configuration for Pocket Caklempong.
///
/// Implements the "Royal Minangkabau" theme with:
/// - Dark charcoal backgrounds
/// - Metallic gold accents
/// - High contrast for visibility
abstract class AppTheme {
  AppTheme._();

  /// Main application theme
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.metallicGold,
      onPrimary: AppColors.charcoal,
      secondary: AppColors.maroon,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.charcoal,
      onSurface: AppColors.textPrimary,
      error: AppColors.maroonBright,
      onError: AppColors.textPrimary,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.charcoal,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.charcoal,
      foregroundColor: AppColors.metallicGold,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.metallicGold,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),

    // Text theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.metallicGold,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.metallicGold,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      labelLarge: TextStyle(
        color: AppColors.metallicGold,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: AppColors.metallicGold),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.metallicGold,
        foregroundColor: AppColors.charcoal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
