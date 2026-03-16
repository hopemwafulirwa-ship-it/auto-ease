import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

//import '../../../helpers/test_data.dart';
import '../../helpers/test_data.dart';

void main() {
  group('UserProfile', () {
    test('has correct default values', () {
      const profile = UserProfile(
        id: 'test',
        name: 'Test',
        email: 'test@test.com',
        phone: '123',
      );

      expect(profile.avatarUrl, isNull);
      expect(profile.notificationsEnabled, isTrue);
      expect(profile.darkModeEnabled, isFalse);
    });

    test('constructor sets all fields correctly', () {
      expect(kTestUserProfile.id, 'test_user_001');
      expect(kTestUserProfile.name, 'Jane Test');
      expect(kTestUserProfile.email, 'jane@test.com');
      expect(kTestUserProfile.phone, '+1 555-000-1234');
      expect(kTestUserProfile.avatarUrl, isNull);
      expect(kTestUserProfile.notificationsEnabled, isTrue);
      expect(kTestUserProfile.darkModeEnabled, isFalse);
    });

    test('copyWith preserves all fields when none are specified', () {
      final copy = kTestUserProfile.copyWith();

      expect(copy.id, kTestUserProfile.id);
      expect(copy.name, kTestUserProfile.name);
      expect(copy.email, kTestUserProfile.email);
      expect(copy.phone, kTestUserProfile.phone);
      expect(copy.avatarUrl, kTestUserProfile.avatarUrl);
      expect(copy.notificationsEnabled, kTestUserProfile.notificationsEnabled);
      expect(copy.darkModeEnabled, kTestUserProfile.darkModeEnabled);
    });

    test('copyWith updates only specified fields', () {
      final copy = kTestUserProfile.copyWith(
        name: 'Updated Name',
        darkModeEnabled: true,
      );

      // Changed fields
      expect(copy.name, 'Updated Name');
      expect(copy.darkModeEnabled, isTrue);

      // Unchanged fields
      expect(copy.id, kTestUserProfile.id);
      expect(copy.email, kTestUserProfile.email);
      expect(copy.phone, kTestUserProfile.phone);
      expect(copy.notificationsEnabled, kTestUserProfile.notificationsEnabled);
    });

    test('copyWith can set avatarUrl', () {
      final copy = kTestUserProfile.copyWith(
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      expect(copy.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('copyWith can update all fields', () {
      final copy = kTestUserProfile.copyWith(
        id: 'new_id',
        name: 'New Name',
        email: 'new@test.com',
        phone: '+1 999-000-0000',
        avatarUrl: 'https://example.com/new.jpg',
        notificationsEnabled: false,
        darkModeEnabled: true,
      );

      expect(copy.id, 'new_id');
      expect(copy.name, 'New Name');
      expect(copy.email, 'new@test.com');
      expect(copy.phone, '+1 999-000-0000');
      expect(copy.avatarUrl, 'https://example.com/new.jpg');
      expect(copy.notificationsEnabled, isFalse);
      expect(copy.darkModeEnabled, isTrue);
    });
  });
}
