import 'package:flutter/material.dart';

class AdminMenuManagementScreen extends StatefulWidget {
  const AdminMenuManagementScreen({super.key});

  @override
  State<AdminMenuManagementScreen> createState() => _AdminMenuManagementScreenState();
}

class _AdminMenuManagementScreenState extends State<AdminMenuManagementScreen> {
  // Mock products list
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'p1',
      'name': 'Masala Chai',
      'category': 'Chai',
      'price': 40.0,
      'isAvailable': true,
      'description': 'Traditional spiced Indian tea brewed with milk and cardamom.',
    },
    {
      'id': 'p2',
      'name': 'Ginger Chai',
      'category': 'Chai',
      'price': 35.0,
      'isAvailable': true,
      'description': 'Zesty and refreshing ginger-infused milk tea.',
    },
    {
      'id': 'p3',
      'name': 'Samosa (2pcs)',
      'category': 'Snacks',
      'price': 50.0,
      'isAvailable': true,
      'description': 'Crispy golden pastry shells stuffed with spiced potatoes and peas.',
    },
    {
      'id': 'p4',
      'name': 'Bun Maska',
      'category': 'Snacks',
      'price': 45.0,
      'isAvailable': false,
      'description': 'Fresh soft bun spread with a generous dollop of butter.',
    },
  ];

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Chai';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _toggleAvailability(int index) {
    setState(() {
      _menuItems[index]['isAvailable'] = !_menuItems[index]['isAvailable'];
    });
  }

  void _addNewProduct() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Snack/Tea Blend',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price (₹)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Chai', 'Snacks', 'Combos'].map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _selectedCategory = val;
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _priceController.text.isNotEmpty) {
                      setState(() {
                        _menuItems.add({
                          'id': 'p${_menuItems.length + 1}',
                          'name': _nameController.text,
                          'category': _selectedCategory,
                          'price': double.tryParse(_priceController.text) ?? 0.0,
                          'isAvailable': true,
                          'description': _descController.text,
                        });
                      });
                      _nameController.clear();
                      _priceController.clear();
                      _descController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('Add Product to Menu'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu Management',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProduct,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                item['name'],
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['category'],
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${item['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'],
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Available', style: TextStyle(fontSize: 10)),
                  Expanded(
                    child: Switch(
                      value: item['isAvailable'],
                      onChanged: (val) {
                        _toggleAvailability(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
