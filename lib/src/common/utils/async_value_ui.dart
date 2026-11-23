import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(
    BuildContext context, {
    AsyncValue<dynamic>? previous,
  }) {
    if (!isLoading && hasError) {
      if (previous != null &&
          !previous.isLoading &&
          previous.hasError &&
          identical(previous.error, error)) {
        return;
      }
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) {
        return;
      }
      final message = _errorMessage(error);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
    }
  }

  String _errorMessage(Object? error) {
    if (error is PostgrestException) {
      final msg = error.message.trim();
      return msg.isNotEmpty ? msg : 'Database request failed';
    }
    if (error is AuthException) {
      final msg = error.message.trim();
      return msg.isNotEmpty ? msg : 'Authentication error';
    }
    final message = error.toString().trim();
    if (message.startsWith('Exception: ')) {
      final stripped = message.substring(11).trim();
      return stripped.isNotEmpty ? stripped : 'An unexpected error occurred';
    }
    return message.isNotEmpty ? message : 'An unexpected error occurred';
  }
}

