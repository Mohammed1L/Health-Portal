import 'package:flutter/material.dart';

class AccessibilityHelper {
  /// Sets semantic label for screen readers
  static Widget withSemanticsLabel(
    Widget child,
    String label, {
    String? hint,
    bool? isButton,
    bool? isHeader,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton ?? false,
      header: isHeader ?? false,
      child: child,
    );
  }

  /// Ensures minimum touch target size (48x48)
  static Widget ensureMinimumSize(Widget child) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      child: child,
    );
  }

  /// Adds semantic hint for better accessibility
  static Widget withHint(Widget child, String hint) {
    return Semantics(
      hint: hint,
      child: child,
    );
  }

  /// Marks widget as a button for screen readers
  static Widget asButton(Widget child, String label) {
    return Semantics(
      button: true,
      label: label,
      child: child,
    );
  }

  /// Marks widget as a header for screen readers
  static Widget asHeader(Widget child, String label) {
    return Semantics(
      header: true,
      label: label,
      child: child,
    );
  }
}

