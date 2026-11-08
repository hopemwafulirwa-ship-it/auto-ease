import 'package:supabase_flutter/supabase_flutter.dart';

enum AppUserRole {
  customer,
  mechanic,
}

class AppUser {
  final String uid;
  final String email;
  final String? name;
  final AppUserRole role;

  const AppUser({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
  });

  factory AppUser.fromSupabaseUser(User user) {
    final roleValue = user.userMetadata?['role'] as String?;
    final role = roleValue == 'mechanic' ? AppUserRole.mechanic : AppUserRole.customer;
    final name = (user.userMetadata?['name'] ?? user.userMetadata?['full_name']) as String?;

    return AppUser(
      uid: user.id,
      email: user.email ?? '',
      name: name,
      role: role,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: (json['full_name'] ?? json['name']) as String?,
      role: (json['role'] as String?) == 'mechanic' ? AppUserRole.mechanic : AppUserRole.customer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'name': name,
      'full_name': name,
      'role': role.name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.role == role;
  }

  @override
  int get hashCode => Object.hash(uid, email, name, role);

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, name: $name, role: $role)';
}
