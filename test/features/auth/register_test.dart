// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_am_on_the_register_screen.dart';
import './step/i_enter_john_doe_into_the_name_field.dart';
import './step/i_enter_testexamplecom_into_the_email_field.dart';
import './step/i_enter_password123_into_the_password_field.dart';
import './step/i_enter_password123_into_the_confirm_password_field.dart';
import './step/i_tap_the_sign_up_button.dart';
import './step/i_should_see_the_home_screen.dart';

void main() {
  group('''Register''', () {
    testWidgets('''Successful registration''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnTheRegisterScreen(tester);
      await iEnterJohnDoeIntoTheNameField(tester);
      await iEnterTestexamplecomIntoTheEmailField(tester);
      await iEnterPassword123IntoThePasswordField(tester);
      await iEnterPassword123IntoTheConfirmPasswordField(tester);
      await iTapTheSignUpButton(tester);
      await iShouldSeeTheHomeScreen(tester);
    });
  });
}
