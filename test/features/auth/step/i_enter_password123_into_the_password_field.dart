import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "password123" into the password field
Future<void> iEnterPassword123IntoThePasswordField(WidgetTester tester) async {
  final passwordField = find.widgetWithText(TextFormField, 'Password');
  await tester.enterText(passwordField, 'password123');
  await tester.pump();
}
