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
    
    return AppUser(
      uid: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
      role: role,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['id'] as String,
      email: json['email'] as String? ?? '', // Email might be in auth.users, not profiles
      name: json['name'] as String?,
      role: (json['role'] as String?) == 'mechanic' ? AppUserRole.mechanic : AppUserRole.customer,
    );
  }

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, name: $name, role: $role)';
}
