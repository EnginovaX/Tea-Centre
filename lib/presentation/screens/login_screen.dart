import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailMode = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthentication() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      if (_isEmailMode) {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        if (email.isEmpty || password.isEmpty) {
          setState(() {
            _errorMessage = 'Please enter email and password';
          });
          return;
        }
        await ref.read(authProvider.notifier).signInWithEmailPassword(email, password);
      } else {
        final phone = _phoneController.text.trim();
        if (phone.isEmpty) {
          setState(() {
            _errorMessage = 'Please enter your phone number';
          });
          return;
        }
        await ref.read(authProvider.notifier).sendOtp(phone);
        if (mounted) {
          context.push(AppRoutes.otp);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEmailMode ? 'Welcome Back' : 'Sign In',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _isEmailMode
                    ? 'Enter your email credentials to login'
                    : 'Enter your phone number to receive an OTP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (!_isEmailMode)
                AppTextField(
                  controller: _phoneController,
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0, right: 8.0),
                        child: Text('+91', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(height: 24, width: 1, color: Colors.grey.shade300),
                      const SizedBox(width: 8),
                    ],
                  ),
                )
              else ...[
                AppTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                ),
              ],
              const SizedBox(height: 24),
              AppButton(
                label: _isEmailMode ? 'Log In' : 'Get OTP',
                onPressed: _handleAuthentication,
                fullWidth: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Or connect via '),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEmailMode = !_isEmailMode;
                      });
                    },
                    child: Text(
                      _isEmailMode ? 'Mobile OTP' : 'Email/Password',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await ref.read(authProvider.notifier).signInWithGoogle();
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                  }
                },
                icon: const Icon(Icons.g_mobiledata, size: 32),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
