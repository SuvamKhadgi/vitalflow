import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:vitalflow/app/constants/api_endpoints.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/app/my_app.dart';
import 'package:vitalflow/app/shared_prefs/token_shared_prefs.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<Map<String, dynamic>> _getUserInfo() async {
    final tokenResult = await getIt<TokenSharedPrefs>().getToken();
    return tokenResult.fold(
      (failure) => {'name': 'Unknown', 'email': '', 'image': null},
      (token) {
        final payload = Jwt.parseJwt(token);
        print('JWT Payload: $payload'); // Debug
        return payload;
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, Map<String, dynamic> user) {
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    File? newImage;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      newImage = File(pickedFile.path);
                    });
                    final uploadResult = await getIt<UploadImageUsecase>()
                        .call(UploadImageParams(file: newImage!));
                    uploadResult.fold(
                      (failure) => showMySnackBar(
                          context: context,
                          message: 'Image upload failed',
                          color: Colors.red),
                      (imageName) {
                        user['image'] = imageName;
                        showMySnackBar(
                            context: context,
                            message: 'Image uploaded',
                            color: Colors.green);
                      },
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: newImage != null
                      ? FileImage(newImage!)
                      : user['image'] != null
                          ? CachedNetworkImageProvider(
                              '${ApiEndpoints.imageUrl}${user['image']}')
                          : const AssetImage('assets/images/logos.png')
                              as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Call API to update profile (e.g., PATCH /api/creds/update)
              final updatedUser = {
                'name': nameController.text,
                'email': emailController.text,
                'image': user['image'], // Updated image if changed
              };
              // Placeholder for API call
              print('Updating profile: $updatedUser');
              showMySnackBar(
                  context: context,
                  message: 'Profile updated',
                  color: Colors.green);
              Navigator.pop(dialogContext);
              setState(() {}); // Refresh UI
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, const Color(0xFF03DAC6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: user['image'] != null
                              ? CachedNetworkImageProvider(
                                  '${ApiEndpoints.imageUrl}${user['image']}')
                              : const AssetImage('assets/images/logos.png')
                                  as ImageProvider,
                          backgroundColor: theme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          user['name'] ?? 'Unknown',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user['email'] ?? '',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Edit Profile Button
                        ElevatedButton.icon(
                          onPressed: () =>
                              _showEditProfileDialog(context, user),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Other Settings Section
                        ExpansionTile(
                          title: const Text('Other Settings'),
                          children: [
                            ListTile(
                              title: const Text('Notification Preferences'),
                              onTap: () {
                                // TODO: Add notification settings logic
                                showMySnackBar(
                                    context: context,
                                    message:
                                        'Notification settings coming soon!',
                                    color: Colors.blue);
                              },
                            ),
                            ListTile(
                              title: const Text('Privacy'),
                              onTap: () {
                                // TODO: Add privacy settings logic
                                showMySnackBar(
                                    context: context,
                                    message: 'Privacy settings coming soon!',
                                    color: Colors.blue);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SwitchListTile(
                          title: Text('Dark Mode',
                              style: theme.textTheme.bodyLarge),
                          value: context.watch<ThemeCubit>().state,
                          onChanged: (value) =>
                              context.read<ThemeCubit>().toggleTheme(),
                          activeColor: theme.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final result =
                                await getIt<TokenSharedPrefs>().clearToken();
                            result.fold(
                              (failure) => print(
                                  'Failed to clear token: ${failure.message}'),
                              (_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
