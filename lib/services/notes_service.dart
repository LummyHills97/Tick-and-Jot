
import 'package:flutter/material.dart';
import '../models/note.dart';

class NotesService extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  List<Note> get recentNotes {
    final sortedNotes = List<Note>.from(_notes);
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedNotes.take(5).toList();
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((note) => note.id == noteId);
    notifyListeners();
  }

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Note> searchNotes(String query) {
    if (query.isEmpty) return notes;
    return _notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}