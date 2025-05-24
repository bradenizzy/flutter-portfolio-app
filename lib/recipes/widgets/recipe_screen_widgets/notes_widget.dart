// notes_widget.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/recipe.dart';

class NotesWidget extends StatefulWidget {
  final Notes notes;
  final bool isEditable;
  final Function(Notes updatedNotes)? onNotesChanged;

  const NotesWidget({
    Key? key,
    required this.notes,
    this.isEditable = false,
    this.onNotesChanged,
  }) : super(key: key);

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  final Uuid _uuid = const Uuid();

  late Map<String, List<_NoteEntry>> _editableNotes;

  final Map<String, String> _sectionTitles = const {
    'personalNotes': 'My Notes',
    'proTips': 'Pro Tips',
    'storage': 'Storage Instructions',
    'makeAheadMethod': 'Make Ahead Method',
    'reheatingLeftovers': 'Reheating Leftovers',
    'other': 'Other Notes',
  };

  @override
  void initState() {
    super.initState();
    _resetLocalNotes();
  }

  @override
  void didUpdateWidget(covariant NotesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notes != oldWidget.notes) {
      _disposeControllers();
      _resetLocalNotes();

      // ✅ After recreating, update controller values just in case
      for (final list in _editableNotes.values) {
        for (final note in list) {
          note.updateControllerText();
        }
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _editableNotes.forEach((_, entries) {
      for (final entry in entries) {
        entry.dispose();
      }
    });
  }

  void _resetLocalNotes() {
    _editableNotes = {
      for (final section in _sectionTitles.keys)
        section: List<_NoteEntry>.from(
          _getSectionList(widget.notes, section).map(
            (note) => _NoteEntry(id: _uuid.v4(), value: note),
          ),
        ),
    };
  }

  List<String> _getSectionList(Notes notes, String section) {
    switch (section) {
      case 'personalNotes':
        return notes.personalNotes;
      case 'proTips':
        return notes.proTips;
      case 'storage':
        return notes.storage;
      case 'makeAheadMethod':
        return notes.makeAheadMethod;
      case 'reheatingLeftovers':
        return notes.reheatingLeftovers;
      case 'other':
        return notes.other;
      default:
        return [];
    }
  }

  void _deleteNote(String section, int index) {
    setState(() {
      _editableNotes[section]![index].dispose();
      _editableNotes[section]!.removeAt(index);
    });
    _emitChange();
  }

  void _addNote(String section) {
    setState(() {
      _editableNotes[section]!.add(_NoteEntry(id: _uuid.v4(), value: ''));
    });
    _emitChange();
  }

  void _onTextFieldFocusLost() {
    _emitChange();
  }

  void _emitChange() {
    if (widget.onNotesChanged != null) {
      widget.onNotesChanged!(
        Notes(
          personalNotes: _editableNotes['personalNotes']!.map((e) => e.value).toList(),
          proTips: _editableNotes['proTips']!.map((e) => e.value).toList(),
          storage: _editableNotes['storage']!.map((e) => e.value).toList(),
          makeAheadMethod: _editableNotes['makeAheadMethod']!.map((e) => e.value).toList(),
          reheatingLeftovers: _editableNotes['reheatingLeftovers']!.map((e) => e.value).toList(),
          other: _editableNotes['other']!.map((e) => e.value).toList(),
        ),
      );
    }
  }

  Widget _buildNotesList(String section, String title) {
    final notes = _editableNotes[section]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notes.isEmpty && !widget.isEditable)
          Text('No ${title.toLowerCase()} yet.',
              style: const TextStyle(fontStyle: FontStyle.italic)),
        ...notes.asMap().entries.map((entry) {
          final index = entry.key;
          final noteEntry = entry.value;

          return Padding(
            key: ValueKey(noteEntry.id),
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: widget.isEditable
                      ? Row(
                          children: [
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) {
                                    _onTextFieldFocusLost();
                                  }
                                },
                                child: TextFormField(
                                  controller: noteEntry.controller,
                                  onChanged: (newText) {
                                    noteEntry.value = newText;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteNote(section, index),
                            ),
                          ],
                        )
                      : Text(noteEntry.controller.text,
                          style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        }),
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton.icon(
              onPressed: () => _addNote(section),
              icon: const Icon(Icons.add),
              label: Text('Add to ${title.toLowerCase()}'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ExpansionPanelList.radio(
          children: _sectionTitles.entries.map((entry) {
            return ExpansionPanelRadio(
              value: entry.key,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    entry.value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildNotesList(entry.key, entry.value),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Internal note row structure with stable ID and controller
class _NoteEntry {
  final String id;
  String value;
  final TextEditingController controller;

  _NoteEntry({
    required this.id,
    required this.value,
  }) : controller = TextEditingController(text: value);

  void dispose() {
    controller.dispose();
  }

  void updateControllerText() {
    if (controller.text != value) {
      controller.text = value;
    }
  }

  _NoteEntry copyWith({String? id, String? value}) {
    final newValue = value ?? this.value;
    final newEntry = _NoteEntry(id: id ?? this.id, value: newValue);
    newEntry.controller.text = newValue;
    return newEntry;
  }
}