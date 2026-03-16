// Smoke test: verifies the app can be instantiated without errors.
// For comprehensive tests, see the test/unit/ directory.

import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/features/home/domain/service_center_model.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

void main() {
  group('Smoke tests', () {
    test('BookingHistory can be instantiated', () {
      final booking = BookingHistory(
        id: 'smoke_1',
        serviceCenterId: 'c1',
        serviceCenterName: 'Test Center',
        services: ['Oil Change'],
        dateTime: DateTime.now(),
        status: BookingStatus.upcoming,
        totalPrice: 50.0,
      );

      expect(booking, isNotNull);
      expect(booking.id, 'smoke_1');
    });

    test('ServiceCenter can be instantiated', () {
      const center = ServiceCenter(
        id: 'sc_1',
        name: 'Test Center',
        address: '123 Test St',
        latitude: 0.0,
        longitude: 0.0,
        rating: 4.5,
        reviewCount: 10,
        distance: 1.0,
        isOpen: true,
        services: ['Oil Change'],
        imageUrl: 'https://example.com/img.jpg',
      );

      expect(center, isNotNull);
      expect(center.name, 'Test Center');
    });

    test('UserProfile can be instantiated with defaults', () {
      const profile = UserProfile(
        id: 'u1',
        name: 'Test User',
        email: 'test@test.com',
        phone: '123',
      );

      expect(profile, isNotNull);
      expect(profile.notificationsEnabled, isTrue);
      expect(profile.darkModeEnabled, isFalse);
    });
  });
}
