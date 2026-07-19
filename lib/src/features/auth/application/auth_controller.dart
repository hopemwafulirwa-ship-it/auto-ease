import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password),
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          ),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
  }
}
