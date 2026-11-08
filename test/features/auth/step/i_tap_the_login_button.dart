import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the "Login" button
Future<void> iTapTheLoginButton(WidgetTester tester) async {
  final loginButton = find.widgetWithText(FilledButton, 'Login');
  await tester.ensureVisible(loginButton);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}
