// user_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_portfolio_app/recipes/providers/user_profile_provider.dart';
import 'package:flutter_portfolio_app/recipes/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileProvider>().userProfile;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: profile.profileImageUrl.isNotEmpty
                ? NetworkImage(profile.profileImageUrl)
                : null,
            child: profile.profileImageUrl.isEmpty
                ? Icon(Icons.person, size: 40)
                : null,
          ),
          SizedBox(height: 16),
          Text("${profile.firstName} ${profile.lastName}"),
          Text(profile.email),
          SizedBox(height: 24),
          ListTile(
            title: Text("Phone Number"),
            subtitle: Text(profile.phone.isNotEmpty ? profile.phone : "Not set"),
            leading: Icon(Icons.phone),
            onTap: () {
              // TODO: Implement phone edit
            },
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            value: profile.preferences.darkMode,
            onChanged: (val) {
              final updated = profile.copyWith(
                preferences: profile.preferences.copyWith(darkMode: val),
              );
              context.read<UserProfileProvider>().setUserProfile(updated);
              FirebaseFirestore.instance
                .collection('user_profiles')
                .doc(profile.userId)
                .update(updated.toMap());
            },
            secondary: Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: Text("Notifications"),
            value: profile.preferences.notificationsEnabled,
            onChanged: (val) {
              final updated = profile.copyWith(
                preferences: profile.preferences.copyWith(notificationsEnabled: val),
              );
              context.read<UserProfileProvider>().setUserProfile(updated);
              FirebaseFirestore.instance
                .collection('user_profiles')
                .doc(profile.userId)
                .update(updated.toMap());
            },
            secondary: Icon(Icons.notifications),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
            },
            icon: Icon(Icons.logout),
            label: Text("Log Out"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
