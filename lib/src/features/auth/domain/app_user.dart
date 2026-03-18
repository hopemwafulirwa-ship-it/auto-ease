enum AppUserRole {
  customer,
  mechanic,
}

class AppUser {
  final String uid;
  final String email;
  final AppUserRole role;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, role: $role)';
}
