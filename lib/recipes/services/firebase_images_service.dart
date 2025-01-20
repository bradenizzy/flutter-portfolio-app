// firebase_images_service.dart

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseImagesService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages({
    required List<File> images,
    required String userId,
    required String recipeId,
  }) async {
    List<String> downloadUrls = [];

    try {
      for (File image in images) {
        //Generate a unique filename
        String fileName = "${userId}_${recipeId}_${DateTime.now().millisecondsSinceEpoch}.jpg";
        
        // Define the storage path
        String storagePath = 'recipes/$userId/$recipeId/$fileName.jpg';

        // Upload the file
        TaskSnapshot snapshot = await _storage.ref(storagePath).putFile(image);

        // Get the download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    } catch (e) {
      throw Exception("Failed to upload images: $e");
    }
    return downloadUrls;
  }
}
