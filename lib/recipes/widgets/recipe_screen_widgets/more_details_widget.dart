// more_details_widget.dart

import 'package:flutter/material.dart';

class MoreDetailsWidget extends StatefulWidget {
  final String prepTime;
  final String cookTime;
  final String restTime;
  final String? description;
  final bool isEditable;
  final Function(String) onPrepTimeChanged;
  final Function(String) onCookTimeChanged;
  final Function(String) onRestTimeChanged;
  final Function(String) onDescriptionChanged;

  const MoreDetailsWidget({
    Key? key,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    this.description,
    this.isEditable = false,
    required this.onPrepTimeChanged,
    required this.onCookTimeChanged,
    required this.onRestTimeChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  _MoreDetailsWidgetState createState() => _MoreDetailsWidgetState();
}

class _MoreDetailsWidgetState extends State<MoreDetailsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row with "More Details" and caret
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "More Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Expanded Details
        Visibility(
          visible: _isExpanded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableDetailRow(Icons.timer, "Prep Time", widget.prepTime, widget.isEditable, widget.onPrepTimeChanged),
              _buildEditableDetailRow(Icons.restaurant, "Cook Time", widget.cookTime, widget.isEditable, widget.onCookTimeChanged),
              _buildEditableDetailRow(Icons.hourglass_empty, "Rest Time", widget.restTime, widget.isEditable, widget.onRestTimeChanged),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: widget.description ?? "",
                        decoration: InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: widget.onDescriptionChanged,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            "Description: ",
                            style: TextStyle(fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              (widget.description == null || widget.description!.isEmpty)
                                  ? "No description... yet"
                                  : widget.description!,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Creates a row that switches between Text and TextFormField
  Widget _buildEditableDetailRow(IconData icon, String label, String value, bool isEditable, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text("$label: "),
          isEditable
              ? Expanded(
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    ),
                    onChanged: onChanged,
                  ),
                )
              : Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}