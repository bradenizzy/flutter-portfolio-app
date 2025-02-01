// complete_recipe_screen.dart

import 'package:flutter/material.dart';

class CompleteRecipeScreen extends StatefulWidget {
  const CompleteRecipeScreen({Key? key}) : super(key: key);

  @override
  _CompleteRecipeScreenState createState() => _CompleteRecipeScreenState();
}

class _CompleteRecipeScreenState extends State<CompleteRecipeScreen> {
  bool isEditMode = false; // Toggle between view and edit mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode; // Toggle edit mode
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Section Placeholder
              PlaceholderWidget(title: 'Overview Widget Placeholder'),

              SizedBox(height: 16),

              // More Details Placeholder
              PlaceholderWidget(title: 'More Details Placeholder'),

              SizedBox(height: 16),

              // Image Carousel Placeholder
              PlaceholderWidget(title: 'Image Carousel Placeholder'),

              SizedBox(height: 16),

              // Ingredients Placeholder
              PlaceholderWidget(title: 'Ingredients Placeholder'),

              SizedBox(height: 16),

              // Equipment Placeholder
              PlaceholderWidget(title: 'Equipment Placeholder'),

              SizedBox(height: 16),

              // Instructions Placeholder
              PlaceholderWidget(title: 'Instructions Placeholder'),

              SizedBox(height: 16),

              // Notes Placeholder
              PlaceholderWidget(title: 'Notes Placeholder'),

              SizedBox(height: 16),

              // Nutrition Placeholder
              PlaceholderWidget(title: 'Nutrition Placeholder'),

              SizedBox(height: 16),

              // Tags Placeholder
              PlaceholderWidget(title: 'Tags Placeholder'),

              SizedBox(height: 16),

              // Related Recipes Placeholder
              PlaceholderWidget(title: 'Related Recipes Placeholder'),

              SizedBox(height: 16),

              // Comments Placeholder
              PlaceholderWidget(title: 'Comments Placeholder'),
            ],
          ),
        ),
      ),
    );
  }
}

/// A simple widget to act as a placeholder for sections
class PlaceholderWidget extends StatelessWidget {
  final String title;

  const PlaceholderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
