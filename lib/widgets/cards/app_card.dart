import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Border? border;
  final bool isOutlined;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.border,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = color ?? theme.cardTheme.color ?? theme.colorScheme.surface;
    final cardBorderRadius = borderRadius ?? 12.0;
    final defaultPadding = padding ?? const EdgeInsets.all(16.0);
    final defaultMargin = margin ?? EdgeInsets.zero;

    Widget cardContent = Container(
      padding: defaultPadding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: isOutlined
            ? (border ??
                Border.all(
                  color: isDark
                      ? const Color(0xFF424242)
                      : const Color(0xFFE0E0E0),
                  width: 1,
                ))
            : null,
        boxShadow: isOutlined
            ? null
            : [
                BoxShadow(
                  color: isDark
                      ? const Color(0x40000000)
                      : const Color(0x1A000000),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: cardContent,
      );
    }

    return Container(
      margin: defaultMargin,
      child: cardContent,
    );
  }
}

