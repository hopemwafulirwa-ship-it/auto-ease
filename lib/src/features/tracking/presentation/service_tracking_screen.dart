import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class ServiceTrackingScreen extends StatefulWidget {
  const ServiceTrackingScreen({super.key});

  @override
  State<ServiceTrackingScreen> createState() => _ServiceTrackingScreenState();
}

class _ServiceTrackingScreenState extends State<ServiceTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _currentStep = 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Track Service'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Mock Map Area
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 64,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                // Mock Route Path
                Center(
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: _RoutePainter(
                      color: colorScheme.primary,
                      animationValue: _controller.value,
                    ),
                  ),
                ),
                // Mechanic Marker
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          'Mike is arriving',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Status Sheet
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Oil Change & Inspection',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Order #248593',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'In Progress',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildTimelineStep(
                      context,
                      title: 'Booking Confirmed',
                      time: '10:30 AM',
                      isCompleted: _currentStep > 0,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      context,
                      title: 'Mechanic Assigned',
                      time: '10:35 AM',
                      isCompleted: _currentStep > 1,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      context,
                      title: 'Mechanic Arrived',
                      time: '11:00 AM',
                      isCompleted: _currentStep > 2,
                      isActive: _currentStep == 2,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      context,
                      title: 'Service Started',
                      time: 'Estimated 11:05 AM',
                      isCompleted: _currentStep > 3,
                      isActive: _currentStep == 3,
                      isLast: false,
                    ),
                    _buildTimelineStep(
                      context,
                      title: 'Service Completed',
                      time: 'Estimated 12:00 PM',
                      isCompleted: _currentStep > 4,
                      isLast: true,
                    ),
                    const SizedBox(height: 32),
                    if (_currentStep > 0)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            context.push('/review');
                          },
                          icon: const Icon(Icons.star_outline),
                          label: const Text('Rate Service (Demo)'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required String time,
    required bool isCompleted,
    bool isActive = false,
    required bool isLast,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? colorScheme.primary
                      : isActive
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: colorScheme.onPrimary,
                      )
                    : isActive
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? colorScheme.primary.withValues(alpha: 0.5)
                        : colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isCompleted || isActive ? FontWeight.bold : null,
                      color: isCompleted || isActive
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _RoutePainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width * 0.8,
      size.height * 0.2,
    );

    // Draw dashed line
    final dashPath = Path();
    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
