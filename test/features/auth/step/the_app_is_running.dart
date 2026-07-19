import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: AutoEaseApp()));
}
