import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_ease/src/common/services/local_storage_service.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:auto_ease/src/routing/app_router.dart';

import '../helpers/create_container.dart';
import '../helpers/fake_auth_repository.dart';

void main() {
  group('GoRouter Auth & Cross-Role Guarding (Story 1.1)', () {
    late FakeAuthRepository fakeAuthRepository;
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({'is_first_time': false});
      fakeAuthRepository = FakeAuthRepository();
      container = createContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuthRepository),
        ],
      );
    });

    tearDown(() {
      fakeAuthRepository.dispose();
      container.dispose();
    });

    testWidgets('redirects unauthenticated access to protected routes to /login',
        (tester) async {
      final router = container.read(goRouterProvider);
      router.go('/mechanic/earnings');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.path, '/login');
    });

    testWidgets(
        'redirects authenticated customer away from /login and /mechanic/* to /home',
        (tester) async {
      fakeAuthRepository.currentUser = const AppUser(
        uid: 'cust-1',
        email: 'cust@example.com',
        name: 'Alice Customer',
        role: AppUserRole.customer,
      );

      final router = container.read(goRouterProvider);
      router.go('/mechanic/earnings');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.path, '/home');
    });

    testWidgets(
        'redirects authenticated mechanic on /login or /home to /mechanic/home',
        (tester) async {
      fakeAuthRepository.currentUser = const AppUser(
        uid: 'mech-1',
        email: 'mech@example.com',
        name: 'Bob Mechanic',
        role: AppUserRole.mechanic,
      );

      final router = container.read(goRouterProvider);
      router.go('/login');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        '/mechanic/home',
      );
    });
  });

  group('OnboardingScreen Persistence & Navigation (Story 1.1)', () {
    testWidgets(
        'completing onboarding sets isFirstTime to false and routes to /login',
        (tester) async {
      SharedPreferences.setMockInitialValues({'is_first_time': true});
      final fakeAuthRepository = FakeAuthRepository();
      final container = createContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuthRepository),
        ],
      );
      addTearDown(() {
        fakeAuthRepository.dispose();
        container.dispose();
      });

      final router = container.read(goRouterProvider);
      router.go('/onboarding');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.text('Find Trusted Mechanics'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Book Appointments'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Track Real-time Status'), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      final storage = await LocalStorageService.init();
      expect(storage.getIsFirstTime(), isFalse);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/login');
    });
  });
}

