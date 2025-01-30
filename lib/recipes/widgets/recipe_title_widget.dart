// recipe_title_widget.dart

//  FIRST TODO !!!!!!! TODO: IMPLEMENT RECIPE EDIT SCREEN !!!!!!!

import 'dart:io';
import 'package:flutter/material.dart';
import 'image_selection_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';
//import 'package:flutter_portfolio_app/recipes/models/notes.dart';
//import 'package:flutter_portfolio_app/recipes/models/nutrition.dart';
//import 'package:flutter_portfolio_app/recipes/screens/recipe_edit_screen.dart';

class RecipeTitleWidget extends StatefulWidget {
  final String source; // Source: Camera, Photos, or Manually

  const RecipeTitleWidget({Key? key, required this.source}) : super(key: key);

  @override
  _RecipeTitleWidgetState createState() => _RecipeTitleWidgetState();
}

class _RecipeTitleWidgetState extends State<RecipeTitleWidget> {
  final TextEditingController _titleController = TextEditingController();
  List<File> _selectedImages = [];
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    if (widget.source == 'Camera' || widget.source == 'Photos') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openImageSelector();
      });
    }
  }

  Future<void> _openImageSelector() async {
    if (_isNavigating) return; // Prevent duplicate navigation
    _isNavigating = true;

    final List<File>? images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageSelectionWidget(
          onImagesSelected: (selectedImages) {
            setState(() {
              for (var image in selectedImages) {
                if (!_selectedImages.contains(image)) {
                  _selectedImages.add(image);
                }
              }
            });
          },
        ),
      ),
    );

    _isNavigating = false; // Reset navigation flag

    if (images != null) {
      setState(() {
        for (var image in images) {
          if (!_selectedImages.contains(image)) {
            _selectedImages.add(image);
          }
        }
      });
    }
  }

  void _handleSave() async {
    if (_titleController.text.isEmpty) {
      // Prompt user to enter a title
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a recipe title')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Generate unique recipe ID
      final recipeId = FirebaseFirestore.instance.collection('recipes').doc().id;

      String generateImageName() {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        return '${userId}_$timestamp.jpg';
      }

      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (var image in _selectedImages) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('recipes/$recipeId/images/${generateImageName()}');
        final uploadTask = await ref.putFile(image);
        final imageUrl = await uploadTask.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Prepare Recipe object
      final recipe = Recipe(
        id: recipeId,
        images: imageUrls,
        title: _titleController.text,
        prepTime: '', // Placeholder for now
        cookTime: '',
        restTime: '',
        totalTime: '',
        rating: 0.0,
        reviewsCount: 0,
        servings: 0,
        tags: [],
        description: '',
        ingredients: [],
        ingredientsFormat: '',
        equipment: [],
        instructions: [],
        notes: Notes(),
        personalNotes: '',
        nutrition: Nutrition(),
        link: '',
        author: FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown Author',
        source: 'Custom',
        isPublic: false,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .set(recipe.toJson());

      // TODO: Integrate with OpenAI API
      // Simulate sending images to OpenAI and processing JSON response
      // This will be implemented in the future

      // Close loading indicator
      Navigator.of(context).pop();

      // Navigate to Recipe Screen in "edit mode"
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RecipeEditScreen(recipe: recipe),
      //     // !!!!!!! TODO: IMPLEMENT RECIPE EDIT SCREEN !!!!!!!
      //   ),
      // );
    } catch (e) {
      // Handle errors
      Navigator.of(context).pop(); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImages.isNotEmpty || widget.source != 'Manually')
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length + 1, // +1 for the "Add More" box
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      // Add More box
                      return GestureDetector(
                        onTap: _openImageSelector,
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 50, color: Colors.black54),
                              SizedBox(height: 8),
                              Text(
                                'Add more photos',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              _selectedImages[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              )
            else
              GestureDetector(
                onTap: _openImageSelector,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      widget.source == 'Photos' ? 'Choose a Photo' : 'Snap a Photo',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter recipe name',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _handleSave,
              child: Text('Start Cooking'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}