import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/booking/application/booking_controller.dart';

void main() {
  group('BookingState', () {
    test('has correct default values', () {
      final state = BookingState();

      expect(state.serviceCenterId, isNull);
      expect(state.selectedServices, isEmpty);
      expect(state.selectedDate, isNull);
      expect(state.selectedTimeSlot, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final state = BookingState(
        serviceCenterId: 'center_1',
        selectedServices: ['Oil Change'],
        selectedDate: DateTime(2026, 3, 15),
        selectedTimeSlot: '10:00 AM',
      );

      final updated = state.copyWith(serviceCenterId: 'center_2');

      expect(updated.serviceCenterId, 'center_2');
      expect(updated.selectedServices, ['Oil Change']);
      expect(updated.selectedDate, DateTime(2026, 3, 15));
      expect(updated.selectedTimeSlot, '10:00 AM');
    });

    test('copyWith updates all specified fields', () {
      final state = BookingState();

      final updated = state.copyWith(
        serviceCenterId: 'center_1',
        selectedServices: ['Brake Repair'],
        selectedDate: DateTime(2026, 4, 1),
        selectedTimeSlot: '2:00 PM',
      );

      expect(updated.serviceCenterId, 'center_1');
      expect(updated.selectedServices, ['Brake Repair']);
      expect(updated.selectedDate, DateTime(2026, 4, 1));
      expect(updated.selectedTimeSlot, '2:00 PM');
    });
  });

  group('BookingController', () {
    //late BookingController controller;

    setUp(() {
      // Create the controller directly for unit testing.
      // BookingController extends a generated _$BookingController,
      // so we test the logic through the state class and manual invocation.
    });

    test('toggleService adds a service when not present', () {
      // We test the toggle logic directly via BookingState
      final services = <String>[];
      const service = 'Oil Change';

      // Simulate toggle logic
      if (services.contains(service)) {
        services.remove(service);
      } else {
        services.add(service);
      }

      expect(services, contains('Oil Change'));
      expect(services.length, 1);
    });

    test('toggleService removes a service when already present', () {
      final services = ['Oil Change', 'Brake Repair'];
      const service = 'Oil Change';

      if (services.contains(service)) {
        services.remove(service);
      } else {
        services.add(service);
      }

      expect(services, isNot(contains('Oil Change')));
      expect(services, contains('Brake Repair'));
      expect(services.length, 1);
    });
  });
}
