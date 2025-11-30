import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/home/application/search_controller.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/widgets/animated_button.dart';
import 'package:auto_ease/src/common/utils/animation_extensions.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  static const availableServices = [
    'Oil Change',
    'Tire Service',
    'Brake Repair',
    'Battery Service',
    'Engine Diagnostics',
    'Air Conditioning',
    'Transmission',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final searchState = ref.watch(searchControllerProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerLow,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Glassmorphic overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: colorScheme.surface.withValues(alpha: 0.8),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ).fadeIn(),

                  const SizedBox(height: 20),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.filter_list,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Filters',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ref
                              .read(searchControllerProvider.notifier)
                              .clearFilters();
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Clear All'),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                        ),
                      ),
                    ],
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 50)),

                  const SizedBox(height: 8),

                  Divider(color: colorScheme.outlineVariant)
                      .fadeIn(delay: const Duration(milliseconds: 100)),

                  const SizedBox(height: 20),

                  // Service Types Section
                  Text(
                    'Service Types',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 150)),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableServices.asMap().entries.map((entry) {
                      final service = entry.value;
                      final index = entry.key;
                      final isSelected =
                          searchState.selectedServiceTypes.contains(service);

                      return FilterChip(
                        label: Text(service),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref
                              .read(searchControllerProvider.notifier)
                              .toggleServiceType(service);
                        },
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        selectedColor: colorScheme.primaryContainer,
                        checkmarkColor: colorScheme.onPrimaryContainer,
                        labelStyle: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                      ).fadeInSlideUp(
                        delay: Duration(milliseconds: 200 + (index * 30)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Rating Filter
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Minimum Rating',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    searchState.minRating.toStringAsFixed(1),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: colorScheme.primary,
                            inactiveTrackColor:
                                colorScheme.surfaceContainerHighest,
                            thumbColor: colorScheme.primary,
                            overlayColor:
                                colorScheme.primary.withValues(alpha: 0.12),
                            valueIndicatorColor: colorScheme.primary,
                            valueIndicatorTextStyle: TextStyle(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          child: Slider(
                            value: searchState.minRating,
                            min: 0.0,
                            max: 5.0,
                            divisions: 10,
                            label: searchState.minRating.toStringAsFixed(1),
                            onChanged: (value) {
                              ref
                                  .read(searchControllerProvider.notifier)
                                  .setMinRating(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 400)),

                  const SizedBox(height: 16),

                  // Distance Filter
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Maximum Distance',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${searchState.maxDistance.toStringAsFixed(0)} km',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.near_me,
                                    size: 16,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: colorScheme.secondary,
                            inactiveTrackColor:
                                colorScheme.surfaceContainerHighest,
                            thumbColor: colorScheme.secondary,
                            overlayColor:
                                colorScheme.secondary.withValues(alpha: 0.12),
                            valueIndicatorColor: colorScheme.secondary,
                            valueIndicatorTextStyle: TextStyle(
                              color: colorScheme.onSecondary,
                            ),
                          ),
                          child: Slider(
                            value: searchState.maxDistance,
                            min: 5.0,
                            max: 50.0,
                            divisions: 9,
                            label:
                                '${searchState.maxDistance.toStringAsFixed(0)} km',
                            onChanged: (value) {
                              ref
                                  .read(searchControllerProvider.notifier)
                                  .setMaxDistance(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 500)),

                  const SizedBox(height: 20),

                  // Sort By Section
                  Text(
                    'Sort By',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 600)),

                  const SizedBox(height: 12),

                  SegmentedButton<SortOption>(
                    segments: const [
                      ButtonSegment(
                        value: SortOption.distance,
                        label: Text('Distance'),
                        icon: Icon(Icons.near_me, size: 18),
                      ),
                      ButtonSegment(
                        value: SortOption.rating,
                        label: Text('Rating'),
                        icon: Icon(Icons.star, size: 18),
                      ),
                      ButtonSegment(
                        value: SortOption.name,
                        label: Text('Name'),
                        icon: Icon(Icons.sort_by_alpha, size: 18),
                      ),
                    ],
                    selected: {searchState.sortBy},
                    onSelectionChanged: (Set<SortOption> selection) {
                      ref
                          .read(searchControllerProvider.notifier)
                          .setSortBy(selection.first);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return colorScheme.primaryContainer;
                        }
                        return colorScheme.surfaceContainerHighest;
                      }),
                      foregroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return colorScheme.onPrimaryContainer;
                        }
                        return colorScheme.onSurface;
                      }),
                    ),
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 700)),

                  const SizedBox(height: 28),

                  // Apply Button
                  GradientButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).fadeInSlideUp(delay: const Duration(milliseconds: 800)),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
