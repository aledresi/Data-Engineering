import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../tasks/task_detail_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Project Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(project.description ?? "No description provided.", style: const TextStyle(fontSize: 15)),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.person_pin, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text('Owner: ', style: TextStyle(color: Colors.grey)),
                        FutureBuilder<List<User>>(
                          future: apiService.getUsers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const Text('...');
                            final user = snapshot.data!.firstWhere((u) => u.id == project.ownerId, orElse: () => User(id: -1, username: 'Unknown', email: '', isActive: false));
                            return Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Linked Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<Task>>(
              future: apiService.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return const Text('Error loading tasks');
                final projectTasks = snapshot.data?.where((t) => t.projectId == project.id).toList() ?? [];
                
                if (projectTasks.isEmpty) return const Padding(padding: EdgeInsets.all(8.0), child: Text('No tasks associated with this project.'));
                
                return Column(
                  children: projectTasks.map((t) => Card(
                    child: ListTile(
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Status: ${t.status}'),
                      trailing: Icon(t.status == 'completed' ? Icons.check_circle : Icons.pending, color: t.status == 'completed' ? Colors.green : Colors.orange),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailScreen(task: t))),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
