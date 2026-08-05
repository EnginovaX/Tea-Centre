import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dependency_providers.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authProvider).uid ?? 'guest';
    final orderRepo = ref.watch(orderRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<NotificationEntity>>(
          future: orderRepo.getNotifications(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return const Center(child: Text('No notifications received yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: list.length,
              itemBuilder: (context, idx) {
                final notification = list[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notification.type == 'OrderUpdate'
                          ? Colors.blue.shade100
                          : Colors.orange.shade100,
                      child: Icon(
                        notification.type == 'OrderUpdate'
                            ? Icons.assignment
                            : Icons.local_offer,
                        color: notification.type == 'OrderUpdate'
                            ? Colors.blue
                            : Colors.orange,
                      ),
                    ),
                    title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(notification.body),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
