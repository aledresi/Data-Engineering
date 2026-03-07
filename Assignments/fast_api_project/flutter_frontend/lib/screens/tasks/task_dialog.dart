import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';

void showTaskDialog(BuildContext context, ApiService apiService, VoidCallback onRefresh, {Task? task}) {
  final titleController = TextEditingController(text: task?.title);
  final descController = TextEditingController(text: task?.description);
  int? selectedProjectId = task?.projectId;
  String selectedStatus = task?.status ?? 'pending';
  int? selectedAssigneeId = task?.assignedTo;
  final isUpdate = task != null;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isUpdate ? 'Update Task' : 'New Task'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SingleChildScrollView(
              child: Column(
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
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    items: ['pending', 'in_progress', 'completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setDialogState(() => selectedStatus = val!),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Project>>(
                    future: apiService.getProjects(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading projects...');
                      return DropdownButtonFormField<int?>(
                        value: selectedProjectId,
                        decoration: InputDecoration(labelText: 'Project', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        items: snapshot.data!.map((p) => DropdownMenuItem(value: p.id, child: Text(p.title))).toList(),
                        onChanged: (val) => setDialogState(() => selectedProjectId = val),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  FutureBuilder<List<User>>(
                    future: apiService.getUsers(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading users...');
                      return DropdownButtonFormField<int?>(
                        value: selectedAssigneeId,
                        decoration: InputDecoration(labelText: 'Assign To User', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        items: [
                          const DropdownMenuItem<int?>(value: null, child: Text("None")),
                          ...snapshot.data!.map((u) => DropdownMenuItem(value: u.id, child: Text(u.username))),
                        ],
                        onChanged: (val) => setDialogState(() => selectedAssigneeId = val),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty || selectedProjectId == null) {
                    showSnackBar(context, 'Title and Project are required', isError: true);
                    return;
                  }
                  try {
                    final t = Task(
                      id: task?.id ?? 0,
                      title: titleController.text,
                      description: descController.text,
                      status: selectedStatus,
                      projectId: selectedProjectId!,
                      assignedTo: selectedAssigneeId,
                    );

                    if (isUpdate) {
                      await apiService.updateTask(task.id, t);
                      showSnackBar(context, 'Task updated!');
                    } else {
                      await apiService.createTask(t);
                      showSnackBar(context, 'Task created!');
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
