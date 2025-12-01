import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/home/data/mock_service_centers.dart';
import 'package:auto_ease/src/features/home/presentation/map_view_widget.dart';
import 'package:auto_ease/src/features/home/presentation/service_center_card.dart';
import 'package:auto_ease/src/features/home/presentation/filter_bottom_sheet.dart';
import 'package:auto_ease/src/features/home/application/search_controller.dart';
import 'package:go_router/go_router.dart';

class ServiceFinderScreen extends ConsumerStatefulWidget {
  const ServiceFinderScreen({super.key});

  @override
  ConsumerState<ServiceFinderScreen> createState() =>
      _ServiceFinderScreenState();
}

class _ServiceFinderScreenState extends ConsumerState<ServiceFinderScreen> {
  bool _isMapView = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final filteredCenters = ref
        .read(searchControllerProvider.notifier)
        .filterAndSortCenters(kMockServiceCenters);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search service centers...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchControllerProvider.notifier).setQuery('');
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            ref.read(searchControllerProvider.notifier).setQuery(value);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const FilterBottomSheet(),
                  );
                },
              ),
              if (searchState.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: filteredCenters.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No service centers found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      ref
                          .read(searchControllerProvider.notifier)
                          .clearFilters();
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            )
          : _isMapView
              ? MapViewWidget(serviceCenters: filteredCenters)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCenters.length,
                  itemBuilder: (context, index) {
                    return ServiceCenterCard(
                      center: filteredCenters[index],
                      onTap: () {
                        context.push(
                            '/booking/services/${filteredCenters[index].id}');
                      },
                    );
                  },
                ),
    );
  }
}
