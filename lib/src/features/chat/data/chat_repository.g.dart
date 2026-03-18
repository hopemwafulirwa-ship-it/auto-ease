// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'92dfea17828d8f30908d84dd2bb1cbb926d09880';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$chatRoomHash() => r'ecc0356e960d163e0f1a2a9f4ed033cf2f255f0f';

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

/// See also [chatRoom].
@ProviderFor(chatRoom)
const chatRoomProvider = ChatRoomFamily();

/// See also [chatRoom].
class ChatRoomFamily extends Family<AsyncValue<ChatRoom?>> {
  /// See also [chatRoom].
  const ChatRoomFamily();

  /// See also [chatRoom].
  ChatRoomProvider call(
    String id,
  ) {
    return ChatRoomProvider(
      id,
    );
  }

  @override
  ChatRoomProvider getProviderOverride(
    covariant ChatRoomProvider provider,
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
  String? get name => r'chatRoomProvider';
}

/// See also [chatRoom].
class ChatRoomProvider extends AutoDisposeStreamProvider<ChatRoom?> {
  /// See also [chatRoom].
  ChatRoomProvider(
    String id,
  ) : this._internal(
          (ref) => chatRoom(
            ref as ChatRoomRef,
            id,
          ),
          from: chatRoomProvider,
          name: r'chatRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomHash,
          dependencies: ChatRoomFamily._dependencies,
          allTransitiveDependencies: ChatRoomFamily._allTransitiveDependencies,
          id: id,
        );

  ChatRoomProvider._internal(
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
    Stream<ChatRoom?> Function(ChatRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomProvider._internal(
        (ref) => create(ref as ChatRoomRef),
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
  AutoDisposeStreamProviderElement<ChatRoom?> createElement() {
    return _ChatRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatRoomRef on AutoDisposeStreamProviderRef<ChatRoom?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ChatRoomProviderElement
    extends AutoDisposeStreamProviderElement<ChatRoom?> with ChatRoomRef {
  _ChatRoomProviderElement(super.provider);

  @override
  String get id => (origin as ChatRoomProvider).id;
}

String _$chatRoomFutureHash() => r'19ed20b4b559f5dd0b1e1f33818223c33e0b189d';

/// See also [chatRoomFuture].
@ProviderFor(chatRoomFuture)
const chatRoomFutureProvider = ChatRoomFutureFamily();

/// See also [chatRoomFuture].
class ChatRoomFutureFamily extends Family<AsyncValue<ChatRoom?>> {
  /// See also [chatRoomFuture].
  const ChatRoomFutureFamily();

  /// See also [chatRoomFuture].
  ChatRoomFutureProvider call(
    String id,
  ) {
    return ChatRoomFutureProvider(
      id,
    );
  }

  @override
  ChatRoomFutureProvider getProviderOverride(
    covariant ChatRoomFutureProvider provider,
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
  String? get name => r'chatRoomFutureProvider';
}

/// See also [chatRoomFuture].
class ChatRoomFutureProvider extends AutoDisposeFutureProvider<ChatRoom?> {
  /// See also [chatRoomFuture].
  ChatRoomFutureProvider(
    String id,
  ) : this._internal(
          (ref) => chatRoomFuture(
            ref as ChatRoomFutureRef,
            id,
          ),
          from: chatRoomFutureProvider,
          name: r'chatRoomFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomFutureHash,
          dependencies: ChatRoomFutureFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomFutureFamily._allTransitiveDependencies,
          id: id,
        );

  ChatRoomFutureProvider._internal(
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
    FutureOr<ChatRoom?> Function(ChatRoomFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatRoomFutureProvider._internal(
        (ref) => create(ref as ChatRoomFutureRef),
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
  AutoDisposeFutureProviderElement<ChatRoom?> createElement() {
    return _ChatRoomFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatRoomFutureRef on AutoDisposeFutureProviderRef<ChatRoom?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ChatRoomFutureProviderElement
    extends AutoDisposeFutureProviderElement<ChatRoom?> with ChatRoomFutureRef {
  _ChatRoomFutureProviderElement(super.provider);

  @override
  String get id => (origin as ChatRoomFutureProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
