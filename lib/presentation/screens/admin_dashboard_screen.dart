import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Mock order items for the dashboard
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': 'TC-1082',
      'customer': 'Amit Sharma',
      'items': '2x Masala Chai, 1x Samosa',
      'total': 185.0,
      'status': 'Pending',
      'time': '10 mins ago',
    },
    {
      'id': 'TC-1081',
      'customer': 'Priya Patel',
      'items': '1x Cardamom Chai, 2x Vada Pav',
      'total': 160.0,
      'status': 'Preparing',
      'time': '25 mins ago',
    },
    {
      'id': 'TC-1080',
      'customer': 'Rahul Verma',
      'items': '1x Ginger Chai, 1x Bun Maska',
      'total': 110.0,
      'status': 'Out for Delivery',
      'time': '40 mins ago',
    },
  ];

  void _updateOrderStatus(int index, String newStatus) {
    setState(() {
      _mockOrders[index]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${_mockOrders[index]['id']} updated to $newStatus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () {
              context.go(AppRoutes.welcome);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome section
            Text(
              'Welcome, Tea Centre Manager',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Metrics Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildMetricCard(
                  context: context,
                  title: "Today's Revenue",
                  value: "₹18,450",
                  icon: Icons.currency_rupee,
                  color: Colors.green,
                ),
                _buildMetricCard(
                  context: context,
                  title: "Active Orders",
                  value: "24",
                  icon: Icons.shopping_bag,
                  color: theme.colorScheme.primary,
                ),
                _buildMetricCard(
                  context: context,
                  title: "Low Stock Items",
                  value: "3",
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                _buildMetricCard(
                  context: context,
                  title: "Total Customers",
                  value: "1,248",
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions Panel
            Text(
              'Management Services',
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildManagementTile(
              context: context,
              title: "Menu & Product Management",
              subtitle: "Add chai blends, snacks, and update availability",
              icon: Icons.restaurant_menu,
              route: AppRoutes.adminMenu,
            ),
            _buildManagementTile(
              context: context,
              title: "Inventory Stocks Counter",
              subtitle: "Manage store items, alerts, and stock counts",
              icon: Icons.inventory,
              route: AppRoutes.adminInventory,
            ),
            _buildManagementTile(
              context: context,
              title: "Coupon Discount Engine",
              subtitle: "Generate, edit, and audit promo codes",
              icon: Icons.local_offer,
              route: AppRoutes.adminCoupons,
            ),
            _buildManagementTile(
              context: context,
              title: "Customer Database & Spend Logs",
              subtitle: "Audit loyal users and customer statistics",
              icon: Icons.supervisor_account,
              route: AppRoutes.adminCustomers,
            ),
            const SizedBox(height: 24),

            // Live incoming orders queue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Incoming Orders Queue',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'LIVE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mockOrders.length,
              itemBuilder: (context, index) {
                final order = _mockOrders[index];
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
                              order['id'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            Text(
                              order['time'],
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customer: ${order['customer']}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Items: ${order['items']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: ₹${order['total']}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            _buildStatusChip(theme, order['status']),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (order['status'] == 'Pending') ...[
                              TextButton(
                                onPressed: () => _updateOrderStatus(index, 'Rejected'),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Reject'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _updateOrderStatus(index, 'Preparing'),
                                child: const Text('Accept'),
                              ),
                            ] else if (order['status'] == 'Preparing') ...[
                              ElevatedButton(
                                onPressed: () => _updateOrderStatus(index, 'Out for Delivery'),
                                child: const Text('Mark Out for Delivery'),
                              ),
                            ] else if (order['status'] == 'Out for Delivery') ...[
                              ElevatedButton(
                                onPressed: () => _updateOrderStatus(index, 'Delivered'),
                                child: const Text('Mark Delivered'),
                              ),
                            ] else ...[
                              Text(
                                'Order Closed',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ]
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push(route);
        },
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, String status) {
    Color bg = Colors.grey.shade100;
    Color fg = Colors.grey.shade700;

    switch (status) {
      case 'Pending':
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade800;
        break;
      case 'Preparing':
        bg = Colors.blue.shade100;
        fg = Colors.blue.shade800;
        break;
      case 'Out for Delivery':
        bg = Colors.purple.shade100;
        fg = Colors.purple.shade800;
        break;
      case 'Delivered':
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
        break;
      case 'Rejected':
        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
