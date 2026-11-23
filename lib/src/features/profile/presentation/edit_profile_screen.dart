import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/common/utils/async_value_ui.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/features/profile/application/profile_controller.dart';
import 'package:auto_ease/src/features/profile/domain/user_profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _avatarUrl;
  bool _isSaving = false;
  bool _initializedFromProfile = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).valueOrNull;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _avatarUrl = profile?.avatarUrl;
    if (profile != null && profile.id.isNotEmpty) {
      _initializedFromProfile = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showAvatarUrlDialog() async {
    final urlController = TextEditingController(text: _avatarUrl ?? '');
    final newUrl = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Avatar URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: 'Avatar URL',
            hintText: 'https://example.com/avatar.png',
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, urlController.text.trim()),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    urlController.dispose();

    if (newUrl != null && mounted) {
      setState(() {
        _avatarUrl = newUrl.isEmpty ? null : newUrl;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);
    await ref.read(profileControllerProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          avatarUrl: _avatarUrl,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    final currentState = ref.read(profileControllerProvider);
    if (currentState.hasError) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    if (context.canPop()) {
      context.pop();
    }
    messenger.showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UserProfile>>(
      profileControllerProvider,
      (previous, next) {
        next.showAlertDialogOnError(context);
        final profile = next.valueOrNull;
        if (!_initializedFromProfile &&
            profile != null &&
            profile.id.isNotEmpty) {
          _initializedFromProfile = true;
          if (_nameController.text.isEmpty) {
            _nameController.text = profile.name;
          }
          if (_phoneController.text.isEmpty) {
            _phoneController.text = profile.phone;
          }
          _avatarUrl ??= profile.avatarUrl;
        }
      },
    );

    final profileAsync = ref.watch(profileControllerProvider);
    final profile = profileAsync.valueOrNull;
    final effectiveAvatarUrl = _avatarUrl ?? profile?.avatarUrl;
    final isSaving = _isSaving || profileAsync.isLoading;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: colorScheme.primaryContainer,
                          backgroundImage: (effectiveAvatarUrl != null &&
                                  effectiveAvatarUrl.isNotEmpty)
                              ? NetworkImage(effectiveAvatarUrl)
                              : null,
                          child: (effectiveAvatarUrl == null ||
                                  effectiveAvatarUrl.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: colorScheme.onPrimaryContainer,
                                )
                              : null,
                        ),
                      ),
                      Semantics(
                        button: true,
                        label: 'Change Avatar',
                        child: InkWell(
                          key: const Key('edit_avatar_button'),
                          onTap: _showAvatarUrlDialog,
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isSaving ? null : _saveProfile,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
