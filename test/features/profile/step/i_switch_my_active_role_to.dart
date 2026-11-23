import 'package:flutter_test/flutter_test.dart';

Future<void> iSwitchMyActiveRoleTo(
  WidgetTester tester,
  String roleLabel,
) async {
  final roleButton = find.text(roleLabel);
  await tester.ensureVisible(roleButton);
  await tester.pumpAndSettle();
  await tester.tap(roleButton);
  await tester.pumpAndSettle();
}
