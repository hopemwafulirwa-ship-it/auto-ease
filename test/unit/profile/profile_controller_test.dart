import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/application/profile_controller.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

import '../../helpers/create_container.dart';
import '../../helpers/fake_auth_repository.dart';
import '../../helpers/fake_profile_repository.dart';
import '../../helpers/test_data.dart';

void main() {
  group('ProfileController (Story 1.2)', () {
    late FakeAuthRepository fakeAuthRepository;
    late FakeProfileRepository fakeProfileRepository;
    late ProviderContainer container;
    late ProviderSubscription<AsyncValue<UserProfile>> subscription;

    const initialUser = AppUser(
      uid: 'test_user_001',
      email: 'jane@test.com',
      name: 'Jane Test',
      role: AppUserRole.customer,
    );

    setUp(() {
      fakeAuthRepository = FakeAuthRepository(initialUser: initialUser);
      fakeProfileRepository = FakeProfileRepository(
        initialProfile: kTestUserProfile,
        authRepository: fakeAuthRepository,
      );
      container = createContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuthRepository),
          profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
        ],
      );
      subscription = container.listen(profileControllerProvider, (_, __) {});
    });

    tearDown(() {
      subscription.close();
      fakeProfileRepository.dispose();
      fakeAuthRepository.dispose();
      container.dispose();
    });

    test('initial state streams authenticated user profile', () async {
      final profile = await container.read(profileControllerProvider.future);

      expect(profile.id, kTestUserProfile.id);
      expect(profile.name, kTestUserProfile.name);
      expect(profile.email, kTestUserProfile.email);
      expect(profile.phone, kTestUserProfile.phone);
      expect(profile.role, AppUserRole.customer);
    });

    test('updateProfile updates name, phone, and avatarUrl and syncs auth metadata',
        () async {
      await container.read(profileControllerProvider.future);

      await container.read(profileControllerProvider.notifier).updateProfile(
            name: 'Jane Updated',
            phone: '+1 555-999-0000',
            avatarUrl: 'https://example.com/jane.png',
          );

      final state = container.read(profileControllerProvider);
      expect(state.hasError, isFalse);
      expect(state.requireValue.name, 'Jane Updated');
      expect(state.requireValue.phone, '+1 555-999-0000');
      expect(state.requireValue.avatarUrl, 'https://example.com/jane.png');

      expect(fakeAuthRepository.lastUpdatedName, 'Jane Updated');
      expect(
        fakeAuthRepository.lastUpdatedAvatarUrl,
        'https://example.com/jane.png',
      );
      expect(fakeAuthRepository.currentUser?.name, 'Jane Updated');
    });

    test('updateProfile updates email', () async {
      await container.read(profileControllerProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .updateProfile(email: 'new@email.com');

      final profile = container.read(profileControllerProvider);
      expect(profile.requireValue.email, 'new@email.com');
    });

    test('updateRole updates both profile role and auth user metadata role',
        () async {
      await container.read(profileControllerProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .updateRole(AppUserRole.mechanic);

      final profile = container.read(profileControllerProvider).requireValue;
      expect(profile.role, AppUserRole.mechanic);
      expect(fakeAuthRepository.lastUpdatedRole, AppUserRole.mechanic);
      expect(fakeAuthRepository.currentUser?.role, AppUserRole.mechanic);
    });

    test(
        'updateRole rolls back profile role and surfaces AsyncError when auth metadata sync fails',
        () async {
      await container.read(profileControllerProvider.future);
      fakeAuthRepository.shouldFail = true;

      await container
          .read(profileControllerProvider.notifier)
          .updateRole(AppUserRole.mechanic);

      final state = container.read(profileControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.valueOrNull?.role, AppUserRole.customer);
      expect(
        fakeProfileRepository.getProfile('test_user_001')?.role,
        AppUserRole.customer,
      );
      expect(fakeAuthRepository.currentUser?.role, AppUserRole.customer);
    });

    test(
        'updateProfile rolls back profile name and retains previous valueOrNull when auth metadata sync fails',
        () async {
      await container.read(profileControllerProvider.future);
      fakeAuthRepository.shouldFail = true;

      await container
          .read(profileControllerProvider.notifier)
          .updateProfile(name: 'Attempted Name Change');

      final state = container.read(profileControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.valueOrNull?.name, kTestUserProfile.name);
      expect(
        fakeProfileRepository.getProfile('test_user_001')?.name,
        kTestUserProfile.name,
      );
    });

    test('toggleNotifications enables and disables notifications', () async {
      await container.read(profileControllerProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .toggleNotifications(false);
      expect(
        container.read(profileControllerProvider).requireValue.notificationsEnabled,
        isFalse,
      );

      await container
          .read(profileControllerProvider.notifier)
          .toggleNotifications(true);
      expect(
        container.read(profileControllerProvider).requireValue.notificationsEnabled,
        isTrue,
      );
    });

    test('toggleDarkMode enables and disables dark mode', () async {
      await container.read(profileControllerProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .toggleDarkMode(true);
      expect(
        container.read(profileControllerProvider).requireValue.darkModeEnabled,
        isTrue,
      );

      await container
          .read(profileControllerProvider.notifier)
          .toggleDarkMode(false);
      expect(
        container.read(profileControllerProvider).requireValue.darkModeEnabled,
        isFalse,
      );
    });

    test('surfaces RLS 42501 PostgrestException as AsyncError on unauthorized update',
        () async {
      await container.read(profileControllerProvider.future);

      // Simulate RLS mismatch where authenticated session uid differs from target profile
      fakeProfileRepository.authorizedUid = 'different_user_uid';

      await container
          .read(profileControllerProvider.notifier)
          .updateProfile(name: 'Unauthorized Edit');

      final state = container.read(profileControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.valueOrNull, kTestUserProfile);
      expect(
        state.error,
        isA<PostgrestException>().having((e) => e.code, 'code', '42501'),
      );
    });

    test('logout signs out via AuthRepository and resets profile state',
        () async {
      await container.read(profileControllerProvider.future);

      await container.read(profileControllerProvider.notifier).logout();

      expect(fakeAuthRepository.signOutCalled, isTrue);
      expect(fakeAuthRepository.currentUser, isNull);
      final profile = container.read(profileControllerProvider).requireValue;
      expect(profile.id, isEmpty);
    });

    test(
        'updateProfile surfaces AuthException when session is expired (currentUser is null)',
        () async {
      await container.read(profileControllerProvider.future);
      await fakeAuthRepository.signOut();

      await container
          .read(profileControllerProvider.notifier)
          .updateProfile(name: 'Unauthenticated Edit');

      final state = container.read(profileControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<AuthException>());
    });
  });
}
