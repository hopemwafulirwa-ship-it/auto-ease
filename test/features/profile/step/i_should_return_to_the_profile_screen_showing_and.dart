import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldReturnToTheProfileScreenShowingAnd(
  WidgetTester tester,
  String expectedName,
  String expectedPhone,
) async {
  expect(find.text('Profile'), findsAtLeastNWidgets(1));
  expect(find.text(expectedName), findsOneWidget);
  expect(find.text(expectedPhone), findsOneWidget);
}
