import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "password123" into the password field
Future<void> iEnterPassword123IntoThePasswordField(WidgetTester tester) async {
  final fields = tester.widgetList<TextFormField>(find.byType(TextFormField)).toList();
  // Password field is typically the third field (after name and email)
  if (fields.length >= 3) {
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.pump();
  }
}
