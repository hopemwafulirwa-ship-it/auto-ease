import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/features/profile/application/profile_controller.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 20),
            ),
            onPressed: () {
              context.push('/profile/edit');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // User Avatar and Name
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          profile.email.isNotEmpty
                              ? profile.email[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Alex Johnson', // Mock Name
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Personal Information Section
              _buildSectionHeader(context, 'Personal Information'),
              const SizedBox(height: 12),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildListTile(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: profile.email,
                    ),
                    Divider(
                      height: 1,
                      indent: 56,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      subtitle: profile.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Section
              _buildSectionHeader(context, 'Settings'),
              const SizedBox(height: 12),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: const Text('Notifications'),
                      subtitle: const Text('Receive booking reminders'),
                      value: profile.notificationsEnabled,
                      onChanged: (value) {
                        ref
                            .read(profileControllerProvider.notifier)
                            .toggleNotifications(value);
                      },
                    ),
                    Divider(
                      height: 1,
                      indent: 56,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.dark_mode_outlined,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Enable dark theme'),
                      value: profile.darkModeEnabled,
                      onChanged: (value) {
                        ref
                            .read(profileControllerProvider.notifier)
                            .toggleDarkMode(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader(context, 'About'),
              const SizedBox(height: 12),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildListTile(
                      context,
                      icon: Icons.info_outlined,
                      title: 'App Version',
                      subtitle: '1.0.0',
                    ),
                    Divider(
                      height: 1,
                      indent: 56,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.policy_outlined,
                      title: 'Privacy Policy',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      indent: 56,
                      color: colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              FilledButton.icon(
                onPressed: () {
                  _showLogoutDialog(context, ref);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(profileControllerProvider.notifier).logout();
              Navigator.pop(context);
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
