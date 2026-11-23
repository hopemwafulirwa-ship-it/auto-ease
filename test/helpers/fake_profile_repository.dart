import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/data/profile_repository.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';
import 'fake_auth_repository.dart';

class FakeProfileRepository implements ProfileRepository {
  final _profileStreamController = StreamController<UserProfile>.broadcast();
  final Map<String, UserProfile> _profiles = {};
  final FakeAuthRepository? authRepository;
  String? authorizedUid;
  bool shouldFail = false;
  Object? customError;

  FakeProfileRepository({
    UserProfile? initialProfile,
    this.authRepository,
    this.authorizedUid,
  }) {
    if (initialProfile != null) {
      _profiles[initialProfile.id] = initialProfile;
    }
  }

  UserProfile? getProfile(String uid) => _profiles[uid];

  void seedProfile(UserProfile profile) {
    _profiles[profile.id] = profile;
    if (!_profileStreamController.isClosed) {
      _profileStreamController.add(profile);
    }
  }

  String? get _effectiveAuthorizedUid =>
      authorizedUid ?? authRepository?.currentUser?.uid;

  @override
  Stream<UserProfile> watchProfile(AppUser user) {
    return Stream<UserProfile>.multi((controller) {
      final existing = _profiles[user.uid] ??
          UserProfile(
            id: user.uid,
            name: user.name ?? '',
            email: user.email,
            phone: '',
            role: user.role,
          );
      _profiles[user.uid] = existing;
      controller.add(existing);

      final sub = _profileStreamController.stream
          .where((profile) => profile.id == user.uid)
          .listen(
            controller.add,
            onError: controller.addError,
          );
      controller.onCancel = sub.cancel;
    });
  }

  @override
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
    if (customError != null) {
      throw customError!;
    }
    if (shouldFail) {
      throw const PostgrestException(
        message: 'Failed to update profile',
        code: '500',
      );
    }

    final activeUid = _effectiveAuthorizedUid;
    if (activeUid != null && uid != activeUid) {
      throw const PostgrestException(
        message:
            'new row violates row-level security policy for table "profiles"',
        code: '42501',
      );
    }

    final current = _profiles[uid] ??
        UserProfile(
          id: uid,
          name: '',
          email: '',
          phone: '',
        );

    final updated = current.copyWith(
      name: name ?? current.name,
      email: email ?? current.email,
      phone: phone ?? current.phone,
      avatarUrl: avatarUrl ?? current.avatarUrl,
      notificationsEnabled:
          notificationsEnabled ?? current.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? current.darkModeEnabled,
      role: role ?? current.role,
    );

    _profiles[uid] = updated;
    if (!_profileStreamController.isClosed) {
      _profileStreamController.add(updated);
    }
    return updated;
  }

  void dispose() {
    if (!_profileStreamController.isClosed) {
      _profileStreamController.close();
    }
  }
}
