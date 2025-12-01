import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/booking/application/booking_controller.dart';
import 'package:auto_ease/src/features/home/data/mock_service_centers.dart';

class ServiceSelectionScreen extends ConsumerWidget {
  final String serviceCenterId;

  const ServiceSelectionScreen({super.key, required this.serviceCenterId});

  double _getServicePrice(String service) {
    // Mock pricing logic
    switch (service.toLowerCase()) {
      case 'oil change':
        return 49.99;
      case 'tire rotation':
        return 29.99;
      case 'brake inspection':
        return 39.99;
      case 'engine tune-up':
        return 149.99;
      case 'car wash':
        return 19.99;
      default:
        return 59.99;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center =
        kMockServiceCenters.firstWhere((c) => c.id == serviceCenterId);
    final bookingState = ref.watch(bookingControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalCost = bookingState.selectedServices.fold<double>(
      0,
      (sum, service) => sum + _getServicePrice(service),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Services'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the services you need for your vehicle.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: center.services.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final service = center.services[index];
                final isSelected =
                    bookingState.selectedServices.contains(service);
                final price = _getServicePrice(service);

                return InkWell(
                  onTap: () {
                    ref
                        .read(bookingControllerProvider.notifier)
                        .toggleService(service);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                          : colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.build_circle_outlined,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Total',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '\$${totalCost.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: bookingState.selectedServices.isEmpty
                        ? null
                        : () {
                            context.push('/booking/datetime');
                          },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continue to Date & Time'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
