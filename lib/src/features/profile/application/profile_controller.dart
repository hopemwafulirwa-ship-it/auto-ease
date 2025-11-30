import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';
import 'package:auto_ease/src/features/profile/data/mock_user_profile.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  UserProfile build() {
    return kMockUserProfile;
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void toggleDarkMode(bool enabled) {
    state = state.copyWith(darkModeEnabled: enabled);
  }

  void logout() {
    // In a real app, this would clear tokens, navigate to login, etc.
    // For now, we'll just reset to the default profile
    state = kMockUserProfile;
  }
}
