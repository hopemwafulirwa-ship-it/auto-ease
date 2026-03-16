import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeTheMarkAsCompleteButton(WidgetTester tester) async {
  final finder = find.text('Mark as Complete');
  await tester.scrollUntilVisible(finder, 50.0);
  expect(finder, findsOneWidget);
}
