import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the "Sign Up" button
Future<void> iTapTheSignUpButton(WidgetTester tester) async {
  final signUpButton = find.widgetWithText(FilledButton, 'Sign Up');
  await tester.ensureVisible(signUpButton);
  await tester.tap(signUpButton);
  await tester.pumpAndSettle();
}
