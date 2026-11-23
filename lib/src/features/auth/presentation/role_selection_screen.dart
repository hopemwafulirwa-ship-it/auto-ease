import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/common/utils/async_value_ui.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';
import 'package:auto_ease/src/features/auth/domain/app_user.dart';
import 'package:auto_ease/src/features/profile/application/profile_controller.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(
    BuildContext context,
    WidgetRef ref,
    AppUserRole role,
  ) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser != null) {
      await ref.read(profileControllerProvider.notifier).updateRole(role);
      if (!context.mounted) return;
      if (ref.read(profileControllerProvider).hasError) return;
    }
    if (context.mounted) {
      context.go(role == AppUserRole.mechanic ? '/mechanic/home' : '/home');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<UserProfile>>(
      profileControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.car_repair,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to AutoEase',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select your role to continue',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildCustomerCard(
                                context,
                                ref,
                                colorScheme,
                                theme,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildMechanicCard(
                                context,
                                ref,
                                colorScheme,
                                theme,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildCustomerCard(
                              context,
                              ref,
                              colorScheme,
                              theme,
                            ),
                            const SizedBox(height: 20),
                            _buildMechanicCard(
                              context,
                              ref,
                              colorScheme,
                              theme,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: GlassCard(
        onTap: () => _selectRole(context, ref, AppUserRole.customer),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Customer',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book services and track repairs',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMechanicCard(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: GlassCard(
        onTap: () => _selectRole(context, ref, AppUserRole.mechanic),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_circle_outlined,
                size: 48,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mechanic',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage jobs and track earnings',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
