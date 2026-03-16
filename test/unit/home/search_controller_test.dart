import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/home/application/search_controller.dart';

import '../../helpers/create_container.dart';
import '../../helpers/test_data.dart';

void main() {
  group('SearchState', () {
    test('has correct default values', () {
      const state = SearchState();

      expect(state.query, isEmpty);
      expect(state.selectedServiceTypes, isEmpty);
      expect(state.minRating, 0.0);
      expect(state.maxDistance, 50.0);
      expect(state.sortBy, SortOption.distance);
    });

    test('hasActiveFilters returns false for default state', () {
      const state = SearchState();
      expect(state.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters returns true when query is set', () {
      const state = SearchState(query: 'oil');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns true when service types are selected', () {
      const state = SearchState(selectedServiceTypes: {'Oil Change'});
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns true when minRating is above 0', () {
      const state = SearchState(minRating: 3.0);
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns true when maxDistance is below 50', () {
      const state = SearchState(maxDistance: 10.0);
      expect(state.hasActiveFilters, isTrue);
    });

    test('copyWith preserves unchanged fields', () {
      const state = SearchState(
        query: 'test',
        minRating: 4.0,
        maxDistance: 10.0,
        sortBy: SortOption.rating,
      );

      final updated = state.copyWith(query: 'new');

      expect(updated.query, 'new');
      expect(updated.minRating, 4.0);
      expect(updated.maxDistance, 10.0);
      expect(updated.sortBy, SortOption.rating);
    });
  });

  group('SearchController', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has default values', () {
      final state = container.read(searchControllerProvider);

      expect(state.query, isEmpty);
      expect(state.selectedServiceTypes, isEmpty);
      expect(state.minRating, 0.0);
      expect(state.maxDistance, 50.0);
      expect(state.sortBy, SortOption.distance);
    });

    test('setQuery updates the search query', () {
      container.read(searchControllerProvider.notifier).setQuery('oil change');

      final state = container.read(searchControllerProvider);
      expect(state.query, 'oil change');
    });

    test('toggleServiceType adds a service type', () {
      container
          .read(searchControllerProvider.notifier)
          .toggleServiceType('Oil Change');

      final state = container.read(searchControllerProvider);
      expect(state.selectedServiceTypes, contains('Oil Change'));
    });

    test('toggleServiceType removes an already-selected service type', () {
      final notifier = container.read(searchControllerProvider.notifier);
      notifier.toggleServiceType('Oil Change');
      notifier.toggleServiceType('Oil Change');

      final state = container.read(searchControllerProvider);
      expect(state.selectedServiceTypes, isNot(contains('Oil Change')));
    });

    test('setMinRating updates minimum rating', () {
      container.read(searchControllerProvider.notifier).setMinRating(4.0);

      final state = container.read(searchControllerProvider);
      expect(state.minRating, 4.0);
    });

    test('setMaxDistance updates maximum distance', () {
      container.read(searchControllerProvider.notifier).setMaxDistance(10.0);

      final state = container.read(searchControllerProvider);
      expect(state.maxDistance, 10.0);
    });

    test('setSortBy updates sort option', () {
      container
          .read(searchControllerProvider.notifier)
          .setSortBy(SortOption.rating);

      final state = container.read(searchControllerProvider);
      expect(state.sortBy, SortOption.rating);
    });

    test('clearFilters resets to defaults', () {
      final notifier = container.read(searchControllerProvider.notifier);
      notifier.setQuery('test');
      notifier.setMinRating(4.0);
      notifier.setMaxDistance(10.0);
      notifier.setSortBy(SortOption.name);

      notifier.clearFilters();

      final state = container.read(searchControllerProvider);
      expect(state.query, isEmpty);
      expect(state.minRating, 0.0);
      expect(state.maxDistance, 50.0);
      expect(state.sortBy, SortOption.distance);
    });

    group('filterAndSortCenters', () {
      test('returns all centers when no filters are active', () {
        final notifier = container.read(searchControllerProvider.notifier);
        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result.length, kTestServiceCenters.length);
      });

      test('filters by search query (name match)', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setQuery('AutoFix');

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result.length, 1);
        expect(result.first.name, 'AutoFix Pro');
      });

      test('filters by search query (service match)', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setQuery('detailing');

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result.length, 1);
        expect(result.first.name, 'Premium Auto Care');
      });

      test('filters by search query case-insensitively', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setQuery('AUTOFIX');

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result.length, 1);
        expect(result.first.name, 'AutoFix Pro');
      });

      test('filters by service type', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.toggleServiceType('Brake Repair');

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        // AutoFix Pro and Budget Brakes have Brake Repair
        expect(result.length, 2);
        expect(
            result.every((c) => c.services.contains('Brake Repair')), isTrue);
      });

      test('filters by minimum rating', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setMinRating(4.5);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result.every((c) => c.rating >= 4.5), isTrue);
        // AutoFix Pro (4.8) and Premium Auto Care (4.9)
        expect(result.length, 2);
      });

      test('filters by maximum distance', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setMaxDistance(3.0);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result.every((c) => c.distance <= 3.0), isTrue);
        // AutoFix Pro (1.2) and Quick Lube (2.5)
        expect(result.length, 2);
      });

      test('sorts by distance ascending', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setSortBy(SortOption.distance);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        for (int i = 0; i < result.length - 1; i++) {
          expect(result[i].distance <= result[i + 1].distance, isTrue);
        }
      });

      test('sorts by rating descending', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setSortBy(SortOption.rating);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        for (int i = 0; i < result.length - 1; i++) {
          expect(result[i].rating >= result[i + 1].rating, isTrue);
        }
      });

      test('sorts by name alphabetically', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setSortBy(SortOption.name);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        for (int i = 0; i < result.length - 1; i++) {
          expect(result[i].name.compareTo(result[i + 1].name) <= 0, isTrue);
        }
      });

      test('combines multiple filters', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setMinRating(4.0);
        notifier.setMaxDistance(3.0);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        // Only AutoFix Pro (rating 4.8, distance 1.2) and Quick Lube (4.2, 2.5)
        expect(result.length, 2);
        expect(
            result.every((c) => c.rating >= 4.0 && c.distance <= 3.0), isTrue);
      });

      test('returns empty list when no centers match', () {
        final notifier = container.read(searchControllerProvider.notifier);
        notifier.setMinRating(5.0);

        final result = notifier.filterAndSortCenters(kTestServiceCenters);

        expect(result, isEmpty);
      });
    });
  });
}
