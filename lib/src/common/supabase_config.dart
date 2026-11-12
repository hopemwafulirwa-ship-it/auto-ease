import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://wjwrocuculmcxgzrffgh.supabase.co',
);
const supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'sb_publishable_iD5hLEN00ITwroFvQRxixQ_hSt3Oma5',
);

Future<void>? _supabaseInitFuture;

bool get isSupabaseInitialized {
  try {
    Supabase.instance.client;
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> ensureSupabaseInitialized() {
  if (isSupabaseInitialized) return Future.value();
  return _supabaseInitFuture ??= _initSupabase();
}

Future<void> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    ).timeout(const Duration(seconds: 5));
  } catch (e, st) {
    _supabaseInitFuture = null;
    debugPrint('Supabase initialization warning/timeout: $e\n$st');
  }
}
