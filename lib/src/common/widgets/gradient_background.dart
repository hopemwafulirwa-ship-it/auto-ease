import 'package:flutter/material.dart';

/// A widget that provides beautiful gradient backgrounds
/// Supports various gradient types and animation options
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final GradientType type;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.type = GradientType.linear,
  });

  /// Subtle gradient background for light theme
  factory GradientBackground.subtle({
    required Widget child,
    required ColorScheme colorScheme,
  }) {
    return GradientBackground(
      colors: [
        colorScheme.surface,
        colorScheme.primaryContainer.withValues(alpha: 0.05),
        colorScheme.secondaryContainer.withValues(alpha: 0.05),
      ],
      child: child,
    );
  }

  /// Primary theme gradient
  factory GradientBackground.primary({
    required Widget child,
    required ColorScheme colorScheme,
  }) {
    return GradientBackground(
      colors: [
        colorScheme.primary.withValues(alpha: 0.1),
        colorScheme.primaryContainer.withValues(alpha: 0.3),
      ],
      child: child,
    );
  }

  /// Accent gradient for special sections
  factory GradientBackground.accent({
    required Widget child,
    required ColorScheme colorScheme,
  }) {
    return GradientBackground(
      colors: [
        colorScheme.secondary.withValues(alpha: 0.1),
        colorScheme.secondaryContainer.withValues(alpha: 0.3),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ??
        [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ];

    return Container(
      decoration: BoxDecoration(
        gradient: _buildGradient(gradientColors),
      ),
      child: child,
    );
  }

  Gradient _buildGradient(List<Color> gradientColors) {
    switch (type) {
      case GradientType.linear:
        return LinearGradient(
          begin: begin,
          end: end,
          colors: gradientColors,
        );
      case GradientType.radial:
        return RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: gradientColors,
        );
      case GradientType.sweep:
        return SweepGradient(
          center: Alignment.center,
          colors: gradientColors,
        );
    }
  }
}

enum GradientType {
  linear,
  radial,
  sweep,
}

/// A container with gradient overlay
class GradientOverlay extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double opacity;

  const GradientOverlay({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.opacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors:
                    colors.map((c) => c.withValues(alpha: opacity)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
