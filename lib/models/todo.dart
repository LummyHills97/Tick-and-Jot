import 'package:uuid/uuid.dart';

enum TodoPriority { low, medium, high }

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TodoPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;

  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = TodoPriority.low,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TodoPriority? priority,
    DateTime? updatedAt,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      priority: TodoPriority.values[json['priority']],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }
}