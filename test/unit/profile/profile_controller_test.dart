import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/features/profile/application/profile_controller.dart';
import 'package:auto_ease/src/features/profile/data/mock_user_profile.dart';

import '../../helpers/create_container.dart';

void main() {
  group('ProfileController', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state loads mock user profile', () {
      final profile = container.read(profileControllerProvider);

      expect(profile.id, kMockUserProfile.id);
      expect(profile.name, kMockUserProfile.name);
      expect(profile.email, kMockUserProfile.email);
      expect(profile.phone, kMockUserProfile.phone);
    });

    test('updateProfile updates name', () {
      container
          .read(profileControllerProvider.notifier)
          .updateProfile(name: 'Jane Updated');

      final profile = container.read(profileControllerProvider);

      expect(profile.name, 'Jane Updated');
      // Other fields unchanged
      expect(profile.email, kMockUserProfile.email);
      expect(profile.phone, kMockUserProfile.phone);
    });

    test('updateProfile updates email', () {
      container
          .read(profileControllerProvider.notifier)
          .updateProfile(email: 'new@email.com');

      final profile = container.read(profileControllerProvider);
      expect(profile.email, 'new@email.com');
    });

    test('updateProfile updates phone', () {
      container
          .read(profileControllerProvider.notifier)
          .updateProfile(phone: '+1 555-999-0000');

      final profile = container.read(profileControllerProvider);
      expect(profile.phone, '+1 555-999-0000');
    });

    test('updateProfile updates multiple fields at once', () {
      container.read(profileControllerProvider.notifier).updateProfile(
            name: 'New Name',
            email: 'new@email.com',
            phone: '+1 999-000-1111',
          );

      final profile = container.read(profileControllerProvider);

      expect(profile.name, 'New Name');
      expect(profile.email, 'new@email.com');
      expect(profile.phone, '+1 999-000-1111');
    });

    test('toggleNotifications enables notifications', () {
      // Start by disabling, then enabling
      container
          .read(profileControllerProvider.notifier)
          .toggleNotifications(false);
      container
          .read(profileControllerProvider.notifier)
          .toggleNotifications(true);

      final profile = container.read(profileControllerProvider);
      expect(profile.notificationsEnabled, isTrue);
    });

    test('toggleNotifications disables notifications', () {
      container
          .read(profileControllerProvider.notifier)
          .toggleNotifications(false);

      final profile = container.read(profileControllerProvider);
      expect(profile.notificationsEnabled, isFalse);
    });

    test('toggleDarkMode enables dark mode', () {
      container.read(profileControllerProvider.notifier).toggleDarkMode(true);

      final profile = container.read(profileControllerProvider);
      expect(profile.darkModeEnabled, isTrue);
    });

    test('toggleDarkMode disables dark mode', () {
      container.read(profileControllerProvider.notifier).toggleDarkMode(true);
      container.read(profileControllerProvider.notifier).toggleDarkMode(false);

      final profile = container.read(profileControllerProvider);
      expect(profile.darkModeEnabled, isFalse);
    });

    test('logout resets profile to default', () {
      // Modify the profile first
      container.read(profileControllerProvider.notifier).updateProfile(
            name: 'Modified Name',
            email: 'modified@email.com',
          );
      container.read(profileControllerProvider.notifier).toggleDarkMode(true);

      // Now logout
      container.read(profileControllerProvider.notifier).logout();

      final profile = container.read(profileControllerProvider);

      expect(profile.name, kMockUserProfile.name);
      expect(profile.email, kMockUserProfile.email);
      expect(profile.darkModeEnabled, kMockUserProfile.darkModeEnabled);
    });
  });
}
