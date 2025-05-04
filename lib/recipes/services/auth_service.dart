// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_portfolio_app/recipes/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> signInWithEmailAndReturnProfile(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user!.uid;

      // Fetch the profile from Firestore
      final doc = await _firestore.collection('user_profiles').doc(userId).get();
      if (!doc.exists) throw Exception("User profile not found");

      return UserProfile.fromMap(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      rethrow; // Rethrow to be handled by UI or calling layer
    }
  }

  // TODO: Include a last name in the profile
  Future<UserCredential> createAccount(String email, String password, String firstName, String lastName, String phoneNumber) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createInitialUserProfile(
        userCredential.user!.uid,
        email,
        firstName,
        lastName, 
        phoneNumber,
        null, 
      );
      return userCredential;
    } catch (e) {
      rethrow; // Rethrow to be handled by UI or calling layer
    }
  }

  // Private method to create an initial user profile in Firestore
  Future<void> _createInitialUserProfile(String userId, String email, String firstName, String lastName, String phone, String? profileImageUrl) async {
    UserProfile profile = UserProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone ?? '',
      profileImageUrl: profileImageUrl ?? '',
      preferences: Preferences(notificationsEnabled: true, darkMode: false),
    );
    await _firestore.collection('user_profiles').doc(userId).set(profile.toMap());
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow; // Or handle the error appropriately
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    // You may want to handle navigation outside this method or use a callback
  }
}