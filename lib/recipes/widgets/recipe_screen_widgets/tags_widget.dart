// tags_widget.dart
import 'package:flutter/material.dart';

class TagsWidget extends StatefulWidget {
  final List<String> tags;
  final bool isEditable;
  final Function(List<String>)? onTagsChanged;

  const TagsWidget({
    Key? key,
    required this.tags,
    this.isEditable = false,
    this.onTagsChanged,
  }) : super(key: key);

  @override
  _TagsWidgetState createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  late List<String> _localTags;
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localTags = List<String>.from(widget.tags);
  }

  @override
  void didUpdateWidget(covariant TagsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tags != oldWidget.tags) {
      setState(() {
        _localTags = List<String>.from(widget.tags);
      });
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isEmpty || _localTags.contains(tag.trim())) return;
    setState(() {
      _localTags.add(tag.trim());
      _tagController.clear();
    });
    widget.onTagsChanged?.call(_localTags);
  }

  void _removeTag(String tag) {
    setState(() {
      _localTags.remove(tag);
    });
    widget.onTagsChanged?.call(_localTags);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _localTags.map((tag) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(tag),
                  backgroundColor: theme.chipTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  deleteIcon: widget.isEditable ? const Icon(Icons.close) : null,
                  onDeleted: widget.isEditable ? () => _removeTag(tag) : null,
                ),
              )).toList(),
            ),
          ),
          if (widget.isEditable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      labelText: 'Add tag',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor,
                    ),
                    onFieldSubmitted: _addTag,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTag(_tagController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}