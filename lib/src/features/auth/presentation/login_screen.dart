import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:auto_ease/src/features/auth/application/auth_controller.dart';
import 'package:auto_ease/src/common/utils/async_value_ui.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Premium Gradient & Glassmorphism
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                    colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
                  Positioned(
                    bottom: 40,
                    left: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ).animate().scale(duration: 1000.ms, delay: 200.ms, curve: Curves.easeOutBack),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.car_repair_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(duration: 600.ms).scale(curve: Curves.elasticOut),
                        const SizedBox(height: 24),
                        Text(
                          'AutoEase',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                        const SizedBox(height: 8),
                        Text(
                          'Your vehicle, our priority',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.1),
                    const SizedBox(height: 32),
                    
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'name@example.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !state.isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!value.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 20),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                      textInputAction: TextInputAction.done,
                      enabled: !state.isLoading,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 12),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: state.isLoading ? null : () => context.push('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                    
                    const SizedBox(height: 32),
                    
                    // Login Button
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: state.isLoading ? null : _submit,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ).animate().fadeIn(delay: 1100.ms).scale(curve: Curves.easeOutBack),
                    
                    const SizedBox(height: 40),
                    
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: colorScheme.outlineVariant)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.outline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: colorScheme.outlineVariant)),
                      ],
                    ).animate().fadeIn(delay: 1200.ms),
                    
                    const SizedBox(height: 32),
                    
                    // Social Logins
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isLoading ? null : () {},
                            icon: Image.network(
                              'https://www.gstatic.com/images/branding/product/1x/gsa_512dp.png',
                              height: 24,
                            ),
                            label: const Text('Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.isLoading ? null : () {},
                            icon: const Icon(Icons.apple, size: 26, color: Colors.black),
                            label: const Text('Apple'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1300.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 40),
                    
                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: state.isLoading ? null : () => context.push('/register'),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 1400.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

