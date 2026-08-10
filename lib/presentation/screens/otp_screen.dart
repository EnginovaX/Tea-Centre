import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    setState(() {
      _errorMessage = null;
    });

    final code = _otpController.text.trim();
    if (code.length < 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit OTP code';
      });
      return;
    }

    try {
      // In mock/test env we use a placeholder verification ID
      await ref.read(authProvider.notifier).verifyOtp('mock_ver_id', code);
      if (mounted) {
        context.go(AppRoutes.home);
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verification',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit OTP code sent to your phone number',
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
              AppTextField(
                controller: _otpController,
                hintText: 'Enter 6-digit OTP',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.security),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Verify & Continue',
                onPressed: _verifyOtp,
                fullWidth: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive code? "),
                  TextButton(
                    onPressed: () {
                      // Resend logic trigger
                    },
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
