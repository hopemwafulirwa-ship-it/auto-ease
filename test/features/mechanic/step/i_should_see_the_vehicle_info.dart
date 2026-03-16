import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeTheVehicleInfo(WidgetTester tester) async {
  expect(find.text('Toyota Camry 2020'), findsOneWidget);
}
