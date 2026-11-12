import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

class _FakePostgrestFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  final Object? errorToThrow;
  _FakePostgrestFilterBuilder({this.errorToThrow});

  @override
  Future<S> then<S>(
    FutureOr<S> Function(dynamic value) onValue, {
    Function? onError,
  }) async {
    if (errorToThrow != null) {
      if (onError != null) {
        return await onError(errorToThrow!);
      }
      throw errorToThrow!;
    }
    return await onValue(null);
  }
}

class _FakeSupabaseQueryBuilder extends Fake implements SupabaseQueryBuilder {
  Map<String, dynamic>? lastUpsertedValues;
  Object? upsertError;

  @override
  PostgrestFilterBuilder<dynamic> upsert(
    Object values, {
    String? onConflict,
    bool ignoreDuplicates = false,
    bool defaultToNull = true,
  }) {
    if (values is Map<String, dynamic>) {
      lastUpsertedValues = Map<String, dynamic>.from(values);
    }
    return _FakePostgrestFilterBuilder(errorToThrow: upsertError);
  }
}

class _FakeGoTrueClient extends Fake implements GoTrueClient {
  Object? errorToThrow;
  AuthResponse responseToReturn = AuthResponse();
  bool signOutCalled = false;
  final StreamController<AuthState> authStateController =
      StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get onAuthStateChange => authStateController.stream;

  @override
  Future<AuthResponse> signUp({
    String? email,
    String? phone,
    required String password,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) async {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return responseToReturn;
  }

  @override
  Future<AuthResponse> signInWithPassword({
    String? email,
    String? phone,
    required String password,
    String? captchaToken,
  }) async {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return responseToReturn;
  }

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async {
    signOutCalled = true;
  }
}

class _FakeSupabaseClient extends Fake implements SupabaseClient {
  final _FakeGoTrueClient _auth = _FakeGoTrueClient();
  final _FakeSupabaseQueryBuilder _profilesBuilder =
      _FakeSupabaseQueryBuilder();
  String? lastQueriedTable;

  @override
  GoTrueClient get auth => _auth;

  @override
  SupabaseQueryBuilder from(String table) {
    lastQueriedTable = table;
    return _profilesBuilder;
  }
}

void main() {
  group('AppUser & Profile Serialization (Story 1.1)', () {
    test('AppUser.fromSupabaseUser maps customer role by default', () {
      const supabaseUser = User(
        id: 'user-123',
        appMetadata: {},
        userMetadata: {'name': 'Alice Customer'},
        aud: 'authenticated',
        email: 'alice@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );

      final appUser = AppUser.fromSupabaseUser(supabaseUser);

      expect(appUser.uid, 'user-123');
      expect(appUser.email, 'alice@example.com');
      expect(appUser.name, 'Alice Customer');
      expect(appUser.role, AppUserRole.customer);
      expect(
        appUser.copyWith(role: AppUserRole.mechanic).role,
        AppUserRole.mechanic,
      );
    });

    test('AppUser.fromSupabaseUser maps mechanic role from userMetadata', () {
      const supabaseUser = User(
        id: 'mech-456',
        appMetadata: {},
        userMetadata: {'full_name': 'Bob Mechanic', 'role': 'mechanic'},
        aud: 'authenticated',
        email: 'bob@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );

      final appUser = AppUser.fromSupabaseUser(supabaseUser);

      expect(appUser.uid, 'mech-456');
      expect(appUser.email, 'bob@example.com');
      expect(appUser.name, 'Bob Mechanic');
      expect(appUser.role, AppUserRole.mechanic);
    });

    test('AppUser.fromJson and toJson preserve both name and full_name keys',
        () {
      final json = {
        'id': 'user-789',
        'email': 'charlie@example.com',
        'full_name': 'Charlie Tech',
        'role': 'mechanic',
      };

      final appUser = AppUser.fromJson(json);
      expect(appUser.uid, 'user-789');
      expect(appUser.email, 'charlie@example.com');
      expect(appUser.name, 'Charlie Tech');
      expect(appUser.role, AppUserRole.mechanic);

      final serialized = appUser.toJson();
      expect(serialized['id'], 'user-789');
      expect(serialized['email'], 'charlie@example.com');
      expect(serialized['name'], 'Charlie Tech');
      expect(serialized['full_name'], 'Charlie Tech');
      expect(serialized['role'], 'mechanic');
    });

    test('UserProfile.fromJson accepts either full_name or name and supports ==',
        () {
      final fromNameKey = UserProfile.fromJson({
        'id': 'u1',
        'name': 'Name From Auth',
        'email': 'auth@example.com',
      });
      expect(fromNameKey.name, 'Name From Auth');
      expect(fromNameKey.email, 'auth@example.com');

      final fromFullNameKey = UserProfile.fromJson({
        'id': 'u1',
        'full_name': 'Name From Auth',
        'email': 'auth@example.com',
      });
      expect(fromFullNameKey, equals(fromNameKey));
      expect(fromFullNameKey.hashCode, equals(fromNameKey.hashCode));
    });
  });

  group('AuthRepository behavior & error handling', () {
    late _FakeSupabaseClient fakeSupabase;
    late AuthRepository repository;

    setUp(() {
      fakeSupabase = _FakeSupabaseClient();
      repository = AuthRepository(fakeSupabase);
    });

    tearDown(() {
      fakeSupabase._auth.authStateController.close();
    });

    test(
        'signUpWithEmailAndPassword upserts profiles record when user is returned',
        () async {
      const createdUser = User(
        id: 'user-999',
        appMetadata: {},
        userMetadata: {
          'name': 'Maya Mechanic',
          'full_name': 'Maya Mechanic',
          'role': 'mechanic',
          'avatar_url': 'https://example.com/maya.png',
        },
        aud: 'authenticated',
        email: 'maya@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );
      fakeSupabase._auth.responseToReturn = AuthResponse(user: createdUser);

      await repository.signUpWithEmailAndPassword(
        email: 'maya@example.com',
        password: 'password123',
        name: 'Maya Mechanic',
        role: AppUserRole.mechanic,
      );

      expect(fakeSupabase.lastQueriedTable, 'profiles');
      expect(fakeSupabase._profilesBuilder.lastUpsertedValues, {
        'id': 'user-999',
        'email': 'maya@example.com',
        'name': 'Maya Mechanic',
        'full_name': 'Maya Mechanic',
        'role': 'mechanic',
        'avatar_url': 'https://example.com/maya.png',
      });
    });

    test(
        'signUpWithEmailAndPassword throws and signs out when profiles upsert fails with PostgrestException',
        () async {
      const createdUser = User(
        id: 'user-999',
        appMetadata: {},
        userMetadata: {'role': 'customer'},
        aud: 'authenticated',
        email: 'maya@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );
      fakeSupabase._auth.responseToReturn = AuthResponse(
        user: createdUser,
        session: Session(
          accessToken: 'token',
          tokenType: 'bearer',
          user: createdUser,
        ),
      );
      fakeSupabase._profilesBuilder.upsertError = const PostgrestException(
        message: 'new row violates row-level security policy',
        code: '42501',
      );

      await expectLater(
        repository.signUpWithEmailAndPassword(
          email: 'maya@example.com',
          password: 'password123',
          name: 'Maya',
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains(
                    'Failed to save user profile: new row violates row-level security policy'),
          ),
        ),
      );
      expect(fakeSupabase._auth.signOutCalled, isTrue);
    });

    test('authStateChanges deduplicates identical user emissions on tokenRefreshed',
        () async {
      const user = User(
        id: 'u-1',
        appMetadata: {},
        userMetadata: {'name': 'Alice', 'role': 'customer'},
        aud: 'authenticated',
        email: 'alice@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );
      final session = Session(
        accessToken: 'token-1',
        tokenType: 'bearer',
        user: user,
      );
      final refreshedSession = Session(
        accessToken: 'token-2',
        tokenType: 'bearer',
        user: user,
      );

      final emissions = <AppUser?>[];
      final sub = repository.authStateChanges().listen(emissions.add);
      await Future<void>.delayed(Duration.zero);

      fakeSupabase._auth.authStateController
          .add(AuthState(AuthChangeEvent.signedIn, session));
      fakeSupabase._auth.authStateController
          .add(AuthState(AuthChangeEvent.tokenRefreshed, refreshedSession));
      fakeSupabase._auth.authStateController
          .add(AuthState(AuthChangeEvent.signedOut, null));
      await Future<void>.delayed(Duration.zero);

      expect(emissions.length, 2);
      expect(emissions[0]?.uid, 'u-1');
      expect(emissions[1], isNull);

      await sub.cancel();
    });

    test(
        'signUpWithEmailAndPassword maps AuthException with SocketException to friendly message',
        () async {
      fakeSupabase._auth.errorToThrow = const AuthException(
        "ClientException with SocketException: Failed host lookup: 'wjwrocuculmcxgzrffgh.supabase.co' (OS Error: No address associated with hostname, errno = 7)",
      );

      await expectLater(
        repository.signUpWithEmailAndPassword(
          email: 'user@example.com',
          password: 'password123',
          name: 'Kagami Hope',
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains(
                    'Unable to connect to the server. Please check your internet connection and try again.'),
          ),
        ),
      );
    });

    test(
        'signUpWithEmailAndPassword maps generic ClientException / SocketException to friendly message',
        () async {
      fakeSupabase._auth.errorToThrow = Exception(
        "ClientException with SocketException: Failed host lookup: 'wjwrocuculmcxgzrffgh.supabase.co'",
      );

      await expectLater(
        repository.signUpWithEmailAndPassword(
          email: 'user@example.com',
          password: 'password123',
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains(
                    'Unable to connect to the server. Please check your internet connection and try again.'),
          ),
        ),
      );
    });

    test('signInWithEmailAndPassword maps network errors to friendly message',
        () async {
      fakeSupabase._auth.errorToThrow = AuthRetryableFetchException(
        message: 'SocketException: Network is unreachable',
      );

      await expectLater(
        repository.signInWithEmailAndPassword(
            'user@example.com', 'password123'),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains(
                    'Unable to connect to the server. Please check your internet connection and try again.'),
          ),
        ),
      );
    });
  });
}
