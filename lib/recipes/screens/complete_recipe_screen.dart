// complete_recipe_screen.dart

// TODO: ADD PUBLIC IMAGES ATTRIBUTE TO RECIPE MODEL

// TODO: implement the menu item functions

import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/overview_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/more_details_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/ingredients_section/ingredients_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/equipment_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/instructions_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/notes_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/nutrition_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/tags_widget.dart';
import 'package:flutter_portfolio_app/recipes/services/recipe_service.dart';
import 'loading_screen.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_bottom_nav_bar.dart';
import 'package:flutter_portfolio_app/recipes/widgets/favorite_button_widget.dart';
import 'package:flutter_portfolio_app/recipes/widgets/recipe_screen_widgets/delete_recipe_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_portfolio_app/recipes/providers/user_profile_provider.dart';
import 'package:flutter_portfolio_app/recipes/providers/recipe_lists_provider.dart';
import 'package:provider/provider.dart';


class CompleteRecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const CompleteRecipeScreen({required this.recipe});

  @override
  _CompleteRecipeScreenState createState() => _CompleteRecipeScreenState();
}

class _CompleteRecipeScreenState extends State<CompleteRecipeScreen> {
  bool isEditMode = false;
  late Recipe recipe;
  late Recipe originalRecipe;
  final RecipeService recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
    originalRecipe = recipe.copyWith(); // deep copy of the recipe
  }

  /// Toggles edit mode and handles discarding edits
  void _toggleEditMode() {
    if (isEditMode) {
      _confirmDiscardChanges(); // Ask for confirmation before discarding edits
    } else {
      setState(() {
        isEditMode = true;
      });
    }
  }

  Future<void> _handleRecipeDeletion() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final recipeId = recipe.id;

    if (userId == null || recipeId.isEmpty) return;
    if (recipe.ownerId != userId) return;

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );

      final firestore = FirebaseFirestore.instance;

      // 1. Delete recipe document
      await firestore.collection('recipes').doc(recipeId).delete();

      // 2. Remove from userProfile.userRecipeIds
      final userRef = firestore.collection('user_profiles').doc(userId);
      await userRef.update({
        'userRecipeIds': FieldValue.arrayRemove([recipeId]),
        'favoriteRecipeIds': FieldValue.arrayRemove([recipeId])
      });

      // 3. Remove from my_recipes list
      final myRecipesListRef = userRef.collection('lists').doc('my_recipes');
      await myRecipesListRef.update({
        'recipeIds': FieldValue.arrayRemove([recipeId])
      });

      // 4. Remove from all user lists
      final listSnapshot = await userRef.collection('lists').get();
      for (var doc in listSnapshot.docs) {
        await doc.reference.update({
          'recipeIds': FieldValue.arrayRemove([recipeId])
        });
      }

      // update providers
      context.read<UserProfileProvider>().removeRecipeFromFavorites(recipeId);
      context.read<RecipeListsProvider>().removeRecipeFromLists(recipeId);


      // Done — pop the loading indicator
      Navigator.of(context).pop();

      // Navigate home or pop current route
      Navigator.of(context).pop(); // go back one screen

      // Optional: show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading if there's an error

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }


  // Shows a confirmation dialog for discarding changes
  Future<void> _confirmDiscardChanges() async {
    bool discard = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Changes?'),
        content: Text('Are you sure you want to exit? You may have unsaved changes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Discard'),
          ),
        ],
      ),
    ) ?? false;

    if (discard) {
      setState(() {
        isEditMode = false;
        recipe = originalRecipe; // Restore the original recipe
      });
    }
  }

  /// Shows a confirmation dialog before saving
  Future<void> _confirmSaveRecipe() async {
    bool save = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Changes?'),
        content: Text('Are you sure you want to save your edits?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Save'),
          ),
        ],
      ),
    ) ?? false;

    if (save) {
      _saveRecipe();
    }
  }

  /// Saves the recipe and refreshes the screen
  Future<void> _saveRecipe() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingScreen()));

    await recipeService.updateRecipe(recipe);
    Recipe updatedRecipe = await recipeService.fetchRecipe(recipe.id);

    Navigator.pop(context); // Close loading screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CompleteRecipeScreen(recipe: updatedRecipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Text(recipe.title),
          ],
        ),
        centerTitle: true,
        actions: [      
          FavoriteButtonWidget(
            recipeId: recipe.id,
          ),
          IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _confirmSaveRecipe, // Use confirmation before saving
            ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Add to List'),
                value: 'add_to_list',
              ),
              PopupMenuItem(
                child: Text('Share'),
                value: 'share',
              ),
              if (recipe.ownerId == FirebaseAuth.instance.currentUser?.uid)
                PopupMenuItem(
                  child: Text('Delete'),
                  value: 'delete',
                ),
            ],
            onSelected: (value) {
              // Handle menu item selection
              switch (value) {
                case 'add_to_list':
                  // TODO: Show add to list dialog
                  break;
                case 'share':
                  // TODO: Show share dialog
                  break;
                case 'delete':
                  // TODO: Show delete confirmation
                  break;
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
              OverviewWidget(
                title: recipe.title,
                totalCookTime: recipe.totalTime,
                rating: recipe.rating,
                reviewCount: recipe.reviewsCount,
                isEditable: isEditMode,
                onTitleChanged: (newTitle) => setState(() => recipe = recipe.copyWith(title: newTitle)),
                onTotalCookTimeChanged: (newTime) => setState(() => recipe = recipe.copyWith(totalTime: newTime)),
              ),

              SizedBox(height: 16),

              MoreDetailsWidget(
                prepTime: recipe.prepTime,
                cookTime: recipe.cookTime,
                restTime: recipe.restTime,
                description: recipe.description,
                isEditable: isEditMode,
                onPrepTimeChanged: (newPrepTime) => setState(() => recipe = recipe.copyWith(prepTime: newPrepTime)),
                onCookTimeChanged: (newCookTime) => setState(() => recipe = recipe.copyWith(cookTime: newCookTime)),
                onRestTimeChanged: (newRestTime) => setState(() => recipe = recipe.copyWith(restTime: newRestTime)),
                onDescriptionChanged: (newDescription) => setState(() => recipe = recipe.copyWith(description: newDescription)),
              ),

              SizedBox(height: 16),

              IngredientsWidget(
                isEditable: isEditMode,
                ingredients: recipe.ingredients,
                servings: recipe.servings.toDouble(),
                servingsUnit: recipe.servingsUnit,
                onIngredientsChanged: (updatedIngredients) {
                  setState(() {
                    recipe = recipe.copyWith(ingredients: updatedIngredients);
                  });
                },
                onServingsChanged: (updatedServings) {
                  setState(() {
                    recipe = recipe.copyWith(servings: updatedServings.toDouble());
                  });
                },
                onServingsUnitChanged: (updatedServingsUnit) {
                  setState(() {
                    recipe = recipe.copyWith(servingsUnit: updatedServingsUnit);
                  });
                },
              ),

              SizedBox(height: 16),

              EquipmentWidget(
                equipment: recipe.equipment,
                isEditable: isEditMode,
                onEquipmentChanged: (updatedEquipment) => setState(() {
                  recipe = recipe.copyWith(equipment: updatedEquipment);
                }),
              ),

              SizedBox(height: 16),

              InstructionsWidget(
                instructions: recipe.instructions,
                isEditable: isEditMode,
                onSectionTitleChanged: (sectionIndex, newTitle) {
                  final updated = [...recipe.instructions];
                  final updatedSection = updated[sectionIndex].copyWith(sectionTitle: newTitle);
                  updated[sectionIndex] = updatedSection;

                  setState(() {
                    recipe = recipe.copyWith(instructions: updated);
                  });
                },
                onStepChanged: (sectionIndex, stepIndex, newStep) {
                  final updated = [...recipe.instructions];
                  final steps = [...updated[sectionIndex].steps];
                  steps[stepIndex] = newStep;

                  updated[sectionIndex] = updated[sectionIndex].copyWith(steps: steps);

                  setState(() {
                    recipe = recipe.copyWith(instructions: updated);
                  });
                },
                onDeleteStep: (sectionIndex, stepIndex) {
                  final updated = [...recipe.instructions];
                  final steps = [...updated[sectionIndex].steps];
                  steps.removeAt(stepIndex);

                  updated[sectionIndex] = updated[sectionIndex].copyWith(steps: steps);

                  setState(() {
                    recipe = recipe.copyWith(instructions: updated);
                  });
                },
                onDeleteSection: (sectionIndex) {
                  final updated = [...recipe.instructions]..removeAt(sectionIndex);

                  setState(() {
                    recipe = recipe.copyWith(instructions: updated);
                  });
                },
                onAddSection: () {
                  final updated = [...recipe.instructions]
                    ..add(InstructionSection(sectionTitle: 'New Section', steps: ['New Step']));

                  setState(() {
                    recipe = recipe.copyWith(instructions: updated);
                  });
                },
                onAddStep: (sectionIndex) {
                  final updated = [...recipe.instructions];
                  final steps = [...updated[sectionIndex].steps]..add('New Step');

                  updated[sectionIndex] = updated[sectionIndex].copyWith(steps: steps);

                  setState(() {
                    recipe = recipe.copyWith(instructions: updated);
                  });
                },
              ),

              SizedBox(height: 16),

              NotesWidget(
                notes: recipe.notes,
                isEditable: isEditMode,
                onNotesChanged: (updatedNotes) {
                  setState(() {
                    recipe = recipe.copyWith(notes: updatedNotes);
                  });
                },
              ),

              SizedBox(height: 16),

              NutritionWidget(
                nutrition: recipe.nutrition,
                isEditable: isEditMode,
                onNutritionChanged: (updated) {
                  setState(() {
                    recipe = recipe.copyWith(nutrition: updated);
                  });
                },
              ),

              SizedBox(height: 16),
              TagsWidget(
                tags: recipe.tags,
                isEditable: isEditMode,
                onTagsChanged: (updatedTags) {
                  setState(() {
                    recipe = recipe.copyWith(tags: updatedTags);
                  });
                },
              ),

              SizedBox(height: 16),
              PlaceholderWidget(title: 'Related Recipes Placeholder'),
              SizedBox(height: 16),
              PlaceholderWidget(title: 'Comments Placeholder'),
              
              SizedBox(height: 16),
              if (isEditMode)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: DeleteRecipeButton(
                  onConfirmDelete: _handleRecipeDeletion,
                ),
              ),
                
            ],
          ),
        ),
      ),
      bottomNavigationBar: RecipeBottomNavBar(),    
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
