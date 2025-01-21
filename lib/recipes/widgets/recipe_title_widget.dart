// recipe_title_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'image_selection_widget.dart';

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

  void _handleSave() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a recipe title')),
      );
    } else {
      print('Title: ${_titleController.text}');
      print('Images: ${_selectedImages.map((img) => img.path).toList()}');
      // TODO: Implement navigation to recipe creation page
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
              child: Text('Save'),
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



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'image_selection_widget.dart'; // Import your ImageSelectionWidget here

// class RecipeTitleWidget extends StatefulWidget {
//   final String source; // Source: Camera, Photos, or Manually

//   const RecipeTitleWidget({Key? key, required this.source}) : super(key: key);

//   @override
//   _RecipeTitleWidgetState createState() => _RecipeTitleWidgetState();
// }

// class _RecipeTitleWidgetState extends State<RecipeTitleWidget> {
//   final TextEditingController _titleController = TextEditingController();
//   List<File> _selectedImages = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.source == 'Camera' || widget.source == 'Photos') {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _openImageSelector(); // Automatically open image selector on initialization
//       });
//     }
//   }

//   Future<void> _openImageSelector() async {
//     final List<File>? images = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ImageSelectionWidget(
//           onImagesSelected: (selectedImages) {
//             setState(() {
//               _selectedImages.addAll(selectedImages);
//             });
//           },
//         ),
//       ),
//     );

//     if (images != null) {
//       setState(() {
//         for (var image in images) {
//           if (!_selectedImages.contains(image)) {
//             _selectedImages.add(image); // Add only unique images
//           }
//         }
//       });
//     }
//   }

//   void _handleSave() {
//     if (_titleController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a recipe title')),
//       );
//     } else {
//       // Proceed to the recipe creation page
//       print('Title: ${_titleController.text}');
//       print('Images: ${_selectedImages.map((img) => img.path).toList()}');
//       // TODO: Implement navigation to recipe creation page
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('New Recipe')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_selectedImages.isNotEmpty)
//               SizedBox(
//                 height: 150,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _selectedImages.length,
//                   itemBuilder: (context, index) => Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Image.file(
//                       _selectedImages[index],
//                       height: 150,
//                       width: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               )
//             else
//               GestureDetector(
//                 onTap: _openImageSelector,
//                 child: Container(
//                   height: 150,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.source == 'Photos' ? 'Choose a Photo' : 'Snap a Photo',
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: 'Recipe Name',
//                 hintText: 'Enter recipe name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: _handleSave,
//               child: Text('Save'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     super.dispose();
//   }
// }