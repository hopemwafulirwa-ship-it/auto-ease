import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/mechanic/presentation/job_details_screen.dart';
import 'package:auto_ease/src/features/mechanic/domain/job_request.dart';
import 'package:auto_ease/src/features/mechanic/data/mechanic_repository.dart';
import 'package:network_image_mock/network_image_mock.dart';

Future<void> iAmOnTheJobDetailsScreenWithAPendingJob(
    WidgetTester tester) async {
  final job = JobRequest(
    id: '1',
    customerId: 'c1',
    customerName: 'John Doe',
    customerAvatar: 'https://example.com/avatar.jpg',
    vehicleInfo: 'Toyota Camry 2020',
    services: ['Oil Change', 'Tire Rotation'],
    requestedDateTime: DateTime.now(),
    location: '123 Main St',
    distance: 5.0,
    estimatedEarnings: 50.0,
    status: JobStatus.pending,
    address: '123 Main St, City',
  );

  await mockNetworkImagesFor(() => tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobRequestProvider(job.id).overrideWith((ref) => Stream.value(job)),
          ],
          child: MaterialApp(
            home: JobDetailsScreen(jobId: job.id),
          ),
        ),
      ));
}
