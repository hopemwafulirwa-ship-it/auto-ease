// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_am_on_the_login_screen.dart';
import './step/i_enter_testexamplecom_into_the_email_field.dart';
import './step/i_enter_password123_into_the_password_field.dart';
import './step/i_tap_the_login_button.dart';
import './step/i_should_see_the_home_screen.dart';

void main() {
  group('''Login''', () {
    testWidgets('''Successful login''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnTheLoginScreen(tester);
      await iEnterTestexamplecomIntoTheEmailField(tester);
      await iEnterPassword123IntoThePasswordField(tester);
      await iTapTheLoginButton(tester);
      await iShouldSeeTheHomeScreen(tester);
    });
  });
}
