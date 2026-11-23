import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iUpdateMyFullNameToAndPhoneTo(
  WidgetTester tester,
  String fullName,
  String phone,
) async {
  final nameField = find.widgetWithText(TextFormField, 'Full Name');
  final phoneField = find.widgetWithText(TextFormField, 'Phone Number');

  await tester.enterText(nameField, fullName);
  await tester.enterText(phoneField, phone);
  await tester.pumpAndSettle();
}
