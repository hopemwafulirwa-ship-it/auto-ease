import 'package:flutter_test/flutter_test.dart';
import './the_app_is_running.dart';

/// Usage: I am on the register screen
Future<void> iAmOnTheRegisterScreen(WidgetTester tester) async {
  await pumpAuthTestApp(tester, initialLocation: '/register');
}
