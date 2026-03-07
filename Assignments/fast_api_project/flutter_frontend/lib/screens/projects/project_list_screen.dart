import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import 'project_detail_screen.dart';
import 'project_dialog.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Project>> futureProjects;

  @override
  void initState() {
    super.initState();
    futureProjects = apiService.getProjects();
  }

  void _refreshProjects() {
    setState(() {
      futureProjects = apiService.getProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Project>>(
        future: futureProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No projects found"));

          return RefreshIndicator(
            onRefresh: () async => _refreshProjects(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Project project = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.folder_shared, color: Colors.teal),
                    title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(project.description ?? 'No description'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectDetailScreen(project: project)),
                    ).then((_) => _refreshProjects()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mode_edit_outlined, color: Colors.blue),
                          onPressed: () => showProjectDialog(context, apiService, _refreshProjects, project: project),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await showDeleteConfirmation(context, 'Project');
                            if (confirmed == true) {
                              try {
                                await apiService.deleteProject(project.id);
                                showSnackBar(context, 'Project deleted!');
                                _refreshProjects();
                              } catch (e) {
                                showSnackBar(context, 'Error: $e', isError: true);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProjectDialog(context, apiService, _refreshProjects),
        child: const Icon(Icons.create_new_folder_outlined),
      ),
    );
  }
}
