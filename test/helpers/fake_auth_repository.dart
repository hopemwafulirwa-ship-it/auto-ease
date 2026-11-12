import 'dart:async';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';

class FakeAuthRepository implements AuthRepository {
  final _authStateController = StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;
  bool shouldFail = false;
  String failureMessage = 'Authentication failed';

  String? lastSignInEmail;
  String? lastSignInPassword;
  String? lastSignUpEmail;
  String? lastSignUpPassword;
  String? lastSignUpName;
  AppUserRole? lastSignUpRole;
  bool signOutCalled = false;

  FakeAuthRepository({AppUser? initialUser}) : _currentUser = initialUser;

  set currentUser(AppUser? user) {
    _currentUser = user;
    if (!_authStateController.isClosed) {
      _authStateController.add(user);
    }
  }

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() =>
      _authStateController.stream.distinct();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (shouldFail) {
      throw Exception(failureMessage);
    }
    lastSignInEmail = email;
    lastSignInPassword = password;
    _currentUser = AppUser(
      uid: 'uid-1',
      email: email,
      name: 'Test User',
      role: _currentUser?.role ?? AppUserRole.customer,
    );
    if (!_authStateController.isClosed) {
      _authStateController.add(_currentUser);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    AppUserRole role = AppUserRole.customer,
  }) async {
    if (shouldFail) {
      throw Exception(failureMessage);
    }
    lastSignUpEmail = email;
    lastSignUpPassword = password;
    lastSignUpName = name;
    lastSignUpRole = role;
    _currentUser = AppUser(
      uid: 'uid-2',
      email: email,
      name: name,
      role: role,
    );
    if (!_authStateController.isClosed) {
      _authStateController.add(_currentUser);
    }
  }

  @override
  Future<AppUser?> fetchUserProfile(String id) async => _currentUser;

  @override
  Future<void> signOut() async {
    if (shouldFail) {
      throw Exception(failureMessage);
    }
    signOutCalled = true;
    _currentUser = null;
    if (!_authStateController.isClosed) {
      _authStateController.add(null);
    }
  }

  void dispose() {
    if (!_authStateController.isClosed) {
      _authStateController.close();
    }
  }
}

