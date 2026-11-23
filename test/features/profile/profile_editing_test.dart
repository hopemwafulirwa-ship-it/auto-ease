// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/i_am_logged_in_as_a_customer_on_the_profile_screen.dart';
import './step/i_tap_the_edit_profile_button.dart';
import './step/i_update_my_full_name_to_and_phone_to.dart';
import './step/i_tap_the_save_changes_button.dart';
import './step/i_should_return_to_the_profile_screen_showing_and.dart';
import './step/i_switch_my_active_role_to.dart';
import './step/i_should_be_redirected_to_the_mechanic_dashboard.dart';

void main() {
  group('''User Profile Editing and Role Switching''', () {
    testWidgets(
        '''Authenticated customer edits profile details and sees updated profile''',
        (tester) async {
      await iAmLoggedInAsACustomerOnTheProfileScreen(tester);
      await iTapTheEditProfileButton(tester);
      await iUpdateMyFullNameToAndPhoneTo(
          tester, 'Jane Updated', '+1 555-999-8888');
      await iTapTheSaveChangesButton(tester);
      await iShouldReturnToTheProfileScreenShowingAnd(
          tester, 'Jane Updated', '+1 555-999-8888');
    });
    testWidgets(
        '''Authenticated customer switches role to Mechanic and is redirected to Mechanic Dashboard''',
        (tester) async {
      await iAmLoggedInAsACustomerOnTheProfileScreen(tester);
      await iSwitchMyActiveRoleTo(tester, 'Mechanic');
      await iShouldBeRedirectedToTheMechanicDashboard(tester);
    });
  });
}
