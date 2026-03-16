import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/booking/domain/booking_model.dart';

void main() {
  group('Booking', () {
    test('can be instantiated', () {
      final now = DateTime.now();
      final booking = Booking(
        id: '1',
        serviceCenterId: 'sc1',
        userId: 'u1',
        selectedServices: ['Oil Change'],
        date: now,
        timeSlot: '10:00 AM',
        status: 'pending',
        totalPrice: 50.0,
      );

      expect(booking.id, '1');
      expect(booking.serviceCenterId, 'sc1');
      expect(booking.userId, 'u1');
      expect(booking.selectedServices, ['Oil Change']);
      expect(booking.date, now);
      expect(booking.timeSlot, '10:00 AM');
      expect(booking.status, 'pending');
      expect(booking.totalPrice, 50.0);
    });
  });
}
