import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import '../projects/project_detail_screen.dart';
import '../tasks/task_detail_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: Text(user.username)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionHeader('Profile Details'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(leading: const Icon(Icons.email), title: const Text('Email'), subtitle: Text(user.email)),
                    ListTile(leading: const Icon(Icons.badge), title: const Text('User ID'), subtitle: Text(user.id.toString())),
                    ListTile(leading: const Icon(Icons.toggle_on), title: const Text('Status'), subtitle: Text(user.isActive ? "Active" : "Inactive")),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            FutureBuilder<List<Project>>(
              future: apiService.getProjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
                final userProjects = snapshot.data?.where((p) => p.ownerId == user.id).toList() ?? [];
                
                if (userProjects.isEmpty) return const SizedBox.shrink();
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionHeader('Ownership'),
                    ...userProjects.map((p) => Card(
                      child: ListTile(
                        title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(p.description ?? 'No description'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailScreen(project: p))),
                      ),
                    )),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
            // Assigned Tasks Section
            FutureBuilder<List<Task>>(
              future: apiService.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
                final userTasks = snapshot.data?.where((t) => t.assignedTo == user.id).toList() ?? [];
                
                if (userTasks.isEmpty) return const SizedBox.shrink();
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionHeader('Assigned Tasks'),
                    ...userTasks.map((t) => Card(
                      child: ListTile(
                        title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Status: ${t.status}'),
                        trailing: Icon(t.status == 'completed' ? Icons.check_circle : Icons.pending, color: t.status == 'completed' ? Colors.green : Colors.orange),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailScreen(task: t))),
                      ),
                    )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
