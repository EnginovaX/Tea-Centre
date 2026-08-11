import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final uid = ref.read(authProvider).uid;
    if (uid != null) {
      await ref.read(profileProvider.notifier).loadProfile(uid);
      final profile = ref.read(profileProvider).value;
      if (profile != null) {
        _nameController.text = profile.fullName;
        _emailController.text = profile.email;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() {
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      setState(() {
        _errorMessage = 'Name and email are required';
      });
      return;
    }

    final uid = ref.read(authProvider).uid;
    if (uid != null) {
      await ref.read(profileProvider.notifier).updateProfile(
            uid: uid,
            fullName: name,
            email: email,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: profileState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (profile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: profile.profilePhotoUrl != null
                              ? NetworkImage(profile.profilePhotoUrl!)
                              : null,
                          child: profile.profilePhotoUrl == null
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primary,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                              onPressed: () {
                                // Photo upload trigger
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
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
                  AppTextField(
                    controller: _nameController,
                    hintText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailController,
                    hintText: 'Email address',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Save Changes',
                    onPressed: _save,
                    fullWidth: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
