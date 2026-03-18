import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  // Mock auth state
  AppUser? _currentUser;
  final _authStateController = StreamController<AppUser?>.broadcast();

  Stream<AppUser?> authStateChanges() => _authStateController.stream;

  AppUser? get currentUser => _currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Mock login logic
    _currentUser = AppUser(
      uid: '123',
      email: email,
      role: AppUserRole.customer,
    );
    _authStateController.add(_currentUser);
  }

  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() => _authStateController.close();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final repo = AuthRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
