// image_selection_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectionWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const ImageSelectionWidget({Key? key, required this.onImagesSelected}) : super(key: key);

  @override
  _ImageSelectionWidgetState createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _captureImageWithCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  void _confirmSelection() {
    if (_selectedImages.isNotEmpty) {
      widget.onImagesSelected(_selectedImages);
      Navigator.pop(context, _selectedImages); // Return selected images to parent
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one photo.')),
      );
    }
  }

  void _exitWithoutSelection() {
    Navigator.pop(context, null); // Return null to indicate no images selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Images'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: _exitWithoutSelection,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _selectedImages.length + 1, // +1 for the camera icon
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _captureImageWithCamera,
                    child: Container(
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50),
                          SizedBox(height: 8),
                          Text(
                            'Take a Photo',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Image.file(
                        _selectedImages[index - 1],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedImages.removeAt(index - 1);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _pickImagesFromGallery,
            child: Text('Select Photos from Gallery'),
          ),
          ElevatedButton(
            onPressed: _confirmSelection,
            child: Text('Add to Recipe'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}