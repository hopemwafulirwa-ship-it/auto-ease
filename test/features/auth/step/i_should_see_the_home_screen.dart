import 'package:flutter_test/flutter_test.dart';

/// Usage: I should see the home screen
Future<void> iShouldSeeTheHomeScreen(WidgetTester tester) async {
  // Check for common home screen elements - adjust based on actual home screen implementation
  final homeIndicator = find.textContaining('AutoEase');
  expect(homeIndicator, findsWidgets);
}
