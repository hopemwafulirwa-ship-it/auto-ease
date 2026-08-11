import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the "Sign Up" button
Future<void> iTapTheSignUpButton(WidgetTester tester) async {
  final signUpButton = find.text('Sign Up');
  expect(signUpButton, findsOneWidget);
  await tester.tap(signUpButton);
  await tester.pumpAndSettle();
}
