import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Common animation presets for consistent animations throughout the app
extension AnimationExtensions on Widget {
  /// Fade in animation
  Widget fadeIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOut,
  }) {
    return animate(delay: delay).fadeIn(duration: duration, curve: curve);
  }

  /// Fade and slide in from bottom
  Widget fadeInSlideUp({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }

  /// Fade and slide in from left
  Widget fadeInSlideLeft({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideX(
          begin: 0.2,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }

  /// Fade and slide in from right
  Widget fadeInSlideRight({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideX(
          begin: -0.2,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }

  /// Scale bounce animation (great for buttons and cards)
  Widget scaleBounce({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return animate(delay: delay)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: duration,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: duration);
  }

  /// Shimmer loading effect
  Widget shimmer({
    Duration duration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: duration,
      color: highlightColor ?? Colors.white.withValues(alpha: 0.3),
    );
  }

  /// Shake animation for error feedback
  Widget shake({
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return animate()
        .shake(
          duration: duration,
          hz: 4,
          curve: Curves.easeInOut,
        )
        .then()
        .fadeOut(duration: 200.ms);
  }

  /// Pulse animation (scale in and out)
  Widget pulse({
    Duration duration = const Duration(milliseconds: 1000),
    double scaleTo = 1.05,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scaleXY(
      begin: 1.0,
      end: scaleTo,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  /// Rotate animation
  Widget rotate({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 800),
    double turns = 1.0,
  }) {
    return animate(delay: delay).rotate(
      begin: 0,
      end: turns,
      duration: duration,
      curve: Curves.easeOut,
    );
  }

  /// Blur fade in (for glassmorphism reveal)
  Widget blurFadeIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return animate(delay: delay)
        .blur(
          begin: const Offset(10, 10),
          end: const Offset(0, 0),
          duration: duration,
        )
        .fadeIn(duration: duration);
  }

  /// Staggered list item animation
  Widget staggeredListItem(int index) {
    return fadeInSlideUp(
      delay: Duration(milliseconds: 50 * index),
      duration: const Duration(milliseconds: 400),
    );
  }
}

/// Success animation builder
class SuccessAnimation extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onComplete;

  const SuccessAnimation({
    super.key,
    this.icon = Icons.check_circle,
    required this.message,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 64,
          color: theme.colorScheme.primary,
        )
            .animate()
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(),
        const SizedBox(height: 16),
        Text(
          message,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ).fadeInSlideUp(delay: 300.ms),
      ],
    );
  }
}

/// Error animation builder
class ErrorAnimation extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorAnimation({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: theme.colorScheme.error,
        ).shake(),
        const SizedBox(height: 16),
        Text(
          message,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ).fadeInSlideUp(delay: 200.ms),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ).fadeInSlideUp(delay: 400.ms),
        ],
      ],
    );
  }
}
