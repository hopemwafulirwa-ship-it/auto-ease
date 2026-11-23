import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

import '../../helpers/test_data.dart';

void main() {
  group('UserProfile', () {
    test('has correct default values including customer role', () {
      const profile = UserProfile(
        id: 'test',
        name: 'Test',
        email: 'test@test.com',
        phone: '123',
      );

      expect(profile.avatarUrl, isNull);
      expect(profile.role, AppUserRole.customer);
      expect(profile.notificationsEnabled, isTrue);
      expect(profile.darkModeEnabled, isFalse);
    });

    test('constructor sets all fields correctly', () {
      expect(kTestUserProfile.id, 'test_user_001');
      expect(kTestUserProfile.name, 'Jane Test');
      expect(kTestUserProfile.email, 'jane@test.com');
      expect(kTestUserProfile.phone, '+1 555-000-1234');
      expect(kTestUserProfile.avatarUrl, isNull);
      expect(kTestUserProfile.role, AppUserRole.customer);
      expect(kTestUserProfile.notificationsEnabled, isTrue);
      expect(kTestUserProfile.darkModeEnabled, isFalse);
    });

    test('copyWith preserves all fields when none are specified', () {
      final copy = kTestUserProfile.copyWith();

      expect(copy, equals(kTestUserProfile));
      expect(copy.hashCode, equals(kTestUserProfile.hashCode));
    });

    test('copyWith updates only specified fields including role', () {
      final copy = kTestUserProfile.copyWith(
        name: 'Updated Name',
        role: AppUserRole.mechanic,
        darkModeEnabled: true,
      );

      expect(copy.name, 'Updated Name');
      expect(copy.role, AppUserRole.mechanic);
      expect(copy.darkModeEnabled, isTrue);

      expect(copy.id, kTestUserProfile.id);
      expect(copy.email, kTestUserProfile.email);
      expect(copy.phone, kTestUserProfile.phone);
      expect(copy.notificationsEnabled, kTestUserProfile.notificationsEnabled);
      expect(copy == kTestUserProfile, isFalse);
    });

    test('copyWith can set avatarUrl and update all fields', () {
      final copy = kTestUserProfile.copyWith(
        id: 'new_id',
        name: 'New Name',
        email: 'new@test.com',
        phone: '+1 999-000-0000',
        avatarUrl: 'https://example.com/new.jpg',
        role: AppUserRole.mechanic,
        notificationsEnabled: false,
        darkModeEnabled: true,
      );

      expect(copy.id, 'new_id');
      expect(copy.name, 'New Name');
      expect(copy.email, 'new@test.com');
      expect(copy.phone, '+1 999-000-0000');
      expect(copy.avatarUrl, 'https://example.com/new.jpg');
      expect(copy.role, AppUserRole.mechanic);
      expect(copy.notificationsEnabled, isFalse);
      expect(copy.darkModeEnabled, isTrue);
    });

    test('fromJson and toJson serialize role and dual name/full_name keys', () {
      final json = {
        'id': 'mech_001',
        'full_name': 'Alex Mechanic',
        'email': 'alex@autoease.com',
        'phone': '+1 555-222-3333',
        'avatar_url': 'https://example.com/alex.png',
        'role': 'mechanic',
        'notifications_enabled': false,
        'dark_mode_enabled': true,
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.id, 'mech_001');
      expect(profile.name, 'Alex Mechanic');
      expect(profile.email, 'alex@autoease.com');
      expect(profile.phone, '+1 555-222-3333');
      expect(profile.avatarUrl, 'https://example.com/alex.png');
      expect(profile.role, AppUserRole.mechanic);
      expect(profile.notificationsEnabled, isFalse);
      expect(profile.darkModeEnabled, isTrue);

      final output = profile.toJson();
      expect(output['name'], 'Alex Mechanic');
      expect(output['full_name'], 'Alex Mechanic');
      expect(output['email'], 'alex@autoease.com');
      expect(output['phone'], '+1 555-222-3333');
      expect(output['avatar_url'], 'https://example.com/alex.png');
      expect(output['role'], 'mechanic');
      expect(output['notifications_enabled'], isFalse);
      expect(output['dark_mode_enabled'], isTrue);
    });

    test('fromJson defaults unknown or null role to AppUserRole.customer', () {
      final profile = UserProfile.fromJson({
        'id': 'u_1',
        'name': 'Fallback User',
        'email': 'fallback@test.com',
        'role': 'invalid_role',
      });

      expect(profile.role, AppUserRole.customer);
      expect(profile.toString(), contains('role: AppUserRole.customer'));
    });
  });
}
