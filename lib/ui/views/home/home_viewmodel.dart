import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import '../../../models/todo.dart'; // Use consistent import path
import '../../../models/note.dart'; // Assuming you have a Note model

class HomeViewModel extends BaseViewModel {
  // Page Controller for navigation
  final PageController pageController = PageController();
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Data lists
  final List<Todo> _todos = [];
  final List<Note> _notes = []; // Assuming you have notes too

  // Getters for todos
  List<Todo> get todos => _todos;
  List<Todo> get activeTodos => _todos.where((todo) => !todo.isCompleted).toList();
  List<Todo> get completedTodos => _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get todayTodos => _todos.where((todo) => 
    !todo.isCompleted && 
    todo.createdAt.day == DateTime.now().day &&
    todo.createdAt.month == DateTime.now().month &&
    todo.createdAt.year == DateTime.now().year
  ).toList();

  // Getters for notes
  List<Note> get notes => _notes;
  List<Note> get recentNotes => _notes.take(3).toList();
  List<Note> get filteredNotes => _searchQuery.isEmpty 
    ? _notes 
    : _notes.where((note) => 
        note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        note.content.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();

  // Stats
  int get notesCount => _notes.length;
  int get activeTodosCount => activeTodos.length;

  @override
  void dispose() {
    pageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Page navigation methods
  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void switchToTab(int index) {
    _currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  // Search functionality
  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Todo methods
  Future<void> addTodo({
    required String title,
    String? description,
    TodoPriority priority = TodoPriority.low, // Fixed enum name
  }) async {
    final newTodo = Todo(
      title: title,
      description: description ?? '',
      priority: priority,
    );
    _todos.add(newTodo);
    notifyListeners();
  }

  void toggleTodo(String todoId) {
    final todoIndex = _todos.indexWhere((todo) => todo.id == todoId);
    if (todoIndex != -1) {
      _todos[todoIndex] = _todos[todoIndex].copyWith(
        isCompleted: !_todos[todoIndex].isCompleted
      );
      notifyListeners();
    }
  }

  void editTodo(Todo todo) {
    // Navigate to edit screen or show dialog
    // Implementation depends on your navigation setup
    print('Edit todo: ${todo.title}');
  }

  void deleteTodo(String todoId) {
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }

  void removeTodo(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }

  // Note methods
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final newNote = Note(
      title: title,
      content: content,
    );
    _notes.add(newNote);
    notifyListeners();
  }

  void editNote(Note note) {
    // Navigate to edit screen or show dialog
    // Implementation depends on your navigation setup
    print('Edit note: ${note.title}');
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  // Dialog methods
  void showAddDialog(BuildContext context) {
    // Show dialog based on current tab
    switch (_currentIndex) {
      case 0: // Dashboard - show choice dialog
        _showAddChoiceDialog(context);
        break;
      case 1: // Notes
        _showAddNoteDialog(context);
        break;
      case 2: // Todos
        _showAddTodoDialog(context);
        break;
    }
  }

  void _showAddChoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New'),
        content: const Text('What would you like to add?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showAddNoteDialog(context);
            },
            child: const Text('Note'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showAddTodoDialog(context);
            },
            child: const Text('Todo'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                addNote(
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TodoPriority selectedPriority = TodoPriority.low;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TodoPriority>(
                value: selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TodoPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  addTodo(
                    title: titleController.text,
                    description: descriptionController.text,
                    priority: selectedPriority,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}