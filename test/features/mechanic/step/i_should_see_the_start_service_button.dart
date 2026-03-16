import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeTheStartServiceButton(WidgetTester tester) async {
  final finder = find.text('Start Service');
  await tester.scrollUntilVisible(finder, 50.0);
  expect(finder, findsOneWidget);
}
