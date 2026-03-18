// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mechanic_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mechanicRepositoryHash() =>
    r'762e20a0406028e8f0afe8bbe25e8819db7f28bc';

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

typedef MechanicRepositoryRef = ProviderRef<MechanicRepository>;
String _$jobRequestHash() => r'4f9b48d8ed0cdda2d037e91ac877e418e9f1d28c';

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

String _$jobRequestFutureHash() => r'd1223c0e64494fd696a85ad94822e5149344c9e2';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
