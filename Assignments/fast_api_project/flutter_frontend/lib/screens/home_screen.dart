import 'package:flutter/material.dart';
import 'users/user_list_screen.dart';
import 'projects/project_list_screen.dart';
import 'tasks/task_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _titles = ['Users', 'Projects', 'Tasks'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    switch (_selectedIndex) {
      case 0:
        currentScreen = const UserListScreen();
        break;
      case 1:
        currentScreen = const ProjectListScreen();
        break;
      case 2:
        currentScreen = const TaskListScreen();
        break;
      default:
        currentScreen = const UserListScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.dashboard_customize,
                        size: 30,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('Users'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: const Text('Projects'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt_outlined),
              title: const Text('Tasks'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: currentScreen,
      ),
    );
  }
}
