// notes_widget.dart
import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class NotesWidget extends StatefulWidget {
  final Notes notes;
  final bool isEditable;
  final Function(String, int, String)? onNoteChanged;
  final Function(String, int)? onNoteDeleted;
  final Function(String)? onNoteAdded;

  const NotesWidget({
    Key? key,
    required this.notes,
    this.isEditable = false,
    this.onNoteChanged,
    this.onNoteDeleted,
    this.onNoteAdded,
  }) : super(key: key);

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  late Map<String, List<TextEditingController>> _noteControllers;

  final Map<String, String> _sectionTitles = {
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
    _initializeControllers();
  }

  /// Initialize each notes section with a list of TextControllers,
  /// one controller per line of text.
  void _initializeControllers() {
    _noteControllers = {};
    for (var section in _sectionTitles.keys) {
      // Split the notes into lines (including empty lines).
      List<String> notes = _getNotes(section);
      _noteControllers[section] = notes
          .map((note) => TextEditingController(text: note))
          .toList();
    }
  }

  /// Return the lines of text for a given section without filtering out empties.
  List<String> _getNotes(String section) {
    String notesText = switch (section) {
      'personalNotes' => widget.notes.personalNotes,
      'proTips' => widget.notes.proTips,
      'storage' => widget.notes.storage,
      'makeAheadMethod' => widget.notes.makeAheadMethod,
      'reheatingLeftovers' => widget.notes.reheatingLeftovers,
      'other' => widget.notes.other,
      _ => '',
    };
    // Split on newline, preserve empty lines
    return notesText.split('\n');
  }

  /// IMPORTANT: Do NOT rebuild controllers on every new widget update,
  /// or typing will cause "reversed text" symptoms.
  /// Only do it if you truly detect a brand-new notes object (for instance, a new recipe).
  @override
  void didUpdateWidget(NotesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the entire notes object changed in a big way (e.g. new recipe ID),
    // you might re-init. Otherwise, do nothing to avoid reversing typed text.
    // Example condition: if (widget.notes != oldWidget.notes) { ... }
  }

  @override
  void dispose() {
    for (var controllers in _noteControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Widget _buildNotesList(String section, String title) {
    var controllers = _noteControllers[section] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controllers.isEmpty && !widget.isEditable)
          Text(
            'No ${title.toLowerCase()} added yet',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controllers.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: widget.isEditable
                        ? Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllers[index],
                                  onChanged: (value) {
                                    // Let the parent know about the change
                                    widget.onNoteChanged
                                        ?.call(section, index, value);
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: null,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // First inform the parent
                                  widget.onNoteDeleted?.call(section, index);
                                  // Then remove from local controllers
                                  setState(() {
                                    controllers[index].dispose();
                                    controllers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          )
                        : Text(
                            controllers[index].text,
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // First tell the parent we're adding a new note
                widget.onNoteAdded?.call(section);
                // Then add a new controller for an empty line locally
                setState(() {
                  controllers.add(TextEditingController(text: ''));
                });
              },
              icon: const Icon(Icons.add),
              label: Text('Add to ${title.toLowerCase()}'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildNotesList(entry.key, entry.value),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}