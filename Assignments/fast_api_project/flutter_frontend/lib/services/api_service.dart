import 'dart:convert';
import 'package:flutter_frontend/models/models.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = 'http://192.168.1.101:8888';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<List<Project>> getProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Project.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<Project> createProject(Project project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(project.toJson()),
    );
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  Future<Project> updateProject(int id, Project project) async {
    final response = await http.put(
      Uri.parse('$baseUrl/projects/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(project.toJson()),
    );
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update project');
    }
  }

  Future<void> deleteProject(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/projects/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete project');
    }
  }

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Task.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(int id, Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
