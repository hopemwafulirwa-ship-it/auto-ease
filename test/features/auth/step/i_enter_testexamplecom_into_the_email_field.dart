import 'package:flutter_test/flutter_test.dart';

/// Usage: I enter "test@example.com" into the email field
Future<void> iEnterTestexamplecomIntoTheEmailField(WidgetTester tester) async {
  final fields = tester.widgetList<TextFormField>(find.byType(TextFormField)).toList();
  // Email field is typically the second field (after name)
  if (fields.length >= 2) {
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.pump();
  }
}
