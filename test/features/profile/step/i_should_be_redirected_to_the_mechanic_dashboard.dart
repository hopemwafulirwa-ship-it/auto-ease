import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldBeRedirectedToTheMechanicDashboard(
  WidgetTester tester,
) async {
  expect(find.text('Mechanic Dashboard'), findsOneWidget);
}
