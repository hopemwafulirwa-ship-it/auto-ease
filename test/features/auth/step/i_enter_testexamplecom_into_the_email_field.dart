import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "test@example.com" into the email field
Future<void> iEnterTestexamplecomIntoTheEmailField(WidgetTester tester) async {
  final emailField = find.widgetWithText(TextFormField, 'Email Address');
  await tester.enterText(emailField, 'test@example.com');
  await tester.pump();
}
