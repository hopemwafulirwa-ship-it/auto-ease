import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/mechanic/data/mechanic_repository.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';
import 'package:auto_ease/src/routing/app_router.dart';

import '../../../helpers/create_container.dart';
import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_profile_repository.dart';
import '../../../helpers/test_data.dart';

Future<void> iAmLoggedInAsACustomerOnTheProfileScreen(
  WidgetTester tester,
) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  SharedPreferences.setMockInitialValues({'is_first_time': false});

  const initialUser = AppUser(
    uid: 'test_user_001',
    email: 'jane@test.com',
    name: 'Jane Test',
    role: AppUserRole.customer,
  );

  final fakeAuthRepo = FakeAuthRepository(initialUser: initialUser);
  final fakeProfileRepo = FakeProfileRepository(
    initialProfile: kTestUserProfile,
    authRepository: fakeAuthRepo,
  );

  final container = createContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(fakeAuthRepo),
      profileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      jobRequestsProvider.overrideWith((ref) => Stream.value(const [])),
    ],
  );

  addTearDown(() {
    fakeProfileRepo.dispose();
    fakeAuthRepo.dispose();
    container.dispose();
  });

  final router = container.read(goRouterProvider);
  router.go('/home');

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();

  // Navigate to the Profile tab inside MainScaffold
  await tester.tap(find.text('Profile'));
  await tester.pumpAndSettle();
}
