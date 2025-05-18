// delete_recipe_button.dart

import 'package:flutter/material.dart';

class DeleteRecipeButton extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteRecipeButton({Key? key, required this.onConfirmDelete}) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Recipe"),
        content: Text("Are you sure you want to delete this recipe? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirmDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.delete_forever),
        label: Text('Delete Recipe'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontSize: 16),
        ),
        onPressed: () => _showDeleteConfirmationDialog(context),
      ),
    );
  }
}
