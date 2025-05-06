// cookbooks_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_lists_provider.dart';
import '../widgets/recipe_preview_card.dart';
import '../widgets/recipe_bottom_nav_bar.dart';
import '../screens/complete_recipe_screen.dart';
import '../models/recipe_list.dart';

/// Screen: CookbooksScreen
class CookbooksScreen extends StatefulWidget {
  @override
  _CookbooksScreenState createState() => _CookbooksScreenState();
}

class _CookbooksScreenState extends State<CookbooksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeListsProvider>().loadLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeListsProvider>();
    final lists = provider.lists;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateListDialog(context),
          )
        ],
      ),
      body: lists.isEmpty
          ? Center(child: Text('No lists found.'))
          : ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final list = lists[index];
                final recipes = provider.getRecipesForList(list.listId);
                return ExpansionTile(
                  title: Text(list.title),
                  initiallyExpanded: index == 0,
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(context, list),
                  ),
                  children: recipes.map((recipe) {
                    return RecipePreviewCard(
                      recipe: recipe,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompleteRecipeScreen(recipe: recipe),
                        ),
                      ),
                      onUnfavorite: () {
                        // Optional: remove from list if you want this interaction here
                      },
                    );
                  }).toList(),
                );
              },
            ),
      bottomNavigationBar: RecipeBottomNavBar(),
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Create New List'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'List title'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Create'),
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                await context.read<RecipeListsProvider>().createNewList(title);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, RecipeList list) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete List'),
        content: Text('Are you sure you want to delete "${list.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
            onPressed: () async {
              await context.read<RecipeListsProvider>().deleteList(list.listId);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}



