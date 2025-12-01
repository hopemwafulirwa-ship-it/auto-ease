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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date & Time'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      onDateChanged: (date) {
                        ref
                            .read(bookingControllerProvider.notifier)
                            .setDate(date);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Available Time Slots',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      '09:00 AM',
                      '10:00 AM',
                      '11:00 AM',
                      '02:00 PM',
                      '03:00 PM'
                    ].map((time) {
                      final isSelected = selectedTime == time;
                      return InkWell(
                        onTap: () {
                          ref
                              .read(bookingControllerProvider.notifier)
                              .setTimeSlot(time);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            time,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: FilledButton(
              onPressed: (selectedDate != null && selectedTime != null)
                  ? () {
                      context.push('/booking/confirm');
                    }
                  : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue to Confirmation'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
