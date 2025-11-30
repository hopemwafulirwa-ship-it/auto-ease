import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An animated button with scale and fade effects
class AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final ButtonType type;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.type = ButtonType.filled,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final button = switch (widget.type) {
      ButtonType.filled => FilledButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: widget.style,
          child: _buildChild(),
        ),
      ButtonType.outlined => OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: widget.style,
          child: _buildChild(),
        ),
      ButtonType.text => TextButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: widget.style,
          child: _buildChild(),
        ),
    };

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: button,
      ),
    );
  }

  Widget _buildChild() {
    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getProgressColor(),
            ),
          ),
          const SizedBox(width: 12),
          widget.child,
        ],
      );
    }
    return widget.child;
  }

  Color? _getProgressColor() {
    return switch (widget.type) {
      ButtonType.filled => Theme.of(context).colorScheme.onPrimary,
      ButtonType.outlined => Theme.of(context).colorScheme.primary,
      ButtonType.text => Theme.of(context).colorScheme.primary,
    };
  }
}

enum ButtonType {
  filled,
  outlined,
  text,
}

/// A gradient button with shimmer effect
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final List<Color>? gradientColors;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradientColors,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = gradientColors ??
        [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
        ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: onPressed == null || isLoading
                  ? colors.map((c) => c.withValues(alpha: 0.5)).toList()
                  : colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            padding: padding,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : DefaultTextStyle(
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
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

/// Icon button with pulse animation
class PulseIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const PulseIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      color: color,
      onPressed: onPressed,
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .scaleXY(
          begin: 1.0,
          end: 1.1,
          duration: 1000.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(
          begin: 1.1,
          end: 1.0,
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }
}
