import 'package:flutter/foundation.dart';
import '../models/todo.dart';

class TodosService extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  List<Todo> get activeTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();

  List<Todo> get todayTodos {
    final today = DateTime.now();
    return _todos.where((todo) {
      if (todo.dueDate == null) return false;
      return todo.dueDate!.day == today.day &&
          todo.dueDate!.month == today.month &&
          todo.dueDate!.year == today.year;
    }).toList();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  void toggleTodoComplete(String todoId) {
    final todo = getTodoById(todoId);
    if (todo != null) {
      updateTodo(todo.copyWith(isCompleted: !todo.isCompleted));
    }
  }

  void deleteTodo(String todoId) {
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  Todo? getTodoById(String id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }
}
