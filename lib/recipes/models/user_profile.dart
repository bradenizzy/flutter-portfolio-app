// user_profile.dart
class UserProfile {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final Preferences preferences;
  final List<String> favoriteRecipeIds;
  final List<String> userRecipeIds;

  UserProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    this.profileImageUrl = '',
    required this.preferences,
    this.favoriteRecipeIds = const [],
    this.userRecipeIds = const [],
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
      'favoriteRecipeIds': favoriteRecipeIds,
      'userRecipeIds': userRecipeIds,
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
      favoriteRecipeIds: map['favoriteRecipeIds'] != null
        ? List<String>.from(map['favoriteRecipeIds'])
        : <String>[],
      userRecipeIds: map['userRecipeIds'] != null
      ? List<String>.from(map['userRecipeIds'])
      : <String>[],
    );
  }

  UserProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImageUrl,
    Preferences? preferences,
    List<String>? favoriteRecipeIds,
    List<String>? userRecipeIds,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
      userRecipeIds: userRecipeIds ?? this.userRecipeIds,
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

  Preferences copyWith({
    bool? notificationsEnabled,
    bool? darkMode,
  }) {
    return Preferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
