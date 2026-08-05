import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/app_button.dart';

class OrderSuccessScreen extends ConsumerWidget {
  const OrderSuccessScreen({super.key});

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
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, size: 56, color: Colors.white),
              ),
              const SizedBox(height: 32),
              Text(
                'Order Placed!',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'Your delicious snacks are being prepared. You can track your order live below.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Track Order Live',
                onPressed: () {
                  context.go(AppRoutes.liveTracking);
                },
                fullWidth: true,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Go Back Home',
                type: AppButtonType.outlined,
                onPressed: () {
                  context.go(AppRoutes.home);
                },
                fullWidth: true,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
