import 'package:flutter/material.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/widgets/animated_button.dart';
import 'package:auto_ease/src/common/utils/animation_extensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Reset link sent to your email!')),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Auto-dismiss after showing success
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ).fadeInSlideLeft(),
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header Icon
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: colorScheme.primary,
                )
                    .scaleBounce(duration: const Duration(milliseconds: 600))
                    .fadeIn(),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Reset Password',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ).fadeInSlideUp(delay: const Duration(milliseconds: 100)),

                const SizedBox(height: 12),

                // Description
                Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ).fadeInSlideUp(delay: const Duration(milliseconds: 200)),

                const SizedBox(height: 40),

                // Form Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  elevation: 4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading && !_isSuccess,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'your.email@example.com',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: colorScheme.primary,
                            ),
                            suffixIcon: _isSuccess
                                ? Icon(
                                    Icons.check_circle,
                                    color: colorScheme.primary,
                                  )
                                : null,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            // Email validation regex
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                        ).fadeInSlideUp(
                          delay: const Duration(milliseconds: 300),
                        ),

                        const SizedBox(height: 24),

                        // Submit Button
                        AnimatedButton(
                          onPressed: _isSuccess ? null : _sendResetLink,
                          isLoading: _isLoading,
                          child: Text(
                            _isSuccess ? 'Link Sent!' : 'Send Reset Link',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ).fadeInSlideUp(
                          delay: const Duration(milliseconds: 400),
                        ),

                        const SizedBox(height: 16),

                        // Back to Login
                        TextButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text('Back to Login'),
                        ).fadeInSlideUp(
                          delay: const Duration(milliseconds: 500),
                        ),
                      ],
                    ),
                  ),
                ).fadeInSlideUp(delay: const Duration(milliseconds: 300)),

                const SizedBox(height: 32),

                // Help Section
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Didn\'t receive the email? Check your spam folder or try again.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).fadeInSlideUp(delay: const Duration(milliseconds: 600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
