// notes_callbacks.dart

import '../models/recipe.dart';

class NotesCallbacks {
  static void updateNote(Recipe recipe, Function setState, String section, int noteIndex, String value) {
    setState(() {
      List<String> notes = _getNotesList(recipe, section);
      notes[noteIndex] = value;
      _updateRecipeNotes(recipe, section, notes);
    });
  }

  static void deleteNote(Recipe recipe, Function setState, String section, int noteIndex) {
    setState(() {
      List<String> notes = _getNotesList(recipe, section);
      notes.removeAt(noteIndex);
      _updateRecipeNotes(recipe, section, notes);
    });
  }

  static void addNote(Recipe recipe, Function setState, String section) {
    setState(() {
      List<String> notes = _getNotesList(recipe, section);
      notes.add('');
      _updateRecipeNotes(recipe, section, notes);
    });
  }

  static List<String> _getNotesList(Recipe recipe, String section) {
    String notesText = switch (section) {
      'personalNotes' => recipe.notes.personalNotes,
      'proTips' => recipe.notes.proTips,
      'storage' => recipe.notes.storage,
      'makeAheadMethod' => recipe.notes.makeAheadMethod,
      'reheatingLeftovers' => recipe.notes.reheatingLeftovers,
      'other' => recipe.notes.other,
      _ => '',
    };
    return notesText.split('\n');
  }

  static void _updateRecipeNotes(Recipe recipe, String section, List<String> notes) {
    final updatedNotes = Notes(
      personalNotes: section == 'personalNotes' ? notes.join('\n') : recipe.notes.personalNotes,
      proTips: section == 'proTips' ? notes.join('\n') : recipe.notes.proTips,
      storage: section == 'storage' ? notes.join('\n') : recipe.notes.storage,
      makeAheadMethod: section == 'makeAheadMethod' ? notes.join('\n') : recipe.notes.makeAheadMethod,
      reheatingLeftovers: section == 'reheatingLeftovers' ? notes.join('\n') : recipe.notes.reheatingLeftovers,
      other: section == 'other' ? notes.join('\n') : recipe.notes.other,
    );
    recipe.notes = updatedNotes;
  }
}

