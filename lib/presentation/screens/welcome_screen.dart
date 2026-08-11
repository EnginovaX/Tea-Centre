import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to\nTea Centre',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Indulge in our premium traditional Indian cutting chai and steaming hot snacks, served minimum wait time.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Log In with Phone',
                onPressed: () => context.push(AppRoutes.login),
                fullWidth: true,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Sign In with Email',
                type: AppButtonType.outlined,
                onPressed: () => context.push(AppRoutes.register),
                fullWidth: true,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).loginAsGuest();
                  if (context.mounted) {
                    context.go(AppRoutes.home);
                  }
                },
                child: Text(
                  'Explore as Guest',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
