import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Stream<UserProfile> build() {
    final supabase = ref.watch(supabaseClientProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;
    
    if (user == null) {
      return Stream.value(const UserProfile(
        id: '',
        name: '',
        email: '',
        phone: '',
      ));
    }

    return supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.uid)
        .map((data) => data.isEmpty 
            ? UserProfile(id: user.uid, name: user.name ?? '', email: user.email, phone: '')
            : UserProfile.fromJson(data.first));
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    final supabase = ref.read(supabaseClientProvider);
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final updates = {
      if (name != null) 'full_name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    await supabase.from('profiles').update(updates).eq('id', user.uid);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final supabase = ref.read(supabaseClientProvider);
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    await supabase
        .from('profiles')
        .update({'notifications_enabled': enabled})
        .eq('id', user.uid);
  }

  Future<void> toggleDarkMode(bool enabled) async {
    final supabase = ref.read(supabaseClientProvider);
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    await supabase
        .from('profiles')
        .update({'dark_mode_enabled': enabled})
        .eq('id', user.uid);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
