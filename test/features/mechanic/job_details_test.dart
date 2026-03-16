// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_am_on_the_job_details_screen_with_a_pending_job.dart';
import './step/i_should_see_the_customer_name.dart';
import './step/i_should_see_the_vehicle_info.dart';
import './step/i_should_see_the_estimated_earnings.dart';
import './step/i_should_see_pending_acceptance_text.dart';
import './step/i_am_on_the_job_details_screen_with_an_accepted_job.dart';
import './step/i_should_see_the_start_service_button.dart';
import './step/i_am_on_the_job_details_screen_with_an_inprogress_job.dart';
import './step/i_should_see_the_mark_as_complete_button.dart';

void main() {
  group('''Mechanic Job Details''', () {
    testWidgets('''Viewing a pending job''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnTheJobDetailsScreenWithAPendingJob(tester);
      await iShouldSeeTheCustomerName(tester);
      await iShouldSeeTheVehicleInfo(tester);
      await iShouldSeeTheEstimatedEarnings(tester);
      await iShouldSeePendingAcceptanceText(tester);
    });
    testWidgets('''Viewing an accepted job''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnTheJobDetailsScreenWithAnAcceptedJob(tester);
      await iShouldSeeTheStartServiceButton(tester);
    });
    testWidgets('''Viewing an in-progress job''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnTheJobDetailsScreenWithAnInprogressJob(tester);
      await iShouldSeeTheMarkAsCompleteButton(tester);
    });
  });
}
