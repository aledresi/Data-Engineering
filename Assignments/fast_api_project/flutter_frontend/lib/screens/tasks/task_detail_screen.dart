import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                        Chip(
                          label: Text(task.status, style: const TextStyle(color: Colors.white)),
                          backgroundColor: task.status == 'completed' ? Colors.green : (task.status == 'in_progress' ? Colors.blue : Colors.orange),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(task.description ?? "No description", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.folder_open, size: 20, color: Colors.teal),
                        const SizedBox(width: 8),
                        const Text('Project: ', style: TextStyle(fontSize: 15)),
                        FutureBuilder<List<Project>>(
                          future: apiService.getProjects(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const Text('...');
                            final project = snapshot.data!.firstWhere((p) => p.id == task.projectId, orElse: () => Project(id: -1, title: 'Unknown', ownerId: -1));
                            return Text(project.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 20, color: Colors.teal),
                        const SizedBox(width: 8),
                        const Text('Assigned To: ', style: TextStyle(fontSize: 15)),
                        if (task.assignedTo != null)
                          FutureBuilder<List<User>>(
                            future: apiService.getUsers(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const Text('...');
                              final user = snapshot.data!.firstWhere((u) => u.id == task.assignedTo, orElse: () => User(id: -1, username: 'Unknown', email: '', isActive: false));
                              return Text(user.username, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal));
                            },
                          )
                        else
                          const Text('Unassigned', style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
