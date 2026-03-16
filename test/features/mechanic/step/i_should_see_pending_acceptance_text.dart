import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeePendingAcceptanceText(WidgetTester tester) async {
  expect(find.text('Pending Acceptance'), findsOneWidget);
}
