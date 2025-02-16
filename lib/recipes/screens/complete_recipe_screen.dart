// complete_recipe_screen.dart

 // DELETE CALLBACK FUNCTIONS?
 // IMPLEMENT GRANULAR EDITING CAPABILITIES FOR EACH WIDGET
 // TEST EDITING CAPABILITIES

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
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/notes_widget.dart';
import '../utils/notes_callbacks.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/nutrition_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/tags_widget.dart';
import 'package:flutter_portfolio_app/recipes/services/recipe_service.dart';
class CompleteRecipeScreen extends StatefulWidget {
  
  final Recipe recipe;
  const CompleteRecipeScreen({required this.recipe});

  @override
  _CompleteRecipeScreenState createState() => _CompleteRecipeScreenState();
}


class _CompleteRecipeScreenState extends State<CompleteRecipeScreen> {
  bool isEditMode = false;
  late Recipe recipe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    setState(() => isLoading = true);
    try {
      recipe = await fetchRecipe(widget.recipe.id);
    } catch (e) {
      print(e);
    }
    setState(() => isLoading = false);
  }

  Future<void> _saveRecipe() async {
    await RecipeService().updateRecipe(recipe);
    _loadRecipe();
  }

  void _toggleEditMode() {
    if (isEditMode) {
      showDiscardChangesDialog(context, () {
        setState(() => isEditMode = false);
      });
    } else {
      setState(() => isEditMode = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveRecipe();
                setState(() => isEditMode = false);
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
              OverviewWidget(
                title: recipe.title,
                totalCookTime: recipe.totalTime,
                rating: recipe.rating,
                reviewCount: recipe.reviewsCount,
              ),
              SizedBox(height: 16),
              MoreDetailsWidget(
                prepTime: recipe.prepTime,
                cookTime: recipe.cookTime,
                restTime: recipe.restTime,
                description: recipe.description,
              ),
              SizedBox(height: 16),
              ImageCarouselWidget(images: recipe.images),
              SizedBox(height: 16),
              IngredientsWidget(
                isEditable: isEditMode,
                ingredients: recipe.ingredients,
                servings: recipe.servings.toDouble(),
              ),
              SizedBox(height: 16),
              EquipmentWidget(equipment: recipe.equipment),
              SizedBox(height: 16),
              InstructionsWidget(
                instructions: recipe.instructions,
                isEditable: isEditMode,
              ),
              SizedBox(height: 16),
              NotesWidget(
                notes: recipe.notes,
                isEditable: isEditMode,
              ),
              SizedBox(height: 16),
              NutritionWidget(
                nutrition: recipe.nutrition,
              ),
              SizedBox(height: 16),
              TagsWidget(tags: recipe.tags),
            ],
          ),
        ),
      ),
    );
  }
}
// class CompleteRecipeScreen extends StatefulWidget {
  
//   final Recipe recipe;
//   const CompleteRecipeScreen({required this.recipe});

//   @override
//   _CompleteRecipeScreenState createState() => _CompleteRecipeScreenState();
// }

// class _CompleteRecipeScreenState extends State<CompleteRecipeScreen> {
//   bool isEditMode = false; // Toggle between view and edit mode

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recipe'),
//         actions: [
//           if (isEditMode)
//             IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 setState(() {
//                   isEditMode = false; // Cancel edit mode
//                 });
//               },
//             ),
//           IconButton(
//             icon: Icon(isEditMode ? Icons.save : Icons.edit),
//             onPressed: () {
//               if (isEditMode) {
//                 // TODO: SAVE THE RECIPE CHANGES. 
//                 // TODO: ADD A CONFIRMATION DIALOG TO SAVE THE RECIPE CHANGES.
//                 setState(() {
//                   isEditMode = false;
//                 });
//               } else {
//                 setState(() {
//                   isEditMode = true;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Overview Widget
//               OverviewWidget(
//                 title: widget.recipe.title,
//                 totalCookTime: widget.recipe.totalTime,
//                 rating: widget.recipe.rating,
//                 reviewCount: widget.recipe.reviewsCount,
//               ),

//               SizedBox(height: 16),

//               // More Details Placeholder
//               MoreDetailsWidget(
//                 prepTime: widget.recipe.prepTime,
//                 cookTime: widget.recipe.cookTime,
//                 restTime: widget.recipe.restTime,
//                 description: widget.recipe.description,
//               ),

//               SizedBox(height: 16),

//               // Image Carousel Placeholder
//               ImageCarouselWidget(
//                 images: widget.recipe.images,
//               ),

//               SizedBox(height: 16),

//               //Ingredients
//               IngredientsWidget(
//                 isEditable: isEditMode,
//                 ingredients: widget.recipe.ingredients,
//                 servings: widget.recipe.servings.toDouble(),
//               ),

//               SizedBox(height: 16),

//               // Equipment 
//               EquipmentWidget(equipment: widget.recipe.equipment),

//               SizedBox(height: 16),

//               // Instructions
//               InstructionsWidget(
//                 instructions: widget.recipe.instructions,
//                 isEditable: isEditMode,
//                 onSectionTitleChanged: (sectionIndex, newTitle) => 
//                     InstructionCallbacks.updateSectionTitle(widget.recipe, setState, sectionIndex, newTitle),
//                 onStepChanged: (sectionIndex, stepIndex, newStep) =>
//                     InstructionCallbacks.updateStep(widget.recipe, setState, sectionIndex, stepIndex, newStep),
//                 onDeleteSection: (sectionIndex) =>
//                     InstructionCallbacks.deleteSection(widget.recipe, setState, sectionIndex),
//                 onDeleteStep: (sectionIndex, stepIndex) =>
//                     InstructionCallbacks.deleteStep(widget.recipe, setState, sectionIndex, stepIndex),
//                 onAddSection: () =>
//                     InstructionCallbacks.addSection(widget.recipe, setState),
//                 onAddStep: (sectionIndex) =>
//                     InstructionCallbacks.addStep(widget.recipe, setState, sectionIndex),
//               ),

//               SizedBox(height: 16),

//               // Notes
//               NotesWidget(
//                 notes: widget.recipe.notes,
//                 isEditable: isEditMode,
//                 onNoteChanged: (section, noteIndex, value) {
//                   NotesCallbacks.updateNote(widget.recipe, setState, section, noteIndex, value);
//                 },
//                 onNoteDeleted: (section, noteIndex) {
//                   NotesCallbacks.deleteNote(widget.recipe, setState, section, noteIndex);
//                 },
//                 onNoteAdded: (section) {
//                   NotesCallbacks.addNote(widget.recipe, setState, section);
//                 },
//               ),

//               SizedBox(height: 16),

//               //Nutrition 
//               NutritionWidget(
//                 // TODO: MAKE NUTRITION VALUES EDITABLE!!!
//                 nutrition: widget.recipe.nutrition,
//               ),

//               SizedBox(height: 16),

//               // Tags Placeholder
//               TagsWidget(tags: widget.recipe.tags),

//               SizedBox(height: 16),

//               // Related Recipes Placeholder
//               PlaceholderWidget(title: 'Related Recipes Placeholder'),

//               SizedBox(height: 16),

//               // Comments Placeholder
//               PlaceholderWidget(title: 'Comments Placeholder'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// A simple widget to act as a placeholder for sections
// class PlaceholderWidget extends StatelessWidget {
//   final String title;

//   const PlaceholderWidget({Key? key, required this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Center(
//         child: Text(
//           title,
//           style: TextStyle(color: Colors.grey, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
