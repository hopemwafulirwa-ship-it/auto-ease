import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:auto_ease/src/features/booking/application/booking_history_controller.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/utils/animation_extensions.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.watch(bookingHistoryControllerProvider.notifier);
    final upcomingBookings = controller.getUpcomingBookings();
    final pastBookings = controller.getPastBookings();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Upcoming'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Past'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(upcomingBookings, isUpcoming: true),
              _buildBookingsList(pastBookings, isUpcoming: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<BookingHistory> bookings,
      {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming
                    ? Icons.event_available_rounded
                    : Icons.history_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ).scaleBounce(delay: const Duration(milliseconds: 200)),
            const SizedBox(height: 24),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ).fadeInSlideUp(delay: const Duration(milliseconds: 300)),
            const SizedBox(height: 8),
            Text(
              isUpcoming
                  ? 'Book a service to get started'
                  : 'Your booking history will appear here',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ).fadeInSlideUp(delay: const Duration(milliseconds: 400)),
            if (isUpcoming) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Book Now'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ).fadeInSlideUp(delay: const Duration(milliseconds: 500)),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          booking: booking,
          onTap: () {
            context.push('/bookings/${booking.id}', extra: booking);
          },
        ).staggeredListItem(index);
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingHistory booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    final statusConfig = _getStatusConfig(booking.status, colorScheme);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.serviceCenterName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusConfig.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusConfig.color.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusConfig.icon,
                        size: 14,
                        color: statusConfig.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        booking.status.name.toUpperCase(),
                        style: TextStyle(
                          color: statusConfig.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  context,
                  Icons.calendar_today_rounded,
                  dateFormat.format(booking.dateTime),
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  context,
                  Icons.access_time_rounded,
                  timeFormat.format(booking.dateTime),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: booking.services.take(3).map((service) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    service,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (booking.services.length > 3) ...[
              const SizedBox(height: 8),
              Text(
                '+ ${booking.services.length - 3} more services',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$${booking.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
