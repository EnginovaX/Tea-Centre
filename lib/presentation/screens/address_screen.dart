import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address_entity.dart';
import '../providers/address_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _label = 'Home';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    final uid = ref.read(authProvider).uid;
    if (uid != null) {
      ref.read(addressProvider.notifier).fetchAddresses(uid);
    }
  }

  @override
  void dispose() {
    _addressLineController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _saveAddress() async {
    setState(() {
      _errorMessage = null;
    });

    final addressLine = _addressLineController.text.trim();
    final city = _cityController.text.trim();
    final pincode = _pincodeController.text.trim();
    final instructions = _instructionsController.text.trim();

    if (addressLine.isEmpty || city.isEmpty || pincode.isEmpty) {
      setState(() {
        _errorMessage = 'Address, City, and Pincode are required';
      });
      return;
    }

    final uid = ref.read(authProvider).uid;
    if (uid != null) {
      final address = AddressEntity(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        userId: uid,
        label: _label,
        addressLine: addressLine,
        city: city,
        pincode: pincode,
        deliveryInstructions: instructions,
        isDefault: false,
      );

      await ref.read(addressProvider.notifier).saveAddress(address);

      // Clear fields
      _addressLineController.clear();
      _cityController.clear();
      _pincodeController.clear();
      _instructionsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addressesState = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add New Address', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Home', 'Office', 'Other'].map((lbl) {
                  final isSel = _label == lbl;
                  return ChoiceChip(
                    label: Text(lbl),
                    selected: isSel,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _label = lbl;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _addressLineController,
                hintText: 'Address Line',
                prefixIcon: const Icon(Icons.home),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _cityController,
                hintText: 'City',
                prefixIcon: const Icon(Icons.location_city),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _pincodeController,
                hintText: 'Pincode',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.pin),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _instructionsController,
                hintText: 'Delivery Instructions (e.g., Leave at gate)',
                prefixIcon: const Icon(Icons.note),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Save Address',
                onPressed: _saveAddress,
                fullWidth: true,
              ),
              const SizedBox(height: 32),
              Text('Your Addresses', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),
              addressesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (list) {
                  if (list.isEmpty) {
                    return const Text('No saved addresses yet', textAlign: TextAlign.center);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      final item = list[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Row(
                            children: [
                              Icon(
                                item.label == 'Home'
                                    ? Icons.home
                                    : item.label == 'Office'
                                        ? Icons.work
                                        : Icons.location_on,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text('${item.label} Address'),
                              if (item.isDefault) ...[
                                const SizedBox(width: 8),
                                const Badge(label: Text('Default')),
                              ]
                            ],
                          ),
                          subtitle: Text('${item.addressLine}, ${item.city} - ${item.pincode}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                                onPressed: () {
                                  final uid = ref.read(authProvider).uid;
                                  if (uid != null) {
                                    ref.read(addressProvider.notifier).setDefaultAddress(uid, item.id);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  final uid = ref.read(authProvider).uid;
                                  if (uid != null) {
                                    ref.read(addressProvider.notifier).deleteAddress(uid, item.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
