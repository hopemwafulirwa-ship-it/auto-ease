import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';
import 'package:auto_ease/src/common/supabase_config.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  static const String kNetworkErrorMessage =
      'Unable to connect to the server. Please check your internet connection and try again.';

  final SupabaseClient? _injectedSupabase;
  AuthRepository([this._injectedSupabase]);

  SupabaseClient? get _supabaseOrNull {
    if (_injectedSupabase != null) return _injectedSupabase;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<SupabaseClient> _requireClient() async {
    var client = _supabaseOrNull;
    if (client == null) {
      await ensureSupabaseInitialized();
      client = _supabaseOrNull;
    }
    if (client == null) {
      throw Exception(kNetworkErrorMessage);
    }
    return client;
  }

  Stream<AppUser?> authStateChanges() async* {
    var client = _supabaseOrNull;
    if (client == null) {
      await ensureSupabaseInitialized();
      client = _supabaseOrNull;
    }
    if (client == null) return;
    yield* client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? AppUser.fromSupabaseUser(user) : null;
    }).distinct();
  }

  AppUser? get currentUser {
    final client = _supabaseOrNull;
    if (client == null) return null;
    final user = client.auth.currentUser;
    return user != null ? AppUser.fromSupabaseUser(user) : null;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final client = await _requireClient();
      await client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (_isNetworkError(e)) {
        throw Exception(kNetworkErrorMessage);
      }
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
      final client = await _requireClient();
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (name != null) 'name': name,
          if (name != null) 'full_name': name,
          'role': role.name,
        },
      );

      final user = response.user;
      if (user != null) {
        // Persist corresponding record in profiles table with role metadata
        try {
          await client.from('profiles').upsert({
            'id': user.id,
            'email': email,
            'name': name,
            'full_name': name,
            'role': role.name,
            'avatar_url': user.userMetadata?['avatar_url'],
          });
        } on PostgrestException catch (e) {
          debugPrint('Error creating profile: $e');
          if (response.session != null) {
            try {
              await client.auth.signOut();
            } catch (_) {}
          }
          throw Exception('Failed to save user profile: ${e.message}');
        } catch (e) {
          debugPrint('Error creating profile: $e');
          if (response.session != null) {
            try {
              await client.auth.signOut();
            } catch (_) {}
          }
          if (_isNetworkError(e)) {
            throw Exception(kNetworkErrorMessage);
          }
          throw Exception('Failed to save user profile');
        }
      }
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } on Exception catch (e) {
      if (_isNetworkError(e)) {
        throw Exception(kNetworkErrorMessage);
      }
      rethrow;
    } catch (e) {
      if (_isNetworkError(e)) {
        throw Exception(kNetworkErrorMessage);
      }
      throw Exception('An unexpected error occurred during sign up');
    }
  }

  bool _isNetworkError(Object e) {
    if (e is AuthRetryableFetchException) return true;
    final msg = e.toString();
    return msg.contains('SocketException') ||
        msg.contains('ClientException') ||
        msg.contains('Failed host lookup') ||
        msg.contains('Network is unreachable') ||
        msg.contains('Connection refused') ||
        msg.contains('Connection timed out');
  }

  Exception _handleAuthException(AuthException e) {
    if (_isNetworkError(e)) {
      return Exception(kNetworkErrorMessage);
    }
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
      final client = await _requireClient();
      final data =
          await client.from('profiles').select().eq('id', id).maybeSingle();
      return data != null ? AppUser.fromJson(data) : null;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      final client = await _requireClient();
      await client.auth.signOut();
    } catch (e) {
      if (_isNetworkError(e)) {
        throw Exception(kNetworkErrorMessage);
      }
      throw Exception('Error signing out');
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (isSupabaseInitialized) {
    final supabase = ref.watch(supabaseClientProvider);
    return AuthRepository(supabase);
  }
  return AuthRepository();
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
