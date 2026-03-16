import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';

//import '../../../helpers/test_data.dart';
import '../../helpers/test_data.dart';

void main() {
  group('BookingHistory', () {
    test('has correct values from constructor', () {
      expect(kTestUpcomingBooking.id, 'test_booking_001');
      expect(kTestUpcomingBooking.serviceCenterName, 'Test Auto Center');
      expect(kTestUpcomingBooking.status, BookingStatus.upcoming);
      expect(kTestUpcomingBooking.totalPrice, 89.99);
      expect(kTestUpcomingBooking.notes, 'Test booking notes');
    });

    test('copyWith preserves all fields when none are specified', () {
      final copy = kTestUpcomingBooking.copyWith();

      expect(copy.id, kTestUpcomingBooking.id);
      expect(copy.serviceCenterId, kTestUpcomingBooking.serviceCenterId);
      expect(copy.serviceCenterName, kTestUpcomingBooking.serviceCenterName);
      expect(copy.services, kTestUpcomingBooking.services);
      expect(copy.dateTime, kTestUpcomingBooking.dateTime);
      expect(copy.status, kTestUpcomingBooking.status);
      expect(copy.totalPrice, kTestUpcomingBooking.totalPrice);
      expect(copy.notes, kTestUpcomingBooking.notes);
    });

    test('copyWith updates only specified fields', () {
      final copy = kTestUpcomingBooking.copyWith(
        status: BookingStatus.cancelled,
        notes: 'Cancelled by test',
      );

      // Changed fields
      expect(copy.status, BookingStatus.cancelled);
      expect(copy.notes, 'Cancelled by test');

      // Unchanged fields
      expect(copy.id, kTestUpcomingBooking.id);
      expect(copy.serviceCenterId, kTestUpcomingBooking.serviceCenterId);
      expect(copy.totalPrice, kTestUpcomingBooking.totalPrice);
    });

    test('copyWith can update all fields', () {
      final newDate = DateTime(2026, 12, 25);
      final copy = kTestUpcomingBooking.copyWith(
        id: 'new_id',
        serviceCenterId: 'new_center',
        serviceCenterName: 'New Center',
        services: ['Engine Repair'],
        dateTime: newDate,
        status: BookingStatus.completed,
        totalPrice: 199.99,
        notes: 'All updated',
      );

      expect(copy.id, 'new_id');
      expect(copy.serviceCenterId, 'new_center');
      expect(copy.serviceCenterName, 'New Center');
      expect(copy.services, ['Engine Repair']);
      expect(copy.dateTime, newDate);
      expect(copy.status, BookingStatus.completed);
      expect(copy.totalPrice, 199.99);
      expect(copy.notes, 'All updated');
    });
  });

  group('BookingStatus', () {
    test('has three values', () {
      expect(BookingStatus.values.length, 3);
    });

    test('contains upcoming, completed, and cancelled', () {
      expect(BookingStatus.values, contains(BookingStatus.upcoming));
      expect(BookingStatus.values, contains(BookingStatus.completed));
      expect(BookingStatus.values, contains(BookingStatus.cancelled));
    });
  });
}
