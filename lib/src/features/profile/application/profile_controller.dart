import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  bool _isMutating = false;

  @override
  Stream<UserProfile> build() {
    _isMutating = false;
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

  Future<void> _guardMutation(Future<UserProfile> Function() action) async {
    if (_isMutating) return;
    _isMutating = true;
    final previousState = state;
    state = const AsyncLoading<UserProfile>().copyWithPrevious(previousState);
    try {
      final updated = await action();
      state = AsyncData<UserProfile>(updated);
    } catch (e, st) {
      state = AsyncError<UserProfile>(e, st).copyWithPrevious(previousState);
    } finally {
      _isMutating = false;
    }
  }

  AppUser _requireAuthenticatedUser() {
    final user = _currentUser;
    if (user == null) {
      throw const AuthException('User session expired. Please sign in again.');
    }
    return user;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) async {
    final previousProfile = state.valueOrNull;

    await _guardMutation(() async {
      final user = _requireAuthenticatedUser();
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            name: name,
            email: email,
            phone: phone,
            avatarUrl: avatarUrl,
          );
      if (name != null || avatarUrl != null) {
        try {
          await ref.read(authRepositoryProvider).updateUserMetadata(
                name: name,
                avatarUrl: avatarUrl,
              );
        } catch (e, st) {
          if (previousProfile != null) {
            try {
              await ref.read(profileRepositoryProvider).updateProfile(
                    uid: user.uid,
                    name: previousProfile.name,
                    avatarUrl: previousProfile.avatarUrl,
                  );
              await Future<void>.delayed(Duration.zero);
            } catch (_) {
              // Best-effort rollback if network dropped completely
            }
          }
          Error.throwWithStackTrace(e, st);
        }
      }
      return updated;
    });
  }

  Future<void> toggleNotifications(bool enabled) async {
    await _guardMutation(() async {
      final user = _requireAuthenticatedUser();
      return await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            notificationsEnabled: enabled,
          );
    });
  }

  Future<void> toggleDarkMode(bool enabled) async {
    await _guardMutation(() async {
      final user = _requireAuthenticatedUser();
      return await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            darkModeEnabled: enabled,
          );
    });
  }

  Future<void> updateRole(AppUserRole role) async {
    final previousProfileRole = state.valueOrNull?.role;

    await _guardMutation(() async {
      final user = _requireAuthenticatedUser();
      final previousRole = previousProfileRole ?? user.role;
      final updated = await ref.read(profileRepositoryProvider).updateProfile(
            uid: user.uid,
            role: role,
          );
      try {
        await ref.read(authRepositoryProvider).updateUserMetadata(role: role);
      } catch (e, st) {
        try {
          await ref.read(profileRepositoryProvider).updateProfile(
                uid: user.uid,
                role: previousRole,
              );
          await Future<void>.delayed(Duration.zero);
        } catch (_) {
          // Best-effort rollback if network dropped completely
        }
        Error.throwWithStackTrace(e, st);
      }
      return updated;
    });
  }

  Future<void> logout() async {
    await _guardMutation(() async {
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
