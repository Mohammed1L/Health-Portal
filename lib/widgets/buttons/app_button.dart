import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, outline, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Size configurations
    final sizeConfig = _getSizeConfig();
    final buttonWidth = isFullWidth
        ? double.infinity
        : width ?? (isLoading ? sizeConfig['minWidth'] : null);
    final buttonHeight = height ?? sizeConfig['height'];

    // Button style based on type
    Widget button;
    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: textColor ?? theme.colorScheme.onPrimary,
            minimumSize: Size(
              sizeConfig['minWidth'] as double,
              buttonHeight as double,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig['horizontalPadding'] as double,
              vertical: sizeConfig['verticalPadding'] as double,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _buildButtonContent(context, theme),
        );
        break;
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
            foregroundColor: textColor ?? theme.colorScheme.onSecondary,
            minimumSize: Size(
              sizeConfig['minWidth'] as double,
              buttonHeight as double,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig['horizontalPadding'] as double,
              vertical: sizeConfig['verticalPadding'] as double,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _buildButtonContent(context, theme),
        );
        break;
      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            side: BorderSide(
              color: backgroundColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
            minimumSize: Size(
              sizeConfig['minWidth'] as double,
              buttonHeight as double,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig['horizontalPadding'] as double,
              vertical: sizeConfig['verticalPadding'] as double,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _buildButtonContent(context, theme),
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            minimumSize: Size(
              sizeConfig['minWidth'] as double,
              buttonHeight as double,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig['horizontalPadding'] as double,
              vertical: sizeConfig['verticalPadding'] as double,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _buildButtonContent(context, theme),
        );
        break;
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: button,
    );
  }

  Widget _buildButtonContent(BuildContext context, ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: size == AppButtonSize.small ? 16 : 20,
        width: size == AppButtonSize.small ? 16 : 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.outline || type == AppButtonType.text
                ? (textColor ?? theme.colorScheme.primary)
                : (textColor ?? theme.colorScheme.onPrimary),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Map<String, double> _getSizeConfig() {
    switch (size) {
      case AppButtonSize.small:
        return {
          'height': 36.0,
          'minWidth': 80.0,
          'horizontalPadding': 16.0,
          'verticalPadding': 8.0,
        };
      case AppButtonSize.medium:
        return {
          'height': 48.0,
          'minWidth': 120.0,
          'horizontalPadding': 24.0,
          'verticalPadding': 12.0,
        };
      case AppButtonSize.large:
        return {
          'height': 56.0,
          'minWidth': 160.0,
          'horizontalPadding': 32.0,
          'verticalPadding': 16.0,
        };
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14.0;
      case AppButtonSize.medium:
        return 16.0;
      case AppButtonSize.large:
        return 18.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }
}

