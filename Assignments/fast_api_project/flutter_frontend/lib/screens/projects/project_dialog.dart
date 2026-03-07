import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';

void showProjectDialog(BuildContext context, ApiService apiService, VoidCallback onRefresh, {Project? project}) {
  final titleController = TextEditingController(text: project?.title);
  final descController = TextEditingController(text: project?.description);
  int? selectedOwnerId = project?.ownerId;
  final isUpdate = project != null;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isUpdate ? 'Update Project' : 'New Project'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                FutureBuilder<List<User>>(
                  future: apiService.getUsers(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading users...');
                    return DropdownButtonFormField<int?>(
                      value: selectedOwnerId,
                      decoration: InputDecoration(labelText: 'Owner', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      items: snapshot.data!.map((u) => DropdownMenuItem(value: u.id, child: Text(u.username))).toList(),
                      onChanged: (val) => setDialogState(() => selectedOwnerId = val),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty || selectedOwnerId == null) {
                    showSnackBar(context, 'Title and Owner are required', isError: true);
                    return;
                  }
                  try {
                    final proj = Project(
                      id: project?.id ?? 0,
                      title: titleController.text,
                      description: descController.text,
                      ownerId: selectedOwnerId!,
                    );

                    if (isUpdate) {
                      await apiService.updateProject(project.id, proj);
                      showSnackBar(context, 'Project updated!');
                    } else {
                      await apiService.createProject(proj);
                      showSnackBar(context, 'Project created!');
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
        }
      );
    },
  );
}
