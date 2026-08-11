import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/auth/presentation/register_screen.dart';

/// Usage: I am on the register screen
Future<void> iAmOnTheRegisterScreen(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
  await tester.pumpAndSettle();
}
