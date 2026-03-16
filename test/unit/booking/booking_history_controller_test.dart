import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/booking/application/booking_history_controller.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';

import '../../helpers/create_container.dart';
import '../../helpers/test_data.dart';

void main() {
  group('BookingHistoryController', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state loads mock booking history', () {
      final bookings = container.read(bookingHistoryControllerProvider);

      expect(bookings, isNotEmpty);
    });

    test('addBooking appends a new booking to the list', () {
      final initialLength =
          container.read(bookingHistoryControllerProvider).length;

      container
          .read(bookingHistoryControllerProvider.notifier)
          .addBooking(kTestUpcomingBooking);

      final bookings = container.read(bookingHistoryControllerProvider);

      expect(bookings.length, initialLength + 1);
      expect(bookings.last.id, kTestUpcomingBooking.id);
    });

    test('cancelBooking changes booking status to cancelled', () {
      // First, add a known booking
      container
          .read(bookingHistoryControllerProvider.notifier)
          .addBooking(kTestUpcomingBooking);

      // Cancel it
      container
          .read(bookingHistoryControllerProvider.notifier)
          .cancelBooking(kTestUpcomingBooking.id);

      final bookings = container.read(bookingHistoryControllerProvider);
      final cancelled = bookings.firstWhere(
        (b) => b.id == kTestUpcomingBooking.id,
      );

      expect(cancelled.status, BookingStatus.cancelled);
    });

    test('cancelBooking with non-existent ID does not throw', () {
      expect(
        () => container
            .read(bookingHistoryControllerProvider.notifier)
            .cancelBooking('non_existent_id'),
        returnsNormally,
      );
    });

    test('cancelBooking does not affect other bookings', () {
      // Add two bookings
      container
          .read(bookingHistoryControllerProvider.notifier)
          .addBooking(kTestUpcomingBooking);
      container
          .read(bookingHistoryControllerProvider.notifier)
          .addBooking(kTestUpcomingBooking2);

      // Cancel only the first one
      container
          .read(bookingHistoryControllerProvider.notifier)
          .cancelBooking(kTestUpcomingBooking.id);

      final bookings = container.read(bookingHistoryControllerProvider);
      final other = bookings.firstWhere(
        (b) => b.id == kTestUpcomingBooking2.id,
      );

      expect(other.status, BookingStatus.upcoming);
    });

    test('getUpcomingBookings returns only upcoming bookings sorted ascending',
        () {
      // Add bookings with different statuses
      final notifier =
          container.read(bookingHistoryControllerProvider.notifier);
      notifier.addBooking(kTestUpcomingBooking);
      notifier.addBooking(kTestCompletedBooking);
      notifier.addBooking(kTestUpcomingBooking2);

      final upcoming = notifier.getUpcomingBookings();

      // Should only include upcoming bookings
      expect(upcoming.every((b) => b.status == BookingStatus.upcoming), isTrue);

      // Should be sorted ascending by dateTime
      for (int i = 0; i < upcoming.length - 1; i++) {
        expect(
          upcoming[i].dateTime.isBefore(upcoming[i + 1].dateTime) ||
              upcoming[i].dateTime.isAtSameMomentAs(upcoming[i + 1].dateTime),
          isTrue,
          reason: 'Upcoming bookings should be sorted ascending by date',
        );
      }
    });

    test('getPastBookings returns completed and cancelled, sorted descending',
        () {
      final notifier =
          container.read(bookingHistoryControllerProvider.notifier);
      notifier.addBooking(kTestUpcomingBooking);
      notifier.addBooking(kTestCompletedBooking);
      notifier.addBooking(kTestCancelledBooking);

      final past = notifier.getPastBookings();

      // Should only include completed or cancelled
      expect(
        past.every((b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled),
        isTrue,
      );

      // Should be sorted descending by dateTime
      for (int i = 0; i < past.length - 1; i++) {
        expect(
          past[i].dateTime.isAfter(past[i + 1].dateTime) ||
              past[i].dateTime.isAtSameMomentAs(past[i + 1].dateTime),
          isTrue,
          reason: 'Past bookings should be sorted descending by date',
        );
      }
    });
  });
}
