import 'package:flutter/material.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  // Mock customer list with spend statistics
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'c101',
      'name': 'Amit Sharma',
      'phone': '+91 98765 43210',
      'totalOrders': 18,
      'lifetimeSpend': 3450.0,
      'lastActive': 'Today',
    },
    {
      'id': 'c102',
      'name': 'Priya Patel',
      'phone': '+91 91234 56789',
      'totalOrders': 12,
      'lifetimeSpend': 2180.0,
      'lastActive': 'Yesterday',
    },
    {
      'id': 'c103',
      'name': 'Rahul Verma',
      'phone': '+91 98123 45670',
      'totalOrders': 5,
      'lifetimeSpend': 650.0,
      'lastActive': '3 days ago',
    },
    {
      'id': 'c104',
      'name': 'Sneha Rao',
      'phone': '+91 95432 10987',
      'totalOrders': 24,
      'lifetimeSpend': 5120.0,
      'lastActive': 'Today',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Spend Logs',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Header summary card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Audited',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_customers.length} Users',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 20, thickness: 1),
                    Column(
                      children: [
                        Text(
                          'Average Customer Value',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹2,850',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Montserrat',
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        customer['name'][0],
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      customer['name'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${customer['phone']}'),
                        Text('Last Active: ${customer['lastActive']}',
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${customer['lifetimeSpend']}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          '${customer['totalOrders']} orders',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
