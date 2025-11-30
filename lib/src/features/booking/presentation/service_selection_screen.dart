import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/booking/application/booking_controller.dart';
import 'package:auto_ease/src/features/home/data/mock_service_centers.dart';

class ServiceSelectionScreen extends ConsumerWidget {
  final String serviceCenterId;

  const ServiceSelectionScreen({super.key, required this.serviceCenterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center =
        kMockServiceCenters.firstWhere((c) => c.id == serviceCenterId);
    final bookingState = ref.watch(bookingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Services')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose services for ${center.name}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: center.services.length,
              itemBuilder: (context, index) {
                final service = center.services[index];
                final isSelected =
                    bookingState.selectedServices.contains(service);
                return CheckboxListTile(
                  title: Text(service),
                  value: isSelected,
                  onChanged: (value) {
                    ref
                        .read(bookingControllerProvider.notifier)
                        .toggleService(service);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton(
              onPressed: bookingState.selectedServices.isEmpty
                  ? null
                  : () {
                      context.push('/booking/datetime');
                    },
              child: const Text('Continue to Date & Time'),
            ),
          ),
        ],
      ),
    );
  }
}
