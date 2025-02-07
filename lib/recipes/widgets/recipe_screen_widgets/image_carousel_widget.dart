// image_carousel_widget.dart

import 'package:flutter/material.dart';

// TODO: REMOVE TEXT LABELS BEFORE PRODUCTION

class ImageCarouselWidget extends StatelessWidget {
  final List<String> yourImages; // URLs or paths to your associated images
  final List<String> publicImages; // URLs or paths to public images

  const ImageCarouselWidget({
    Key? key,
    required this.yourImages,
    required this.publicImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> allImages = [...yourImages, ...publicImages];
    final List<String> labels = [
      ...List.generate(yourImages.length, (_) => "Your Image"),
      ...List.generate(publicImages.length, (_) => "Public Image")
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100, // Adjust based on desired size (approximately 0.5 x 0.5 inches)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        allImages[index],
                        width: 80, // Adjust width/height for size
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(                             //!!!!!!!!! REMOVE BEFORE PRODUCTION !!!!!!!!!
                      labels[index],
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis, // Truncate text
                      textAlign: TextAlign.center, // Center-align the label under the image
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
