import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import 'task_detail_screen.dart';
import 'task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = apiService.getTasks();
  }

  void _refreshTasks() {
    setState(() {
      futureTasks = apiService.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No tasks found"));

          return RefreshIndicator(
            onRefresh: () async => _refreshTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Task task = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.task, color: task.status == 'completed' ? Colors.green : Colors.orange),
                    title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Project: ${task.projectId} | Status: ${task.status}"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                    ).then((_) => _refreshTasks()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_calendar_outlined, color: Colors.blue),
                          onPressed: () => showTaskDialog(context, apiService, _refreshTasks, task: task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await showDeleteConfirmation(context, 'Task');
                            if (confirmed == true) {
                              try {
                                await apiService.deleteTask(task.id);
                                showSnackBar(context, 'Task deleted!');
                                _refreshTasks();
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
        onPressed: () => showTaskDialog(context, apiService, _refreshTasks),
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
