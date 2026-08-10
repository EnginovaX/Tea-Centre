import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/app_button.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductEntity product;

  const ProductDetailsScreen({required this.product, super.key});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;
  final List<String> _selectedCustomizations = [];
  final _notesController = TextEditingController();
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  void _checkFavorite() async {
    final uid = ref.read(authProvider).uid;
    if (uid != null) {
      final res = await ref.read(favoriteProvider.notifier).isFavorite(uid, widget.product.id);
      if (mounted) {
        setState(() {
          _isFav = res;
        });
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    final uid = ref.read(authProvider).uid;
    if (uid != null) {
      if (_isFav) {
        await ref.read(favoriteProvider.notifier).removeFavorite(uid, widget.product.id);
      } else {
        await ref.read(favoriteProvider.notifier).addFavorite(uid, widget.product);
      }
      setState(() {
        _isFav = !_isFav;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = ref.watch(authProvider).uid ?? 'guest';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFav ? Icons.favorite : Icons.favorite_border,
              color: _isFav ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 240,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.fastfood, size: 80, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.name,
                    style: theme.textTheme.headlineLarge?.copyWith(fontSize: 28),
                  ),
                  Text(
                    '₹${widget.product.price.toInt()}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: widget.product.isVeg ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.product.isVeg ? 'Vegetarian' : 'Non-Vegetarian',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${widget.product.preparationTimeMinutes} mins prep'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (widget.product.ingredients.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Ingredients', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.product.ingredients.map((ing) {
                    return Chip(label: Text(ing));
                  }).toList(),
                ),
              ],
              if (widget.product.customizations.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Customizations', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.product.customizations.map((cust) {
                    final isSel = _selectedCustomizations.contains(cust);
                    return ChoiceChip(
                      label: Text(cust),
                      selected: isSel,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCustomizations.add(cust);
                          } else {
                            _selectedCustomizations.remove(cust);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Add to Cart',
                onPressed: () {
                  ref.read(cartProvider(userId).notifier).addItem(
                        widget.product,
                        quantity: _quantity,
                        customizations: _selectedCustomizations,
                        notes: _notesController.text.trim(),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.product.name} added to cart!')),
                  );
                  context.pop();
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
