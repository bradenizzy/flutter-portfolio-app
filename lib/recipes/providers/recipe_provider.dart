// recipe_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/chef_service.dart';

class RecipeProvider extends ChangeNotifier {
  final ChefService _chefService = ChefService();
  bool _isSessionActive = false;

  bool get isSessionActive => _isSessionActive;

  Future<void> startChefChatSession() async {
    try {
      await _chefService.startChatSession();
      _isSessionActive = true;
      notifyListeners();
    } catch (e) {
      print("Error starting chat session: $e");
      _isSessionActive = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopChefChatSession() async {
    try {
      await _chefService.stopChatSession();
      _isSessionActive = false;
      notifyListeners();
    } catch (e) {
      print("Error stopping chat session: $e");
      // Might still want to set to false even on error
      _isSessionActive = false;
      notifyListeners();
      rethrow;
    }
  }
}
// class RecipeProvider extends ChangeNotifier {
//   bool _isSessionActive = false;
//   bool get isSessionActive => _isSessionActive;

//   Future<void> startChefChatSession() async {
//     _isSessionActive = true;
//     notifyListeners();
//   }

//   Future<void> stopChefChatSession() async {
//     _isSessionActive = false;
//     notifyListeners();
//   }

// }
