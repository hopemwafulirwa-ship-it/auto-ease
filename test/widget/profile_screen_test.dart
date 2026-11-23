import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/main.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/auth/presentation/role_selection_screen.dart';
import 'package:auto_ease/src/features/mechanic/data/mechanic_repository.dart';
import 'package:auto_ease/src/features/mechanic/presentation/mechanic_home_screen.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';
import 'package:auto_ease/src/features/profile/presentation/edit_profile_screen.dart';
import 'package:auto_ease/src/features/profile/presentation/profile_screen.dart';

import '../helpers/fake_auth_repository.dart';
import '../helpers/fake_profile_repository.dart';
import '../helpers/test_data.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('EditProfileScreen Widget Tests (Story 1.2)', () {
    late FakeAuthRepository fakeAuthRepository;
    late FakeProfileRepository fakeProfileRepository;

    const testUser = AppUser(
      uid: 'test_user_001',
      email: 'jane@test.com',
      name: 'Jane Test',
      role: AppUserRole.customer,
    );

    setUp(() {
      fakeAuthRepository = FakeAuthRepository(initialUser: testUser);
      fakeProfileRepository = FakeProfileRepository(
        initialProfile: kTestUserProfile,
        authRepository: fakeAuthRepository,
      );
    });

    tearDown(() {
      fakeProfileRepository.dispose();
      fakeAuthRepository.dispose();
    });

    testWidgets('validates empty Full Name and Phone Number fields',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: const MaterialApp(home: EditProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        '',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'),
        '',
      );

      final saveButton = find.widgetWithText(FilledButton, 'Save Changes');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your phone number'), findsOneWidget);
    });

    testWidgets(
        'stays open and displays error SnackBar without false success message when RLS/network update fails',
        (tester) async {
      fakeProfileRepository.customError = const PostgrestException(
        message: 'new row violates row-level security policy',
        code: '42501',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: const MaterialApp(home: EditProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Attempted Name',
      );

      final saveButton = find.widgetWithText(FilledButton, 'Save Changes');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
      expect(find.text('Profile updated successfully'), findsNothing);
      expect(
        find.textContaining('new row violates row-level security policy'),
        findsOneWidget,
      );
    });

    testWidgets('allows updating avatar URL via camera button dialog and saving',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: const MaterialApp(home: EditProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('edit_avatar_button')));
      await tester.pumpAndSettle();

      expect(find.text('Update Avatar URL'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Avatar URL'),
        'https://example.com/new-avatar.png',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(FilledButton, 'Save Changes');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pump();

      expect(find.text('Profile updated successfully'), findsOneWidget);
      expect(
        fakeProfileRepository.getProfile('test_user_001')?.avatarUrl,
        'https://example.com/new-avatar.png',
      );
    });
  });

  group('ProfileScreen & Theme Reactivity Widget Tests (Story 1.2)', () {
    late FakeAuthRepository fakeAuthRepository;
    late FakeProfileRepository fakeProfileRepository;

    const testUser = AppUser(
      uid: 'test_user_001',
      email: 'jane@test.com',
      name: 'Jane Test',
      role: AppUserRole.customer,
    );

    setUp(() {
      fakeAuthRepository = FakeAuthRepository(initialUser: testUser);
      fakeProfileRepository = FakeProfileRepository(
        initialProfile: kTestUserProfile,
        authRepository: fakeAuthRepository,
      );
    });

    tearDown(() {
      fakeProfileRepository.dispose();
      fakeAuthRepository.dispose();
    });

    testWidgets('renders profile details, switches role, and toggles dark mode',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jane Test'), findsOneWidget);
      expect(find.text('jane@test.com'), findsAtLeastNWidgets(1));
      expect(find.text('+1 555-000-1234'), findsOneWidget);

      // Switch role to Mechanic
      final mechanicSegment = find.text('Mechanic');
      await tester.ensureVisible(mechanicSegment);
      await tester.tap(mechanicSegment);
      await tester.pumpAndSettle();

      expect(fakeAuthRepository.currentUser?.role, AppUserRole.mechanic);
      expect(
        fakeProfileRepository.getProfile('test_user_001')?.role,
        AppUserRole.mechanic,
      );
      expect(find.text('Mechanic / Service Provider'), findsOneWidget);

      // Toggle Dark Mode
      final darkModeTile = find.widgetWithText(SwitchListTile, 'Dark Mode');
      await tester.ensureVisible(darkModeTile);
      await tester.tap(darkModeTile);
      await tester.pumpAndSettle();

      expect(
        fakeProfileRepository.getProfile('test_user_001')?.darkModeEnabled,
        isTrue,
      );
    });

    testWidgets('AutoEaseApp binds MaterialApp themeMode to darkModeEnabled',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: const AutoEaseApp(),
        ),
      );
      await tester.pumpAndSettle();

      MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.light);

      fakeProfileRepository.seedProfile(
        kTestUserProfile.copyWith(darkModeEnabled: true),
      );
      await tester.pumpAndSettle();

      app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.dark);
    });
  });

  group('MechanicHomeScreen & RoleSelectionScreen Widget Tests (Story 1.2)', () {
    late FakeAuthRepository fakeAuthRepository;
    late FakeProfileRepository fakeProfileRepository;

    const mechanicUser = AppUser(
      uid: 'test_user_001',
      email: 'jane@test.com',
      name: 'Jane Mechanic',
      role: AppUserRole.mechanic,
    );

    setUp(() {
      fakeAuthRepository = FakeAuthRepository(initialUser: mechanicUser);
      fakeProfileRepository = FakeProfileRepository(
        initialProfile: kTestUserProfile.copyWith(role: AppUserRole.mechanic),
        authRepository: fakeAuthRepository,
      );
    });

    tearDown(() {
      fakeProfileRepository.dispose();
      fakeAuthRepository.dispose();
    });

    testWidgets(
        'MechanicHomeScreen Switch to Customer and Edit Profile AppBar actions update role and navigate to /profile/edit',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/mechanic/home',
        routes: [
          GoRoute(
            path: '/mechanic/home',
            builder: (context, state) => const MechanicHomeScreen(),
          ),
          GoRoute(
            path: '/profile/edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
            jobRequestsProvider.overrideWith((ref) => Stream.value(const [])),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Tap 'Switch to Customer' AppBar button
      await tester.tap(find.byTooltip('Switch to Customer'));
      await tester.pumpAndSettle();

      expect(fakeAuthRepository.currentUser?.role, AppUserRole.customer);
      expect(
        fakeProfileRepository.getProfile('test_user_001')?.role,
        AppUserRole.customer,
      );

      // Tap 'Edit Profile' AppBar button
      await tester.tap(find.byTooltip('Edit Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
    });

    testWidgets(
        'RoleSelectionScreen persists selected role and navigates for authenticated user',
        (tester) async {
      fakeAuthRepository.currentUser =
          mechanicUser.copyWith(role: AppUserRole.customer);
      fakeProfileRepository.seedProfile(
        kTestUserProfile.copyWith(role: AppUserRole.customer),
      );

      final router = GoRouter(
        initialLocation: '/role-selection',
        routes: [
          GoRoute(
            path: '/role-selection',
            builder: (context, state) => const RoleSelectionScreen(),
          ),
          GoRoute(
            path: '/mechanic/home',
            builder: (context, state) =>
                const Scaffold(body: Text('Mechanic Home Destination')),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                const Scaffold(body: Text('Customer Home Destination')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      final mechanicCard = find.text('Mechanic');
      await tester.ensureVisible(mechanicCard);
      await tester.tap(mechanicCard);
      await tester.pumpAndSettle();

      expect(fakeAuthRepository.currentUser?.role, AppUserRole.mechanic);
      expect(
        fakeProfileRepository.getProfile('test_user_001')?.role,
        AppUserRole.mechanic,
      );
      expect(find.text('Mechanic Home Destination'), findsOneWidget);
    });

    testWidgets(
        'RoleSelectionScreen stays on screen and surfaces error SnackBar when updateRole fails',
        (tester) async {
      fakeProfileRepository.customError = const PostgrestException(
        message: 'role update denied by RLS policy',
        code: '42501',
      );

      final router = GoRouter(
        initialLocation: '/role-selection',
        routes: [
          GoRoute(
            path: '/role-selection',
            builder: (context, state) => const RoleSelectionScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                const Scaffold(body: Text('Customer Home Destination')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepository),
            profileRepositoryProvider.overrideWithValue(fakeProfileRepository),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      final customerCard = find.text('Customer');
      await tester.ensureVisible(customerCard);
      await tester.tap(customerCard);
      await tester.pumpAndSettle();

      expect(find.byType(RoleSelectionScreen), findsOneWidget);
      expect(find.text('Customer Home Destination'), findsNothing);
      expect(
        find.textContaining('role update denied by RLS policy'),
        findsOneWidget,
      );
    });
  });
}
