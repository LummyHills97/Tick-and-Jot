import 'package:flutter/material.dart';
import '../../models/note.dart';

class AddNoteDialog extends StatefulWidget {
  final Note? noteToEdit;
  
  const AddNoteDialog({Key? key, this.noteToEdit}) : super(key: key);

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.noteToEdit != null) {
      _titleController.text = widget.noteToEdit!.title;
      _contentController.text = widget.noteToEdit!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteToEdit != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                    isEditing ? Icons.edit_note : Icons.note_add,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Note' : 'Add Note',
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
                  labelText: 'Title',
                  hintText: 'Enter note title...',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Write your note here...',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Please enter some content';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
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
                    onPressed: _saveNote,
                    child: Text(isEditing ? 'Update' : 'Save Note'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    if (_formKey.currentState?.validate() ?? false) {
      final note = widget.noteToEdit?.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      ) ?? Note(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );
      Navigator.of(context).pop(note);
    }
  }
}
