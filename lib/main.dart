import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/common/supabase_config.dart';
import 'package:auto_ease/src/common/theme/app_theme.dart';
import 'package:auto_ease/src/features/profile/application/profile_controller.dart';
import 'package:auto_ease/src/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(ensureSupabaseInitialized());
  runApp(const ProviderScope(child: AutoEaseApp()));
}

class AutoEaseApp extends ConsumerWidget {
  const AutoEaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final profile = ref.watch(profileControllerProvider).valueOrNull;
    final themeMode = (profile == null || profile.id.isEmpty)
        ? ThemeMode.system
        : (profile.darkModeEnabled ? ThemeMode.dark : ThemeMode.light);

    return MaterialApp.router(
      title: 'AutoEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
