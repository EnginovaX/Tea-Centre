import 'package:flutter/material.dart';

class AdminInventoryScreen extends StatefulWidget {
  const AdminInventoryScreen({super.key});

  @override
  State<AdminInventoryScreen> createState() => _AdminInventoryScreenState();
}

class _AdminInventoryScreenState extends State<AdminInventoryScreen> {
  // Mock inventory list
  final List<Map<String, dynamic>> _inventory = [
    {
      'id': 'i1',
      'name': 'Assam CTC Tea Leaves',
      'quantity': 4.5, // in kg
      'unit': 'kg',
      'threshold': 5.0,
      'isLow': true,
    },
    {
      'id': 'i2',
      'name': 'Premium Cardamom Pods',
      'quantity': 1.2, // in kg
      'unit': 'kg',
      'threshold': 1.0,
      'isLow': false,
    },
    {
      'id': 'i3',
      'name': 'Fresh Full-Cream Milk',
      'quantity': 8.0, // in Liters
      'unit': 'L',
      'threshold': 10.0,
      'isLow': true,
    },
    {
      'id': 'i4',
      'name': 'Organic Brown Sugar',
      'quantity': 15.0, // in kg
      'unit': 'kg',
      'threshold': 8.0,
      'isLow': false,
    },
  ];

  void _topUpStock(int index) {
    setState(() {
      _inventory[index]['quantity'] = _inventory[index]['quantity'] + 5.0;
      // Re-evaluate stock warning
      _inventory[index]['isLow'] = _inventory[index]['quantity'] <= _inventory[index]['threshold'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added stock to ${_inventory[index]['name']}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Status',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Banner for total low stock alerts
          Container(
            color: Colors.amber.shade100,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'LOW STOCK DETECTED: Some essential ingredients are below the safe operational threshold!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _inventory.length,
              itemBuilder: (context, index) {
                final item = _inventory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item['isLow'])
                              const Icon(Icons.error_outline, color: Colors.red),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Stock: ${item['quantity']} ${item['unit']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: item['isLow'] ? Colors.red : Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Safe Threshold: ${item['threshold']} ${item['unit']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _topUpStock(index),
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('+5 Units'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: item['isLow']
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondaryContainer,
                                foregroundColor: item['isLow']
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSecondaryContainer,
                              ),
                            )
                          ],
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
