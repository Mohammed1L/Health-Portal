import 'package:flutter/material.dart';

/// Helper class for theme-related utilities
class ThemeHelper {
  /// Get the appropriate border color based on theme
  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF424242)
        : const Color(0xFFE0E0E0);
  }

  /// Get the appropriate card color based on theme
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Get the appropriate text color based on theme
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Get the appropriate secondary text color based on theme
  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF757575);
  }
}

