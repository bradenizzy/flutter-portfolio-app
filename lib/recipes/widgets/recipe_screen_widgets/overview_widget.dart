// overview_widget.dart

// TODO: 
// - Improved Input UX for Time Field such as by forcing hh:mm format or using a TimePicker widget

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OverviewWidget extends StatelessWidget {
  final String title;
  final String totalCookTime;
  final double rating;
  final int reviewCount;
  final bool isEditable;
  final Function(String) onTitleChanged;
  final Function(String) onTotalCookTimeChanged;

  const OverviewWidget({
    Key? key,
    required this.title,
    required this.totalCookTime,
    required this.rating,
    required this.reviewCount,
    this.isEditable = false,
    required this.onTitleChanged,
    required this.onTotalCookTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Recipe Title (Editable)
          Center(
            child: isEditable
                ? TextFormField(
                    initialValue: title,
                    decoration: InputDecoration(
                      labelText: "Recipe Title",
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    onChanged: onTitleChanged,
                  )
                : Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(height: 8.0),

          // Total Cook Time and Rating Row
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cook Time (Editable)
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    isEditable
                        ? SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: totalCookTime,
                              decoration: InputDecoration(
                                labelText: "Time",
                                border: OutlineInputBorder(),
                              ),
                              textAlign: TextAlign.center,
                              onChanged: onTotalCookTimeChanged,
                            ),
                          )
                        : Text(
                            totalCookTime,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: 16.0),

                // Divider
                const Text(
                  '|',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16.0),

                // Rating
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '(${reviewCount.toString()})',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}