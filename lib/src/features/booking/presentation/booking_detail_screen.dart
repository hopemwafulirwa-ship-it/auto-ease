import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/features/booking/application/booking_history_controller.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/widgets/animated_button.dart';
import 'package:auto_ease/src/common/utils/animation_extensions.dart';

class BookingDetailScreen extends ConsumerWidget {
  final BookingHistory booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('EEEE, MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    final statusConfig = _getStatusConfig(booking.status, colorScheme);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Booking Details'),
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Status Badge with Hero Animation
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusConfig.color,
                        statusConfig.color.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: statusConfig.color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusConfig.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        booking.status.name.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                )
                    .scaleBounce(duration: const Duration(milliseconds: 600))
                    .shimmer(
                      duration: const Duration(seconds: 2),
                      highlightColor: Colors.white.withValues(alpha: 0.5),
                    ),
              ),

              const SizedBox(height: 24),

              // Service Center Info
              _buildInfoCard(
                context: context,
                icon: Icons.location_on,
                iconColor: colorScheme.primary,
                title: 'Service Center',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceCenterName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Professional Auto Service',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).staggeredListItem(0),

              const SizedBox(height: 16),

              // Date and Time
              _buildInfoCard(
                context: context,
                icon: Icons.calendar_today,
                iconColor: colorScheme.secondary,
                title: 'Date & Time',
                child: Column(
                  children: [
                    _buildInfoRow(
                      context: context,
                      icon: Icons.event,
                      label: dateFormat.format(booking.dateTime),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context: context,
                      icon: Icons.access_time,
                      label: timeFormat.format(booking.dateTime),
                    ),
                  ],
                ),
              ).staggeredListItem(1),

              const SizedBox(height: 16),

              // Services
              _buildInfoCard(
                context: context,
                icon: Icons.build,
                iconColor: colorScheme.tertiary,
                title: 'Services',
                child: Column(
                  children: booking.services.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            entry.key < booking.services.length - 1 ? 12 : 0,
                      ),
                      child: _buildServiceItem(
                        context: context,
                        service: entry.value,
                      ),
                    );
                  }).toList(),
                ),
              ).staggeredListItem(2),

              const SizedBox(height: 16),

              // Notes (if any)
              if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                _buildInfoCard(
                  context: context,
                  icon: Icons.note,
                  iconColor: colorScheme.primary,
                  title: 'Notes',
                  child: Text(
                    booking.notes!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ).staggeredListItem(3),
                const SizedBox(height: 16),
              ],

              // Total Price
              GlassCard(
                padding: const EdgeInsets.all(20),
                elevation: 4,
                backgroundColor:
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderColor: colorScheme.primary.withValues(alpha: 0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${booking.totalPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).staggeredListItem(4),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(context, ref, booking, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildServiceItem({
    required BuildContext context,
    required String service,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    BookingHistory booking,
    ColorScheme colorScheme,
  ) {
    if (booking.status == BookingStatus.upcoming) {
      return Column(
        children: [
          AnimatedButton(
            onPressed: () => _showCancelDialog(context, ref, booking),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              minimumSize: const Size.fromHeight(56),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined),
                SizedBox(width: 8),
                Text('Cancel Booking'),
              ],
            ),
          ).staggeredListItem(5),
          const SizedBox(height: 12),
          AnimatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Reschedule feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            type: ButtonType.outlined,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_calendar_outlined),
                SizedBox(width: 8),
                Text('Reschedule'),
              ],
            ),
          ).staggeredListItem(6),
        ],
      );
    }

    if (booking.status == BookingStatus.completed) {
      return AnimatedButton(
        onPressed: () => context.go('/home'),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.replay),
            SizedBox(width: 8),
            Text('Book Again'),
          ],
        ),
      ).staggeredListItem(5);
    }

    return const SizedBox.shrink();
  }

  void _showCancelDialog(
    BuildContext context,
    WidgetRef ref,
    BookingHistory booking,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 12),
            const Text('Cancel Booking'),
          ],
        ),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No, Keep It'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(bookingHistoryControllerProvider.notifier)
                  .cancelBooking(booking.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Booking cancelled successfully'),
                    ],
                  ),
                  backgroundColor: theme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(
      BookingStatus status, ColorScheme colorScheme) {
    return switch (status) {
      BookingStatus.upcoming => _StatusConfig(
          color: colorScheme.primary,
          icon: Icons.schedule_rounded,
        ),
      BookingStatus.completed => _StatusConfig(
          color: const Color(0xFF4CAF50),
          icon: Icons.check_circle_rounded,
        ),
      BookingStatus.cancelled => _StatusConfig(
          color: colorScheme.error,
          icon: Icons.cancel_rounded,
        ),
    };
  }
}

class _StatusConfig {
  final Color color;
  final IconData icon;

  _StatusConfig({required this.color, required this.icon});
}
