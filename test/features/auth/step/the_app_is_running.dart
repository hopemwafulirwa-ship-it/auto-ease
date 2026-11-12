import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/auth/presentation/login_screen.dart';
import 'package:auto_ease/src/features/auth/presentation/register_screen.dart';

import '../../../helpers/fake_auth_repository.dart';

Future<void> pumpAuthTestApp(
  WidgetTester tester, {
  required String initialLocation,
}) async {
  final fakeRepo = FakeAuthRepository();
  final refreshListenable =
      _StreamRefreshListenable(fakeRepo.authStateChanges());
  final router = GoRouter(
    initialLocation: initialLocation,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final currentUser = fakeRepo.currentUser;
      final isLoggedIn = currentUser != null;
      final isAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      if (!isLoggedIn && !isAuth) {
        return '/login';
      }
      if (isLoggedIn && isAuth) {
        return currentUser.role == AppUserRole.mechanic
            ? '/mechanic/home'
            : '/home';
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
      GoRoute(
        path: '/mechanic/home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Mechanic Dashboard')),
        ),
      ),
    ],
  );

  addTearDown(() {
    refreshListenable.dispose();
    router.dispose();
    fakeRepo.dispose();
  });

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
