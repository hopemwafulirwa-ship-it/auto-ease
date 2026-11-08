import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "password123" into the confirm password field
Future<void> iEnterPassword123IntoTheConfirmPasswordField(
    WidgetTester tester) async {
  final confirmField = find.widgetWithText(TextFormField, 'Confirm Password');
  await tester.enterText(confirmField, 'password123');
  await tester.pump();
}
