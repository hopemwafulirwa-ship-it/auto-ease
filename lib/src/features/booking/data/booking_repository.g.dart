// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'7d95056a22f42ed98e2fe6834fcbb9e3bbcb7c65';

/// See also [bookingRepository].
@ProviderFor(bookingRepository)
final bookingRepositoryProvider =
    AutoDisposeProvider<BookingRepository>.internal(
  bookingRepository,
  name: r'bookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookingRepositoryRef = AutoDisposeProviderRef<BookingRepository>;
String _$userBookingsHash() => r'bc17ee5b3873fcbf3195e27e870ea29278f989ae';

/// See also [userBookings].
@ProviderFor(userBookings)
final userBookingsProvider =
    AutoDisposeStreamProvider<List<BookingHistory>>.internal(
  userBookings,
  name: r'userBookingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserBookingsRef = AutoDisposeStreamProviderRef<List<BookingHistory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
