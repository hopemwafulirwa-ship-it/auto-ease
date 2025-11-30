import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/home/domain/service_center_model.dart';

part 'search_controller.g.dart';

enum SortOption {
  distance,
  rating,
  name,
}

class SearchState {
  final String query;
  final Set<String> selectedServiceTypes;
  final double minRating;
  final double maxDistance;
  final SortOption sortBy;

  const SearchState({
    this.query = '',
    this.selectedServiceTypes = const {},
    this.minRating = 0.0,
    this.maxDistance = 50.0,
    this.sortBy = SortOption.distance,
  });

  SearchState copyWith({
    String? query,
    Set<String>? selectedServiceTypes,
    double? minRating,
    double? maxDistance,
    SortOption? sortBy,
  }) {
    return SearchState(
      query: query ?? this.query,
      selectedServiceTypes: selectedServiceTypes ?? this.selectedServiceTypes,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      selectedServiceTypes.isNotEmpty ||
      minRating > 0.0 ||
      maxDistance < 50.0;
}

@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() {
    return const SearchState();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void toggleServiceType(String serviceType) {
    final types = Set<String>.from(state.selectedServiceTypes);
    if (types.contains(serviceType)) {
      types.remove(serviceType);
    } else {
      types.add(serviceType);
    }
    state = state.copyWith(selectedServiceTypes: types);
  }

  void setMinRating(double rating) {
    state = state.copyWith(minRating: rating);
  }

  void setMaxDistance(double distance) {
    state = state.copyWith(maxDistance: distance);
  }

  void setSortBy(SortOption sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void clearFilters() {
    state = const SearchState();
  }

  List<ServiceCenter> filterAndSortCenters(List<ServiceCenter> centers) {
    var filtered = centers.where((center) {
      // Search query filter
      if (state.query.isNotEmpty) {
        final queryLower = state.query.toLowerCase();
        if (!center.name.toLowerCase().contains(queryLower) &&
            !center.services.any((s) => s.toLowerCase().contains(queryLower))) {
          return false;
        }
      }

      // Service type filter
      if (state.selectedServiceTypes.isNotEmpty) {
        if (!state.selectedServiceTypes
            .any((type) => center.services.contains(type))) {
          return false;
        }
      }

      // Rating filter
      if (center.rating < state.minRating) {
        return false;
      }

      // Distance filter
      if (center.distance > state.maxDistance) {
        return false;
      }

      return true;
    }).toList();

    // Sort
    switch (state.sortBy) {
      case SortOption.distance:
        filtered.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case SortOption.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return filtered;
  }
}
