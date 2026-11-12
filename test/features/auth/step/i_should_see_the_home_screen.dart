import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/auth/presentation/login_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/register_screen.dart';

/// Usage: I should see the home screen
Future<void> iShouldSeeTheHomeScreen(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsNothing);
  expect(find.byType(RegisterScreen), findsNothing);
  expect(find.textContaining('AutoEase Home'), findsOneWidget);
}
