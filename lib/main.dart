import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/routing/app_router.dart';
import 'package:auto_ease/src/common/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: AutoEaseApp()));
}

class AutoEaseApp extends ConsumerWidget {
  const AutoEaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'AutoEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: goRouter,
    );
  }
}
