import 'dart:ui';
import 'package:flutter/material.dart';

/// A glassmorphism card widget with frosted glass effect
/// Uses BackdropFilter for blur and semi-transparent background
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurStrength;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;

  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.blurStrength = 10,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBgColor = theme.colorScheme.surface.withValues(alpha: 0.7);
    final defaultBorderColor = theme.colorScheme.outline.withValues(alpha: 0.2);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurStrength,
            sigmaY: blurStrength,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: backgroundColor ?? defaultBgColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: borderColor ?? defaultBorderColor,
                    width: borderWidth,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A lighter variant of GlassCard optimized for content display
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: borderRadius,
      blurStrength: 8,
      padding: padding,
      margin: margin,
      elevation: 2,
      child: child,
    );
  }
}
