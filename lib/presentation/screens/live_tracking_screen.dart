import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/app_button.dart';

class LiveOrderTrackingScreen extends ConsumerStatefulWidget {
  const LiveOrderTrackingScreen({super.key});

  @override
  ConsumerState<LiveOrderTrackingScreen> createState() => _LiveOrderTrackingScreenState();
}

class _LiveOrderTrackingScreenState extends ConsumerState<LiveOrderTrackingScreen> {
  int _activeStage = 1; // Simulated active stage

  final List<Map<String, dynamic>> _stages = [
    {'title': 'Order Received', 'subtitle': 'The store has accepted your order', 'icon': Icons.assignment},
    {'title': 'Preparing', 'subtitle': 'Our chefs are crafting your delicious hot snack', 'icon': Icons.restaurant},
    {'title': 'Ready', 'subtitle': 'Your order is packed and ready for pickup/delivery', 'icon': Icons.inventory_2},
    {'title': 'Out for Delivery', 'subtitle': 'Your delivery partner is on the way', 'icon': Icons.moped},
    {'title': 'Delivered', 'subtitle': 'Enjoy your freshly prepared food!', 'icon': Icons.sports_motorsports},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Estimated Arrival: 18 mins',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(fontSize: 24, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 24),
              const LinearProgressIndicator(value: 0.4, minHeight: 8),
              const SizedBox(height: 32),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stages.length,
                itemBuilder: (context, idx) {
                  final stage = _stages[idx];
                  final isCompleted = idx < _activeStage;
                  final isActive = idx == _activeStage;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: isCompleted
                                ? Colors.green
                                : isActive
                                    ? theme.colorScheme.primary
                                    : Colors.grey.shade300,
                            child: Icon(
                              stage['icon'] as IconData,
                              size: 18,
                              color: isCompleted || isActive ? Colors.white : Colors.grey,
                            ),
                          ),
                          if (idx < _stages.length - 1)
                            Container(
                              width: 2,
                              height: 48,
                              color: isCompleted ? Colors.green : Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stage['title'] as String,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 16,
                                color: isActive ? theme.colorScheme.primary : null,
                                fontWeight: isActive || isCompleted ? FontWeight.bold : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stage['subtitle'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Simulate Next Stage',
                onPressed: () {
                  if (_activeStage < _stages.length - 1) {
                    setState(() {
                      _activeStage++;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Back to Home',
                type: AppButtonType.outlined,
                onPressed: () {
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
