import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';

void showUserDialog(BuildContext context, ApiService apiService, VoidCallback onRefresh, {User? user}) {
  final usernameController = TextEditingController(text: user?.username);
  final emailController = TextEditingController(text: user?.email);
  final isUpdate = user != null;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(isUpdate ? 'Update User' : 'New User'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isEmpty || emailController.text.isEmpty) {
                showSnackBar(context, 'Fields cannot be empty', isError: true);
                return;
              }
              try {
                final newUser = User(
                  id: user?.id ?? 0,
                  username: usernameController.text,
                  email: emailController.text,
                  isActive: user?.isActive ?? true,
                );

                if (isUpdate) {
                  await apiService.updateUser(user.id, newUser);
                  showSnackBar(context, 'User updated!');
                } else {
                  await apiService.createUser(newUser);
                  showSnackBar(context, 'User created!');
                }
                Navigator.pop(context);
                onRefresh();
              } catch (e) {
                showSnackBar(context, 'Error: $e', isError: true);
              }
            },
            child: Text(isUpdate ? 'Update' : 'Create'),
          ),
        ],
      );
    },
  );
}
