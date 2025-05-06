
// custom_drawer_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/services/auth_service.dart'; 
import 'package:flutter_portfolio_app/recipes/utils/dialog_util.dart';  
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawerService {
  final AuthService _authService = AuthService();

  // Future<void> resetProgress(BuildContext context) async {
  //   bool shouldReset = await DialogUtil.showConfirmDialog(
  //     context: context,
  //     title: 'Reset Progress',
  //     content: 'Are you sure you want to reset your progress? This CANNOT be undone.',
  //   );

  //   if (shouldReset) {
  //     bool result = await _authService.resetUserProgress(FirebaseAuth.instance.currentUser!.uid);
  //     if (result) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Progress has been reset.")));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error resetting progress.")));
  //     }
  //   }
  // }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      Navigator.of(context).pushReplacementNamed('/sign-in'); // Navigate to the sign-in screen
    } catch (e) {
      // Handle errors if needed
      print("Error signing out: $e");
    }
  }
}
