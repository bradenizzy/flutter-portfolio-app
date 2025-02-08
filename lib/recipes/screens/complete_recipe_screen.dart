// complete_recipe_screen.dart

 // TODO: ADD PUBLIC IMAGES ATTRIBUTE TO RECIPE MODEL

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/overview_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/more_details_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/image_carousel_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/ingredients_section/ingredients_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/equipment_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/instructions_widget.dart';
import 'package:flutter_portfolio_app/recipes/utils/instruction_callbacks.dart';
class CompleteRecipeScreen extends StatefulWidget {
  
  final Recipe recipe;
  const CompleteRecipeScreen({required this.recipe});

  @override
  _CompleteRecipeScreenState createState() => _CompleteRecipeScreenState();
}

class _CompleteRecipeScreenState extends State<CompleteRecipeScreen> {
  bool isEditMode = false; // Toggle between view and edit mode
  final String publicImage = "https://firebasestorage.googleapis.com/v0/b/flutter-portfolio-app-izzy.firebasestorage.app/o/IMG_0405.JPG?alt=media&token=b2a29311-8940-4606-9214-07469a98cac6";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  isEditMode = false; // Cancel edit mode
                });
              },
            ),
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditMode) {
                // TODO: SAVE THE RECIPE CHANGES. 
                // TODO: ADD A CONFIRMATION DIALOG TO SAVE THE RECIPE CHANGES.
                setState(() {
                  isEditMode = false;
                });
              } else {
                setState(() {
                  isEditMode = true;
                });
              }
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
              // Overview Widget
              OverviewWidget(
                title: widget.recipe.title,
                totalCookTime: widget.recipe.totalTime,
                rating: widget.recipe.rating,
                reviewCount: widget.recipe.reviewsCount,
              ),

              SizedBox(height: 16),

              // More Details Placeholder
              MoreDetailsWidget(
                prepTime: widget.recipe.prepTime,
                cookTime: widget.recipe.cookTime,
                restTime: widget.recipe.restTime,
                totalTime: widget.recipe.totalTime,
                rating: widget.recipe.rating,
                reviewsCount: widget.recipe.reviewsCount,
                description: widget.recipe.description,
              ),

              SizedBox(height: 16),

              // Image Carousel Placeholder
              ImageCarouselWidget(
                yourImages: widget.recipe.images,
                publicImages: [publicImage, publicImage, publicImage, publicImage],
                //publicImages: widget.recipe.publicImages, // TODO: ADD PUBLIC IMAGES ATTRIBUTE TO RECIPE MODEL
              ),

              SizedBox(height: 16),

              //Ingredients
              IngredientsWidget(
                isEditable: isEditMode,
                ingredients: widget.recipe.ingredients,
              ),

              SizedBox(height: 16),

              // Equipment 
              EquipmentWidget(equipment: widget.recipe.equipment),

              SizedBox(height: 16),

              // Instructions
              InstructionsWidget(
                instructions: widget.recipe.instructions,
                isEditable: isEditMode,
                onSectionTitleChanged: (sectionIndex, newTitle) => 
                    InstructionCallbacks.updateSectionTitle(widget.recipe, setState, sectionIndex, newTitle),
                onStepChanged: (sectionIndex, stepIndex, newStep) =>
                    InstructionCallbacks.updateStep(widget.recipe, setState, sectionIndex, stepIndex, newStep),
                onDeleteSection: (sectionIndex) =>
                    InstructionCallbacks.deleteSection(widget.recipe, setState, sectionIndex),
                onDeleteStep: (sectionIndex, stepIndex) =>
                    InstructionCallbacks.deleteStep(widget.recipe, setState, sectionIndex, stepIndex),
                onAddSection: () =>
                    InstructionCallbacks.addSection(widget.recipe, setState),
                onAddStep: (sectionIndex) =>
                    InstructionCallbacks.addStep(widget.recipe, setState, sectionIndex),
              ),

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
