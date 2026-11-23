import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Stream<UserProfile> build() {
    final authRepository = ref.watch(authRepositoryProvider);
    final uid = ref.watch(
      authStateChangesProvider.select((authAsync) {
        final user = authAsync.valueOrNull ??
            (authAsync.isLoading ? authRepository.currentUser : null);
        return user?.uid;
      }),
    );

    final authAsync = ref.read(authStateChangesProvider);
    final user = authAsync.valueOrNull ??
        (authAsync.isLoading ? authRepository.currentUser : null);

    if (uid == null || user == null) {
      return Stream.value(
        const UserProfile(
          id: '',
          name: '',
          email: '',
          phone: '',
        ),
      );
    }

    return ref.watch(profileRepositoryProvider).watchProfile(user);
  }

  AppUser? get _currentUser {
    final authAsync = ref.read(authStateChangesProvider);
    return authAsync.valueOrNull ?? ref.read(authRepositoryProvider).currentUser;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    final user = _currentUser;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            name: name,
            email: email,
            phone: phone,
            avatarUrl: avatarUrl,
          );
      if (name != null || avatarUrl != null) {
        await ref.read(authRepositoryProvider).updateUserMetadata(
              name: name,
              avatarUrl: avatarUrl,
            );
      }
      return updated;
    });
  }

  Future<void> toggleNotifications(bool enabled) async {
    final user = _currentUser;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            notificationsEnabled: enabled,
          );
    });
  }

  Future<void> toggleDarkMode(bool enabled) async {
    final user = _currentUser;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            darkModeEnabled: enabled,
          );
    });
  }

  Future<void> updateRole(AppUserRole role) async {
    final user = _currentUser;
    if (user == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            role: role,
          );
      await ref.read(authRepositoryProvider).updateUserMetadata(role: role);
      return updated;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return const UserProfile(
        id: '',
        name: '',
        email: '',
        phone: '',
      );
    });
  }
}
