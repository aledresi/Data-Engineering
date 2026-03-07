class User {
  final int id;
  final String username;
  final String email;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'is_active': isActive,
    };
  }
}

class Project {
  final int id;
  final String title;
  final String? description;
  final int ownerId;

  Project({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      ownerId: json['owner_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'owner_id': ownerId,
    };
  }
}

class Task {
  final int id;
  final String title;
  final String? description;
  final String status;
  final int projectId;
  final int? assignedTo;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.projectId,
    this.assignedTo,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'] ?? 'pending',
      projectId: json['project_id'],
      assignedTo: json['assigned_to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'project_id': projectId,
      'assigned_to': assignedTo,
    };
  }
}
