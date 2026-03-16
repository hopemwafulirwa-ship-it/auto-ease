import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/home/application/search_controller.dart';

void main() {
  group('SearchState', () {
    test('has correct default values', () {
      const state = SearchState();

      expect(state.query, '');
      expect(state.selectedServiceTypes, <String>{});
      expect(state.minRating, 0.0);
      expect(state.maxDistance, 50.0);
      expect(state.sortBy, SortOption.distance);
    });

    test('copyWith preserves all fields when none are specified', () {
      const state = SearchState(
        query: 'oil',
        selectedServiceTypes: {'Oil Change'},
        minRating: 4.0,
        maxDistance: 10.0,
        sortBy: SortOption.rating,
      );

      final copy = state.copyWith();

      expect(copy.query, 'oil');
      expect(copy.selectedServiceTypes, {'Oil Change'});
      expect(copy.minRating, 4.0);
      expect(copy.maxDistance, 10.0);
      expect(copy.sortBy, SortOption.rating);
    });

    test('copyWith updates only specified fields', () {
      const state = SearchState(
        query: 'oil',
        minRating: 4.0,
        maxDistance: 10.0,
      );

      final copy = state.copyWith(query: 'brake', sortBy: SortOption.name);

      // Changed
      expect(copy.query, 'brake');
      expect(copy.sortBy, SortOption.name);

      // Unchanged
      expect(copy.minRating, 4.0);
      expect(copy.maxDistance, 10.0);
    });

    group('hasActiveFilters', () {
      test('returns false for default state', () {
        const state = SearchState();
        expect(state.hasActiveFilters, isFalse);
      });

      test('returns true when query is non-empty', () {
        const state = SearchState(query: 'test');
        expect(state.hasActiveFilters, isTrue);
      });

      test('returns true when service types are selected', () {
        const state = SearchState(selectedServiceTypes: {'Oil Change'});
        expect(state.hasActiveFilters, isTrue);
      });

      test('returns true when minRating is above zero', () {
        const state = SearchState(minRating: 3.0);
        expect(state.hasActiveFilters, isTrue);
      });

      test('returns true when maxDistance is below 50', () {
        const state = SearchState(maxDistance: 25.0);
        expect(state.hasActiveFilters, isTrue);
      });

      test('returns false when maxDistance is exactly 50', () {
        const state = SearchState(maxDistance: 50.0);
        expect(state.hasActiveFilters, isFalse);
      });

      test('returns false when minRating is exactly 0', () {
        const state = SearchState(minRating: 0.0);
        expect(state.hasActiveFilters, isFalse);
      });
    });
  });

  group('SortOption', () {
    test('has three values', () {
      expect(SortOption.values.length, 3);
    });

    test('contains distance, rating, and name', () {
      expect(SortOption.values, contains(SortOption.distance));
      expect(SortOption.values, contains(SortOption.rating));
      expect(SortOption.values, contains(SortOption.name));
    });
  });
}
