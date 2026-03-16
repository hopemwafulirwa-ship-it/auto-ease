import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeTheCustomerName(WidgetTester tester) async {
  expect(find.text('John Doe'), findsOneWidget);
}
