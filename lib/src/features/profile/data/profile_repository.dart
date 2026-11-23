import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository(this._supabase);

  Stream<UserProfile> watchProfile(AppUser user) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.uid)
        .map(
          (data) => data.isEmpty
              ? UserProfile(
                  id: user.uid,
                  name: user.name ?? '',
                  email: user.email,
                  phone: '',
                  role: user.role,
                )
              : UserProfile.fromJson(data.first),
        );
  }

  Future<UserProfile> updateProfile({
    required String uid,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    AppUserRole? role,
  }) async {
    final updates = <String, dynamic>{
      if (name != null) 'name': name,
      if (name != null) 'full_name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (darkModeEnabled != null) 'dark_mode_enabled': darkModeEnabled,
      if (role != null) 'role': role.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    final data = await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', uid)
        .select()
        .single();

    return UserProfile.fromJson(data);
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileRepository(supabase);
}
