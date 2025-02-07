// more_details_widget.dart

import 'package:flutter/material.dart';

class MoreDetailsWidget extends StatefulWidget {
  final String prepTime;
  final String cookTime;
  final String restTime;
  final String totalTime;
  final double rating;
  final int reviewsCount;
  final String? description; // Optional description or AI summary.

  const MoreDetailsWidget({
    Key? key,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.totalTime,
    required this.rating,
    required this.reviewsCount,
    this.description,
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
              _buildDetailRow(Icons.timer, "Prep Time", widget.prepTime),
              _buildDetailRow(Icons.restaurant, "Cook Time", widget.cookTime),
              _buildDetailRow(Icons.hourglass_empty, "Rest Time", widget.restTime),
              _buildDetailRow(Icons.schedule, "Total Time", widget.totalTime),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text("${widget.rating} / ${widget.reviewsCount} reviews"),
                ],
              ),
              if (widget.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text("$label: "),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
