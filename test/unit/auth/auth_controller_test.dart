import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/auth/application/auth_controller.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';

import '../../helpers/create_container.dart';
import '../../helpers/fake_auth_repository.dart';

void main() {
  group('AuthController', () {
    late FakeAuthRepository fakeAuthRepository;
    late ProviderContainer container;
    late ProviderSubscription<AsyncValue<void>> subscription;

    setUp(() {
      fakeAuthRepository = FakeAuthRepository();
      container = createContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuthRepository),
        ],
      );
      // Keep autoDispose provider alive across async boundaries
      subscription = container.listen(authControllerProvider, (_, __) {});
    });

    tearDown(() {
      subscription.close();
      fakeAuthRepository.dispose();
      container.dispose();
    });

    test('initial state is AsyncData(null)', () {
      final state = container.read(authControllerProvider);
      expect(state, const AsyncData<void>(null));
    });

    test('signInWithEmailAndPassword succeeds and delegates to repository',
        () async {
      final controller = container.read(authControllerProvider.notifier);

      await controller.signInWithEmailAndPassword(
        'user@example.com',
        'password123',
      );

      final state = container.read(authControllerProvider);
      expect(state.hasError, isFalse);
      expect(fakeAuthRepository.lastSignInEmail, 'user@example.com');
      expect(fakeAuthRepository.lastSignInPassword, 'password123');
      expect(fakeAuthRepository.currentUser?.email, 'user@example.com');
    });

    test('signInWithEmailAndPassword sets AsyncError when repository throws',
        () async {
      fakeAuthRepository.shouldFail = true;
      fakeAuthRepository.failureMessage = 'Invalid email or password';

      final controller = container.read(authControllerProvider.notifier);
      await controller.signInWithEmailAndPassword(
        'wrong@example.com',
        'badpass',
      );

      final state = container.read(authControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Invalid email or password'));
    });

    test(
        'signUpWithEmailAndPassword passes customer and mechanic roles accurately',
        () async {
      final controller = container.read(authControllerProvider.notifier);

      await controller.signUpWithEmailAndPassword(
        email: 'mechanic@example.com',
        password: 'password123',
        name: 'Mike Mechanic',
        role: AppUserRole.mechanic,
      );

      final state = container.read(authControllerProvider);
      expect(state.hasError, isFalse);
      expect(fakeAuthRepository.lastSignUpEmail, 'mechanic@example.com');
      expect(fakeAuthRepository.lastSignUpName, 'Mike Mechanic');
      expect(fakeAuthRepository.lastSignUpRole, AppUserRole.mechanic);
      expect(fakeAuthRepository.currentUser?.role, AppUserRole.mechanic);
    });

    test('signUpWithEmailAndPassword sets AsyncError on failure', () async {
      fakeAuthRepository.shouldFail = true;
      fakeAuthRepository.failureMessage =
          'An account with this email already exists';

      final controller = container.read(authControllerProvider.notifier);
      await controller.signUpWithEmailAndPassword(
        email: 'existing@example.com',
        password: 'password123',
        name: 'Existing User',
      );

      final state = container.read(authControllerProvider);
      expect(state.hasError, isTrue);
      expect(
        state.error.toString(),
        contains('An account with this email already exists'),
      );
    });

    test('signOut clears current user and completes with AsyncData', () async {
      final controller = container.read(authControllerProvider.notifier);
      await controller.signInWithEmailAndPassword(
        'user@example.com',
        'password123',
      );
      expect(fakeAuthRepository.currentUser, isNotNull);

      await controller.signOut();

      final state = container.read(authControllerProvider);
      expect(state.hasError, isFalse);
      expect(fakeAuthRepository.signOutCalled, isTrue);
      expect(fakeAuthRepository.currentUser, isNull);
    });
  });
}
