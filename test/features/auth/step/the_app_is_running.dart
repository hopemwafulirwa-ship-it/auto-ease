import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/auth/presentation/login_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/register_screen.dart';

class TestFakeAuthRepository implements AuthRepository {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _currentUser = AppUser(
      uid: 'test-uid-123',
      email: email,
      name: 'Test User',
      role: AppUserRole.customer,
    );
    _controller.add(_currentUser);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    AppUserRole role = AppUserRole.customer,
  }) async {
    _currentUser = AppUser(
      uid: 'test-uid-123',
      email: email,
      name: name,
      role: role,
    );
    _controller.add(_currentUser);
  }

  @override
  Future<AppUser?> fetchUserProfile(String id) async => _currentUser;

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}

Future<void> pumpAuthTestApp(
  WidgetTester tester, {
  required String initialLocation,
}) async {
  final fakeRepo = TestFakeAuthRepository();
  final router = GoRouter(
    initialLocation: initialLocation,
    refreshListenable: _StreamRefreshListenable(fakeRepo.authStateChanges()),
    redirect: (context, state) {
      final isLoggedIn = fakeRepo.currentUser != null;
      final isAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (isLoggedIn && isAuth) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('AutoEase Home')),
        ),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeRepo),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

class _StreamRefreshListenable extends ChangeNotifier {
  _StreamRefreshListenable(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

Future<void> theAppIsRunning(WidgetTester tester) async {
  await pumpAuthTestApp(tester, initialLocation: '/login');
}
