import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iTapTheEditProfileButton(WidgetTester tester) async {
  final editIcon = find.byIcon(Icons.edit);
  await tester.tap(editIcon);
  await tester.pumpAndSettle();
}
