import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeTheEstimatedEarnings(WidgetTester tester) async {
  final finder = find.text('\$50.00');
  await tester.scrollUntilVisible(finder, 50.0);
  expect(finder, findsOneWidget);
}
