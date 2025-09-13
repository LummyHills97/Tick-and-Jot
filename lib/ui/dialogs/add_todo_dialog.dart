import 'package:flutter/material.dart';
import '../../models/todo.dart';

class AddTodoDialog extends StatefulWidget {
  final Todo? todoToEdit;
  
  const AddTodoDialog({Key? key, this.todoToEdit}) : super(key: key);

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  TodoPriority _selectedPriority = TodoPriority.medium;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.todoToEdit != null) {
      _titleController.text = widget.todoToEdit!.title;
      _descriptionController.text = widget.todoToEdit!.description;
      _selectedPriority = widget.todoToEdit!.priority;
      _selectedDate = widget.todoToEdit!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todoToEdit != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit_note : Icons.add_task,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Edit Todo' : 'Add Todo',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title...',
                    prefixIcon: Icon(Icons.task),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add more details...',
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TodoPriority>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: TodoPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(_getPriorityText(priority)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Due Date (Optional)',
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: _selectedDate != null 
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _selectedDate = null),
                          )
                        : null,
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select due date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                            ? Theme.of(context).hintColor
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _saveTodo,
                      child: Text(isEditing ? 'Update' : 'Save Todo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Colors.red;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return 'High';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.low:
        return 'Low';
    }
  }

  void _saveTodo() {
    if (_formKey.currentState?.validate() ?? false) {
      final todo = widget.todoToEdit?.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDate,
      ) ?? Todo(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDate,
      );
      Navigator.of(context).pop(todo);
    }
  }
}
