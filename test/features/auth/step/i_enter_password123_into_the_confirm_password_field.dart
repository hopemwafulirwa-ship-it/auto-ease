import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "password123" into the confirm password field
Future<void> iEnterPassword123IntoTheConfirmPasswordField(
    WidgetTester tester) async {
  final fields = tester.widgetList<TextFormField>(find.byType(TextFormField)).toList();
  // Confirm password field is typically the fourth field (after name, email, and password)
  if (fields.length >= 4) {
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.pump();
  }
}
