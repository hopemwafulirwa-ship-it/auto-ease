/// Reusable test fixtures for AutoEase unit tests.
///
/// These provide clean, predictable data for testing without relying
/// on the app's mock data (which may change over time).
library;

import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/features/home/domain/service_center_model.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';
import 'package:auto_ease/src/features/mechanic/domain/job_request.dart';

// ─── Booking History Fixtures ────────────────────────────────────────────────

final kTestUpcomingBooking = BookingHistory(
  id: 'test_booking_001',
  serviceCenterId: 'center_001',
  serviceCenterName: 'Test Auto Center',
  services: ['Oil Change', 'Tire Rotation'],
  dateTime: DateTime(2026, 3, 15, 10, 0),
  status: BookingStatus.upcoming,
  totalPrice: 89.99,
  notes: 'Test booking notes',
);

final kTestCompletedBooking = BookingHistory(
  id: 'test_booking_002',
  serviceCenterId: 'center_002',
  serviceCenterName: 'Quick Fix Auto',
  services: ['Brake Inspection'],
  dateTime: DateTime(2026, 1, 10, 14, 0),
  status: BookingStatus.completed,
  totalPrice: 49.99,
);

final kTestCancelledBooking = BookingHistory(
  id: 'test_booking_003',
  serviceCenterId: 'center_003',
  serviceCenterName: 'Elite Motors',
  services: ['Air Conditioning Service'],
  dateTime: DateTime(2026, 1, 5, 9, 0),
  status: BookingStatus.cancelled,
  totalPrice: 99.99,
  notes: 'Cancelled by user',
);

// A second upcoming booking with a later date for sort testing
final kTestUpcomingBooking2 = BookingHistory(
  id: 'test_booking_004',
  serviceCenterId: 'center_001',
  serviceCenterName: 'Test Auto Center',
  services: ['Engine Diagnostic'],
  dateTime: DateTime(2026, 4, 20, 11, 0),
  status: BookingStatus.upcoming,
  totalPrice: 129.99,
);

/// Mixed list of bookings for controller tests
final kTestBookingHistory = [
  kTestUpcomingBooking,
  kTestCompletedBooking,
  kTestCancelledBooking,
  kTestUpcomingBooking2,
];

// ─── Service Center Fixtures ─────────────────────────────────────────────────

const kTestServiceCenters = [
  ServiceCenter(
    id: 'sc_1',
    name: 'AutoFix Pro',
    address: '123 Main St',
    latitude: 37.7749,
    longitude: -122.4194,
    rating: 4.8,
    reviewCount: 124,
    distance: 1.2,
    isOpen: true,
    services: ['Oil Change', 'Brake Repair', 'Tire Rotation'],
    imageUrl: 'https://example.com/img1.jpg',
  ),
  ServiceCenter(
    id: 'sc_2',
    name: 'Budget Brakes',
    address: '456 Oak Ave',
    latitude: 37.7849,
    longitude: -122.4094,
    rating: 3.5,
    reviewCount: 45,
    distance: 5.0,
    isOpen: true,
    services: ['Brake Repair', 'Suspension'],
    imageUrl: 'https://example.com/img2.jpg',
  ),
  ServiceCenter(
    id: 'sc_3',
    name: 'Premium Auto Care',
    address: '789 Luxury Ln',
    latitude: 37.7649,
    longitude: -122.4294,
    rating: 4.9,
    reviewCount: 210,
    distance: 3.8,
    isOpen: false,
    services: ['Detailing', 'Engine Repair'],
    imageUrl: 'https://example.com/img3.jpg',
  ),
  ServiceCenter(
    id: 'sc_4',
    name: 'Quick Lube',
    address: '101 Speed Rd',
    latitude: 37.7549,
    longitude: -122.4394,
    rating: 4.2,
    reviewCount: 89,
    distance: 2.5,
    isOpen: true,
    services: ['Oil Change', 'Inspection'],
    imageUrl: 'https://example.com/img4.jpg',
  ),
];

// ─── User Profile Fixtures ──────────────────────────────────────────────────

const kTestUserProfile = UserProfile(
  id: 'test_user_001',
  name: 'Jane Test',
  email: 'jane@test.com',
  phone: '+1 555-000-1234',
  avatarUrl: null,
  notificationsEnabled: true,
  darkModeEnabled: false,
);

// ─── Job Request Fixtures ───────────────────────────────────────────────────

final kTestPendingJob = JobRequest(
  id: 'job_001',
  customerId: 'c1',
  customerName: 'John Doe',
  customerAvatar: 'https://example.com/avatar.jpg',
  vehicleInfo: 'Toyota Camry 2020',
  services: ['Oil Change', 'Tire Rotation'],
  requestedDateTime: DateTime(2026, 3, 15, 10, 0),
  location: '123 Main St',
  distance: 5.0,
  estimatedEarnings: 50.0,
  status: JobStatus.pending,
  address: '123 Main St, City',
);
