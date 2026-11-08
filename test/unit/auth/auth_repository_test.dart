import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

void main() {
  group('AppUser & Profile Serialization (Story 1.1)', () {
    test('AppUser.fromSupabaseUser maps customer role by default', () {
      const supabaseUser = User(
        id: 'user-123',
        appMetadata: {},
        userMetadata: {'name': 'Alice Customer'},
        aud: 'authenticated',
        email: 'alice@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );

      final appUser = AppUser.fromSupabaseUser(supabaseUser);

      expect(appUser.uid, 'user-123');
      expect(appUser.email, 'alice@example.com');
      expect(appUser.name, 'Alice Customer');
      expect(appUser.role, AppUserRole.customer);
    });

    test('AppUser.fromSupabaseUser maps mechanic role from userMetadata', () {
      const supabaseUser = User(
        id: 'mech-456',
        appMetadata: {},
        userMetadata: {'full_name': 'Bob Mechanic', 'role': 'mechanic'},
        aud: 'authenticated',
        email: 'bob@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );

      final appUser = AppUser.fromSupabaseUser(supabaseUser);

      expect(appUser.uid, 'mech-456');
      expect(appUser.email, 'bob@example.com');
      expect(appUser.name, 'Bob Mechanic');
      expect(appUser.role, AppUserRole.mechanic);
    });

    test('AppUser.fromJson and toJson preserve both name and full_name keys',
        () {
      final json = {
        'id': 'user-789',
        'email': 'charlie@example.com',
        'full_name': 'Charlie Tech',
        'role': 'mechanic',
      };

      final appUser = AppUser.fromJson(json);
      expect(appUser.uid, 'user-789');
      expect(appUser.email, 'charlie@example.com');
      expect(appUser.name, 'Charlie Tech');
      expect(appUser.role, AppUserRole.mechanic);

      final serialized = appUser.toJson();
      expect(serialized['id'], 'user-789');
      expect(serialized['email'], 'charlie@example.com');
      expect(serialized['name'], 'Charlie Tech');
      expect(serialized['full_name'], 'Charlie Tech');
      expect(serialized['role'], 'mechanic');
    });

    test('UserProfile.fromJson accepts either full_name or name from profiles',
        () {
      final fromNameKey = UserProfile.fromJson({
        'id': 'u1',
        'name': 'Name From Auth',
        'email': 'auth@example.com',
      });
      expect(fromNameKey.name, 'Name From Auth');
      expect(fromNameKey.email, 'auth@example.com');

      final fromFullNameKey = UserProfile.fromJson({
        'id': 'u2',
        'full_name': 'Full Name From Profile',
        'email': 'profile@example.com',
      });
      expect(fromFullNameKey.name, 'Full Name From Profile');
    });
  });
}

