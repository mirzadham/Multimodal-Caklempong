import 'package:flutter/material.dart';

/// Royal Minangkabau color palette for Pocket Caklempong.
///
/// This palette is inspired by traditional Malay aesthetics:
/// - Deep charcoal represents the darkness of "Baju Melayu"
/// - Metallic gold/bronze mimics the physical brass construction of Caklempong pots
/// - Maroon accents represent the royal heritage of Minangkabau culture
abstract class AppColors {
  // Private constructor - this class cannot be instantiated
  AppColors._();

  // ============================================
  // Primary Background Colors
  // ============================================

  /// Deep charcoal background (#1A1A1A)
  /// Used as the main app background to make gongs pop
  static const Color charcoal = Color(0xFF1A1A1A);

  /// Slightly lighter charcoal for elevated surfaces
  static const Color charcoalLight = Color(0xFF2A2A2A);

  /// Pure black for maximum contrast areas
  static const Color black = Color(0xFF000000);

  // ============================================
  // Gong Metallic Colors (Primary)
  // ============================================

  /// Bright metallic gold (#FFD700) - gong highlight
  static const Color metallicGold = Color(0xFFFFD700);

  /// Bronze gold (#B8860B) - gong shadow/depth
  static const Color bronzeGold = Color(0xFFB8860B);

  /// Dark bronze for deep shadows
  static const Color darkBronze = Color(0xFF8B6914);

  /// Light gold for glow effects
  static const Color lightGold = Color(0xFFFFE55C);

  // ============================================
  // Accent Colors
  // ============================================

  /// Maroon (#800000) - active state accent
  static const Color maroon = Color(0xFF800000);

  /// Bright maroon for pressed states
  static const Color maroonBright = Color(0xFFB22222);

  // ============================================
  // Text Colors
  // ============================================

  /// Primary text on dark background
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary/muted text
  static const Color textSecondary = Color(0xFFB0B0B0);

  /// Gold text for emphasis
  static const Color textGold = metallicGold;

  // ============================================
  // Gradient Definitions
  // ============================================

  /// Radial gradient for 3D metallic gong effect
  /// Use from center to create a convex/dome appearance
  static RadialGradient get gongGradient => const RadialGradient(
    center: Alignment(-0.3, -0.3), // Light source from top-left
    radius: 0.8,
    colors: [
      lightGold, // Bright center highlight
      metallicGold, // Main gold
      bronzeGold, // Edge shadow
      darkBronze, // Deep edge
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  /// Active/pressed gong gradient with maroon tint
  static RadialGradient get gongActiveGradient => const RadialGradient(
    center: Alignment(-0.3, -0.3),
    radius: 0.8,
    colors: [
      Color(0xFFFFE082), // Slightly different highlight
      metallicGold,
      Color(0xFFA06000), // Bronze with hint of warmth
      Color(0xFF6B4000),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
}
