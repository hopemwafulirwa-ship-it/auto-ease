// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mechanic_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mechanicRepositoryHash() =>
    r'81939f211fd845916a8eeded75db59bdd3bf9a25';

/// See also [mechanicRepository].
@ProviderFor(mechanicRepository)
final mechanicRepositoryProvider = Provider<MechanicRepository>.internal(
  mechanicRepository,
  name: r'mechanicRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mechanicRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MechanicRepositoryRef = ProviderRef<MechanicRepository>;
String _$jobRequestHash() => r'f9df7962a042729b328881e78dbaf8e8068757e8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [jobRequest].
@ProviderFor(jobRequest)
const jobRequestProvider = JobRequestFamily();

/// See also [jobRequest].
class JobRequestFamily extends Family<AsyncValue<JobRequest?>> {
  /// See also [jobRequest].
  const JobRequestFamily();

  /// See also [jobRequest].
  JobRequestProvider call(
    String id,
  ) {
    return JobRequestProvider(
      id,
    );
  }

  @override
  JobRequestProvider getProviderOverride(
    covariant JobRequestProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobRequestProvider';
}

/// See also [jobRequest].
class JobRequestProvider extends AutoDisposeStreamProvider<JobRequest?> {
  /// See also [jobRequest].
  JobRequestProvider(
    String id,
  ) : this._internal(
          (ref) => jobRequest(
            ref as JobRequestRef,
            id,
          ),
          from: jobRequestProvider,
          name: r'jobRequestProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$jobRequestHash,
          dependencies: JobRequestFamily._dependencies,
          allTransitiveDependencies:
              JobRequestFamily._allTransitiveDependencies,
          id: id,
        );

  JobRequestProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<JobRequest?> Function(JobRequestRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRequestProvider._internal(
        (ref) => create(ref as JobRequestRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<JobRequest?> createElement() {
    return _JobRequestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRequestProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobRequestRef on AutoDisposeStreamProviderRef<JobRequest?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobRequestProviderElement
    extends AutoDisposeStreamProviderElement<JobRequest?> with JobRequestRef {
  _JobRequestProviderElement(super.provider);

  @override
  String get id => (origin as JobRequestProvider).id;
}

String _$jobRequestsHash() => r'82f719af37835112e5ee2d5ca3c98140d023c957';

/// See also [jobRequests].
@ProviderFor(jobRequests)
final jobRequestsProvider =
    AutoDisposeStreamProvider<List<JobRequest>>.internal(
  jobRequests,
  name: r'jobRequestsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$jobRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JobRequestsRef = AutoDisposeStreamProviderRef<List<JobRequest>>;
String _$jobRequestFutureHash() => r'a000a65d91ae9629613733e8b326bb0693cb8a76';

/// See also [jobRequestFuture].
@ProviderFor(jobRequestFuture)
const jobRequestFutureProvider = JobRequestFutureFamily();

/// See also [jobRequestFuture].
class JobRequestFutureFamily extends Family<AsyncValue<JobRequest?>> {
  /// See also [jobRequestFuture].
  const JobRequestFutureFamily();

  /// See also [jobRequestFuture].
  JobRequestFutureProvider call(
    String id,
  ) {
    return JobRequestFutureProvider(
      id,
    );
  }

  @override
  JobRequestFutureProvider getProviderOverride(
    covariant JobRequestFutureProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jobRequestFutureProvider';
}

/// See also [jobRequestFuture].
class JobRequestFutureProvider extends AutoDisposeFutureProvider<JobRequest?> {
  /// See also [jobRequestFuture].
  JobRequestFutureProvider(
    String id,
  ) : this._internal(
          (ref) => jobRequestFuture(
            ref as JobRequestFutureRef,
            id,
          ),
          from: jobRequestFutureProvider,
          name: r'jobRequestFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$jobRequestFutureHash,
          dependencies: JobRequestFutureFamily._dependencies,
          allTransitiveDependencies:
              JobRequestFutureFamily._allTransitiveDependencies,
          id: id,
        );

  JobRequestFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<JobRequest?> Function(JobRequestFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JobRequestFutureProvider._internal(
        (ref) => create(ref as JobRequestFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<JobRequest?> createElement() {
    return _JobRequestFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JobRequestFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JobRequestFutureRef on AutoDisposeFutureProviderRef<JobRequest?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JobRequestFutureProviderElement
    extends AutoDisposeFutureProviderElement<JobRequest?>
    with JobRequestFutureRef {
  _JobRequestFutureProviderElement(super.provider);

  @override
  String get id => (origin as JobRequestFutureProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
