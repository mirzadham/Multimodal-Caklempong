import 'package:flutter/material.dart';

/// Responsive design utilities for adapting UI to different screen sizes.
class ResponsiveUtil {
  /// Get responsive font size based on screen width
  static double getResponsiveFontSize(
    BuildContext context, {
    required double smallSize,
    required double mediumSize,
    required double largeSize,
    double smallScreenThreshold = 380,
    double mediumScreenThreshold = 600,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < smallScreenThreshold) {
      return smallSize;
    } else if (screenWidth < mediumScreenThreshold) {
      return mediumSize;
    } else {
      return largeSize;
    }
  }

  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    required double smallPadding,
    required double mediumPadding,
    required double largePadding,
    double smallScreenThreshold = 380,
    double mediumScreenThreshold = 600,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double padding;

    if (screenWidth < smallScreenThreshold) {
      padding = smallPadding;
    } else if (screenWidth < mediumScreenThreshold) {
      padding = mediumPadding;
    } else {
      padding = largePadding;
    }

    return EdgeInsets.all(padding);
  }

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if screen is small (< 380px wide)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 380;
  }

  /// Check if screen is medium (380px - 600px wide)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 380 && width < 600;
  }

  /// Check if screen is large (>= 600px wide)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  /// Get available height accounting for app bar, status bar, and safe area
  static double getAvailableHeight(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom - 
           kToolbarHeight;
  }

  /// Get device pixel ratio for high-DPI displays
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }
}
