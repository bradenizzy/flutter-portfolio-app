// title_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OverviewWidget extends StatelessWidget {
  final String title;
  final String totalCookTime;
  final double rating;
  final int reviewCount;

  const OverviewWidget({
    Key? key,
    required this.title,
    required this.totalCookTime,
    required this.rating,
    required this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the column content
        children: [
          // Recipe Title
          Center( // Center the title
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          // Total Cook Time and Rating Row
          Center( // Center the row
            child: Row(
              mainAxisSize: MainAxisSize.min, // Center the row content
              children: [
                // Cook Time
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(
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
                    // Star Rating
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

                    // Rating Text
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
