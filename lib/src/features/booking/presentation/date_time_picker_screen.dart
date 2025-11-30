import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/booking/application/booking_controller.dart';

class DateTimePickerScreen extends ConsumerWidget {
  const DateTimePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingControllerProvider);
    final selectedDate = bookingState.selectedDate;
    final selectedTime = bookingState.selectedTimeSlot;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Date & Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Date', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              onDateChanged: (date) {
                ref.read(bookingControllerProvider.notifier).setDate(date);
              },
            ),
            const SizedBox(height: 24),
            Text('Time Slot', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                '09:00 AM',
                '10:00 AM',
                '11:00 AM',
                '02:00 PM',
                '03:00 PM'
              ].map((time) {
                final isSelected = selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(bookingControllerProvider.notifier)
                          .setTimeSlot(time);
                    }
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            FilledButton(
              onPressed: (selectedDate != null && selectedTime != null)
                  ? () {
                      context.push('/booking/confirm');
                    }
                  : null,
              child: const Text('Continue to Confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}
