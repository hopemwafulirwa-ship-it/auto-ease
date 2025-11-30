import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/booking/application/booking_controller.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Services:',
                        style: Theme.of(context).textTheme.titleMedium),
                    ...bookingState.selectedServices.map((s) => Text('• $s')),
                    const Divider(),
                    Text(
                        'Date: ${bookingState.selectedDate?.toString().split(' ')[0]}'),
                    Text('Time: ${bookingState.selectedTimeSlot}'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                // Simulate booking submission
                ref.read(bookingControllerProvider.notifier).reset();
                context.go('/booking/success');
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
