import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';

class _FakePostgrestTransformBuilder extends Fake
    implements PostgrestTransformBuilder<Map<String, dynamic>> {
  final Map<String, dynamic>? rowToReturn;
  final Object? errorToThrow;

  _FakePostgrestTransformBuilder({
    this.rowToReturn,
    this.errorToThrow,
  });

  @override
  Future<R> then<R>(
    FutureOr<R> Function(Map<String, dynamic> value) onValue, {
    Function? onError,
  }) async {
    if (errorToThrow != null) {
      if (onError != null) {
        return await onError(errorToThrow!);
      }
      throw errorToThrow!;
    }
    return await onValue(rowToReturn!);
  }
}

class _FakePostgrestListTransformBuilder extends Fake
    implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  final Map<String, dynamic>? rowToReturn;
  final Object? errorToThrow;

  _FakePostgrestListTransformBuilder({
    this.rowToReturn,
    this.errorToThrow,
  });

  @override
  PostgrestTransformBuilder<Map<String, dynamic>> single() {
    return _FakePostgrestTransformBuilder(
      rowToReturn: rowToReturn,
      errorToThrow: errorToThrow,
    );
  }
}

class _FakePostgrestUpdateFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  final Map<String, dynamic> updates;
  final String authorizedUid;
  final Object? customError;
  String? filteredColumn;
  Object? filteredValue;

  _FakePostgrestUpdateFilterBuilder({
    required this.updates,
    required this.authorizedUid,
    this.customError,
  });

  @override
  PostgrestFilterBuilder<dynamic> eq(String column, Object value) {
    filteredColumn = column;
    filteredValue = value;
    return this;
  }

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> select([
    String columns = '*',
  ]) {
    if (customError != null) {
      return _FakePostgrestListTransformBuilder(errorToThrow: customError);
    }
    if (filteredValue != authorizedUid) {
      return _FakePostgrestListTransformBuilder(
        errorToThrow: const PostgrestException(
          message:
              'new row violates row-level security policy for table "profiles"',
          code: '42501',
        ),
      );
    }

    return _FakePostgrestListTransformBuilder(
      rowToReturn: {
        'id': filteredValue,
        'email': updates['email'] ?? 'jane@test.com',
        'name': updates['name'] ?? 'Jane Test',
        'full_name': updates['full_name'] ?? 'Jane Test',
        'phone': updates['phone'] ?? '+1 555-000-1234',
        'avatar_url': updates['avatar_url'],
        'role': updates['role'] ?? 'customer',
        'notifications_enabled': updates['notifications_enabled'] ?? true,
        'dark_mode_enabled': updates['dark_mode_enabled'] ?? false,
      },
    );
  }
}

class _FakeSupabaseStreamBuilder extends Stream<List<Map<String, dynamic>>>
    with Fake
    implements SupabaseStreamFilterBuilder {
  final Stream<List<Map<String, dynamic>>> _stream;
  String? filteredColumn;
  Object? filteredValue;

  _FakeSupabaseStreamBuilder(this._stream);

  @override
  SupabaseStreamFilterBuilder eq(String column, Object value) {
    filteredColumn = column;
    filteredValue = value;
    return this;
  }

  @override
  StreamSubscription<List<Map<String, dynamic>>> listen(
    void Function(List<Map<String, dynamic>> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _FakeProfilesQueryBuilder extends Fake implements SupabaseQueryBuilder {
  final String authorizedUid;
  Map<String, dynamic>? lastUpdatedValues;
  _FakePostgrestUpdateFilterBuilder? lastFilterBuilder;
  List<String>? lastStreamPrimaryKey;
  _FakeSupabaseStreamBuilder? lastStreamBuilder;
  Stream<List<Map<String, dynamic>>> streamToReturn = const Stream.empty();
  Object? customError;

  _FakeProfilesQueryBuilder({required this.authorizedUid});

  @override
  SupabaseStreamFilterBuilder stream({
    required List<String> primaryKey,
    bool private = false,
  }) {
    lastStreamPrimaryKey = primaryKey;
    lastStreamBuilder = _FakeSupabaseStreamBuilder(streamToReturn);
    return lastStreamBuilder!;
  }

  @override
  PostgrestFilterBuilder<dynamic> update(Map<dynamic, dynamic> values) {
    lastUpdatedValues = Map<String, dynamic>.from(values);
    lastFilterBuilder = _FakePostgrestUpdateFilterBuilder(
      updates: lastUpdatedValues!,
      authorizedUid: authorizedUid,
      customError: customError,
    );
    return lastFilterBuilder!;
  }
}

class _FakeSupabaseClient extends Fake implements SupabaseClient {
  final _FakeProfilesQueryBuilder profilesBuilder;
  String? lastTable;

  _FakeSupabaseClient({required String authorizedUid})
      : profilesBuilder =
            _FakeProfilesQueryBuilder(authorizedUid: authorizedUid);

  @override
  SupabaseQueryBuilder from(String table) {
    lastTable = table;
    return profilesBuilder;
  }
}

void main() {
  group('ProfileRepository (Story 1.2)', () {
    late _FakeSupabaseClient fakeSupabase;
    late ProfileRepository repository;

    setUp(() {
      fakeSupabase = _FakeSupabaseClient(authorizedUid: 'user_123');
      repository = ProfileRepository(fakeSupabase);
    });

    test(
        'updateProfile targets public.profiles with dual name/full_name keys and returns updated UserProfile',
        () async {
      final updated = await repository.updateProfile(
        uid: 'user_123',
        name: 'Jane Doe Updated',
        phone: '+1 555-111-2222',
        avatarUrl: 'https://example.com/avatar.png',
        role: AppUserRole.mechanic,
        notificationsEnabled: false,
        darkModeEnabled: true,
      );

      expect(fakeSupabase.lastTable, 'profiles');
      expect(
        fakeSupabase.profilesBuilder.lastFilterBuilder?.filteredColumn,
        'id',
      );
      expect(
        fakeSupabase.profilesBuilder.lastFilterBuilder?.filteredValue,
        'user_123',
      );

      final payload = fakeSupabase.profilesBuilder.lastUpdatedValues!;
      expect(payload['name'], 'Jane Doe Updated');
      expect(payload['full_name'], 'Jane Doe Updated');
      expect(payload['phone'], '+1 555-111-2222');
      expect(payload['avatar_url'], 'https://example.com/avatar.png');
      expect(payload['role'], 'mechanic');
      expect(payload['notifications_enabled'], isFalse);
      expect(payload['dark_mode_enabled'], isTrue);

      expect(updated.id, 'user_123');
      expect(updated.name, 'Jane Doe Updated');
      expect(updated.phone, '+1 555-111-2222');
      expect(updated.avatarUrl, 'https://example.com/avatar.png');
      expect(updated.role, AppUserRole.mechanic);
      expect(updated.notificationsEnabled, isFalse);
      expect(updated.darkModeEnabled, isTrue);
    });

    test(
        'updateProfile throws PostgrestException(code: 42501) when attempting cross-user update violating RLS',
        () async {
      await expectLater(
        repository.updateProfile(
          uid: 'other_user_999',
          name: 'Unauthorized Hacker',
          role: AppUserRole.mechanic,
        ),
        throwsA(
          isA<PostgrestException>().having((e) => e.code, 'code', '42501'),
        ),
      );
    });

    test(
        'watchProfile streams deserialized UserProfile when populated row is emitted',
        () async {
      fakeSupabase.profilesBuilder.streamToReturn = Stream.value([
        {
          'id': 'user_123',
          'email': 'jane@test.com',
          'full_name': 'Jane Streamed',
          'phone': '+1 555-777-8888',
          'avatar_url': 'https://example.com/stream.png',
          'role': 'mechanic',
          'notifications_enabled': false,
          'dark_mode_enabled': true,
        },
      ]);

      const appUser = AppUser(
        uid: 'user_123',
        email: 'jane@test.com',
        name: 'Jane Fallback',
        role: AppUserRole.customer,
      );

      final profile = await repository.watchProfile(appUser).first;

      expect(fakeSupabase.lastTable, 'profiles');
      expect(fakeSupabase.profilesBuilder.lastStreamPrimaryKey, ['id']);
      expect(
        fakeSupabase.profilesBuilder.lastStreamBuilder?.filteredColumn,
        'id',
      );
      expect(
        fakeSupabase.profilesBuilder.lastStreamBuilder?.filteredValue,
        'user_123',
      );

      expect(profile.id, 'user_123');
      expect(profile.name, 'Jane Streamed');
      expect(profile.email, 'jane@test.com');
      expect(profile.phone, '+1 555-777-8888');
      expect(profile.avatarUrl, 'https://example.com/stream.png');
      expect(profile.role, AppUserRole.mechanic);
      expect(profile.notificationsEnabled, isFalse);
      expect(profile.darkModeEnabled, isTrue);
    });

    test(
        'watchProfile emits fallback UserProfile preserving AppUser fields when stream emits empty list',
        () async {
      fakeSupabase.profilesBuilder.streamToReturn = Stream.value(const []);

      const appUser = AppUser(
        uid: 'user_123',
        email: 'mech@test.com',
        name: 'Alex Fallback',
        role: AppUserRole.mechanic,
      );

      final profile = await repository.watchProfile(appUser).first;

      expect(profile.id, 'user_123');
      expect(profile.name, 'Alex Fallback');
      expect(profile.email, 'mech@test.com');
      expect(profile.phone, isEmpty);
      expect(profile.role, AppUserRole.mechanic);
    });
  });
}
