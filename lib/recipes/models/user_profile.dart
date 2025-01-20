// user_profile.dart
class UserProfile {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final Preferences preferences;

  UserProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    this.profileImageUrl = '',
    required this.preferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences.toMap(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String? ?? '',
      profileImageUrl: map['profileImageUrl'] as String? ?? '',
      preferences: Preferences.fromMap(map['preferences'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Preferences {
  final bool notificationsEnabled;
  final bool darkMode;

  Preferences({
    required this.notificationsEnabled,
    required this.darkMode,
  });

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      notificationsEnabled: map['notificationsEnabled'],
      darkMode: map['darkMode'],
    );
  }
}
