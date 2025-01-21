// recipe_source_selection.dart

import 'package:flutter/material.dart';


class CreateRecipeSourceWidget extends StatelessWidget {
  final Function onCameraSelected;
  final Function onPhotosSelected;
  final Function onManuallySelected;

  const CreateRecipeSourceWidget({
    Key? key,
    required this.onCameraSelected,
    required this.onPhotosSelected,
    required this.onManuallySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Save Recipe from',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              _buildOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => onCameraSelected(),
              ),
              _buildOption(
                context,
                icon: Icons.photo_library,
                label: 'Photos',
                onTap: () => onPhotosSelected(),
              ),
              _buildOption(
                context,
                icon: Icons.edit,
                label: 'Manually',
                onTap: () => onManuallySelected(),
              ),
              _buildOption(
                context,
                icon: Icons.language,
                label: 'Internet',
                onTap: () => _showComingSoon(context),
              ),
              _buildOption(
                context,
                icon: Icons.document_scanner,
                label: 'Scan',
                onTap: () => _showComingSoon(context),
              ),
              _buildOption(
                context,
                icon: Icons.description,
                label: 'Docs',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'The Free Version of Remy allows you to save a maximum of 5 recipes. To enjoy unlimited recipes, upgrade to the Premium Version.',
            style: TextStyle(fontSize: 12, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Coming Soon'),
        content: Text('This feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
