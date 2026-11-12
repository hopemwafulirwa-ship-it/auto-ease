import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/auth/presentation/register_screen.dart';

import '../helpers/fake_auth_repository.dart';

void main() {
  group('RegisterScreen Widget Tests (Story 1.1)', () {
    late FakeAuthRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeAuthRepository();
    });

    tearDown(() {
      fakeRepo.dispose();
    });

    Widget buildSubject() {
      return ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      );
    }

    testWidgets('displays validation errors when submitting empty/invalid form',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);

      // Enter invalid email and short password
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Jane');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'), 'invalid-email');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), '123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'), '456');

      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('allows selecting Mechanic role and submits role metadata',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Mike Mechanic');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'),
          'mike@garage.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          'password123');

      final mechanicCard = find.text('Mechanic');
      await tester.ensureVisible(mechanicCard);
      await tester.tap(mechanicCard);
      await tester.pumpAndSettle();

      final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(fakeRepo.lastSignUpName, 'Mike Mechanic');
      expect(fakeRepo.lastSignUpEmail, 'mike@garage.com');
      expect(fakeRepo.lastSignUpPassword, 'password123');
      expect(fakeRepo.lastSignUpRole, AppUserRole.mechanic);
    });

    testWidgets('displays error SnackBar when registration fails',
        (tester) async {
      fakeRepo.shouldFail = true;
      fakeRepo.failureMessage = 'An account with this email already exists';

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'Jane');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'),
          'jane@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          'password123');

      final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(
        find.text('An account with this email already exists'),
        findsOneWidget,
      );
    });
  });
}
