enum TaskPriority { low, medium, high }

enum TaskStatus { todo, inProgress, done }

extension TaskPriorityLabel on TaskPriority {
  String get label {
    return switch (this) {
      TaskPriority.low => 'Rendah',
      TaskPriority.medium => 'Sedang',
      TaskPriority.high => 'Tinggi',
    };
  }
}

extension TaskStatusLabel on TaskStatus {
  String get label {
    return switch (this) {
      TaskStatus.todo => 'Belum dikerjakan',
      TaskStatus.inProgress => 'Sedang dikerjakan',
      TaskStatus.done => 'Selesai',
    };
  }

  String get shortLabel {
    return switch (this) {
      TaskStatus.todo => 'Belum',
      TaskStatus.inProgress => 'Proses',
      TaskStatus.done => 'Selesai',
    };
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;

  bool get isDone => status == TaskStatus.done;

  bool get isOverdue {
    if (isDone) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(deadline.year, deadline.month, deadline.day);
    return dueDate.isBefore(today);
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      deadline:
          DateTime.tryParse(json['deadline'] as String? ?? '') ??
          DateTime.now(),
      priority: _priorityFromName(json['priority'] as String?),
      status: _statusFromName(json['status'] as String?),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

TaskPriority _priorityFromName(String? name) {
  return TaskPriority.values.firstWhere(
    (value) => value.name == name,
    orElse: () => TaskPriority.medium,
  );
}

TaskStatus _statusFromName(String? name) {
  return TaskStatus.values.firstWhere(
    (value) => value.name == name,
    orElse: () => TaskStatus.todo,
  );
}
