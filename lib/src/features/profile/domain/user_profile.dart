class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      darkModeEnabled: json['dark_mode_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'notifications_enabled': notificationsEnabled,
      'dark_mode_enabled': darkModeEnabled,
    };
  }
}
