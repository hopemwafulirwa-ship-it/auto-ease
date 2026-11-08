import 'package:flutter_test/flutter_test.dart';
import './the_app_is_running.dart';

/// Usage: I am on the login screen
Future<void> iAmOnTheLoginScreen(WidgetTester tester) async {
  await pumpAuthTestApp(tester, initialLocation: '/login');
}
