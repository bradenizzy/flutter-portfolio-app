// firebase_error_util.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ErrorUtil {
  static String getErrorMessage(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'invalid-email':
        errorMessage = "The email address appears to be formated incorrect. Please try again.";
        break;
      case 'wrong-password':
        errorMessage = "The password is invalid. Please try again.";
        break;
      case 'user-not-found':
        errorMessage = "User with this email doesn't exist. Please try again.";
        break;
      case 'user-disabled':
        errorMessage = "User with this email has been disabled. Please email support@swapsbyji.com";
        break;
      case 'too-many-requests':
        errorMessage = "Woah there! Our servers are being overloaded. Please wait and try again in a few minutes.";
        break;
      case 'operation-not-allowed':
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case 'email-already-in-use':
        errorMessage = "The email address is already in use by another account.";
        break;
      case 'invalid-credential':
        errorMessage = "That email isn't in our system. Please try again.";
        break;
      case 'weak-password':
        errorMessage = "The password is too weak. Please try again.";
        break;
      default:
        errorMessage = "Oops, an undefined Error occured. Please try again in a few seconds.";
    }
    return errorMessage;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }
}
