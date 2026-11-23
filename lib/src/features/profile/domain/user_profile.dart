import 'package:auto_ease/src/features/auth/domain/app_user.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final AppUserRole role;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.role = AppUserRole.customer,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    AppUserRole? role,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: (json['full_name'] ?? json['name']) as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      role: AppUserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => AppUserRole.customer,
      ),
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      darkModeEnabled: json['dark_mode_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'full_name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role.name,
      'notifications_enabled': notificationsEnabled,
      'dark_mode_enabled': darkModeEnabled,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.avatarUrl == avatarUrl &&
        other.role == role &&
        other.notificationsEnabled == notificationsEnabled &&
        other.darkModeEnabled == darkModeEnabled;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        email,
        phone,
        avatarUrl,
        role,
        notificationsEnabled,
        darkModeEnabled,
      );

  @override
  String toString() =>
      'UserProfile(id: $id, name: $name, email: $email, phone: $phone, role: $role)';
}
