import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  AuthRepository(this._supabase);

  Stream<AppUser?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? AppUser.fromSupabaseUser(user) : null;
    });
  }

  AppUser? get currentUser {
    final user = _supabase.auth.currentUser;
    return user != null ? AppUser.fromSupabaseUser(user) : null;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred during sign in');
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    AppUserRole role = AppUserRole.customer,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          if (name != null) 'name': name,
          'role': role.name,
        },
      );

      final user = response.user;
      if (user != null) {
        // Create profile entry
        try {
          await _supabase.from('profiles').insert({
            'id': user.id,
            'name': name,
            'role': role.name,
            'avatar_url': user.userMetadata?['avatar_url'],
          });
        } catch (e) {
          // If profile creation fails, we might want to log it or handle it
          // but the user is already created in auth.users
          debugPrint('Error creating profile: $e');
        }
      }
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred during sign up');
    }
  }

  Exception _handleAuthException(AuthException e) {
    if (e.message.contains('Invalid login credentials')) {
      return Exception('Invalid email or password');
    }
    if (e.message.contains('User already registered')) {
      return Exception('An account with this email already exists');
    }
    if (e.message.contains('Email not confirmed')) {
      return Exception('Please confirm your email address');
    }
    return Exception(e.message);
  }

  Future<AppUser?> fetchUserProfile(String id) async {
    try {
      final data = await _supabase.from('profiles').select().eq('id', id).single();
      return AppUser.fromJson(data);
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Error signing out');
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabase);
}


@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
