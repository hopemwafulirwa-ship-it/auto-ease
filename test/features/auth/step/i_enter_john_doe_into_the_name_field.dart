import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "John Doe" into the name field
Future<void> iEnterJohnDoeIntoTheNameField(WidgetTester tester) async {
  final nameField = find.widgetWithText(TextFormField, 'Full Name');
  await tester.enterText(nameField, 'John Doe');
  await tester.pump();
}
