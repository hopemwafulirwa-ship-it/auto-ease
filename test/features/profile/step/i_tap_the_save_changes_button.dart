import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iTapTheSaveChangesButton(WidgetTester tester) async {
  final saveButton = find.widgetWithText(FilledButton, 'Save Changes');
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}
