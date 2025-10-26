import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Firebase-ready authentication methods
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Auth
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Create user object (replace with Firebase user data)
      _user = User(
        id: 'temp_id_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Auth
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create user object (replace with Firebase user data)
      _user = User(
        id: 'temp_id_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@')[0], // Extract name from email
        createdAt: DateTime.now(),
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Sign in failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Google Sign-In
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );
      // await FirebaseAuth.instance.signInWithCredential(credential);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Create user object (replace with Firebase user data)
      _user = User(
        id: 'google_temp_id_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com',
        name: 'Google User',
        createdAt: DateTime.now(),
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Google sign in failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInAsGuest() async {
    try {
      _setLoading(true);
      _clearError();

      // Create guest user
      _user = User(
        id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        email: 'guest@example.com',
        name: 'Guest User',
        createdAt: DateTime.now(),
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Guest sign in failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      if (_user == null) return false;

      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_user!.id)
      //     .update({
      //   if (name != null) 'name': name,
      //   if (phoneNumber != null) 'phoneNumber': phoneNumber,
      //   if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      // });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Update local user object
      _user = User(
        id: _user!.id,
        email: _user!.email,
        name: name ?? _user!.name,
        phoneNumber: phoneNumber ?? _user!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _user!.profileImageUrl,
        createdAt: _user!.createdAt,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Auth
      // await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Password change failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Auth
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);

      // TODO: Replace with Firebase Auth
      // await FirebaseAuth.instance.signOut();

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _user = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Initialize auth state (call this in main.dart)
  Future<void> initializeAuth() async {
    try {
      _setLoading(true);

      // TODO: Replace with Firebase Auth state listener
      // FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      //   if (firebaseUser != null) {
      //     // Load user data from Firestore
      //     _loadUserData(firebaseUser.uid);
      //   } else {
      //     _user = null;
      //     notifyListeners();
      //   }
      // });

      // Simulate initialization
      await Future.delayed(const Duration(milliseconds: 500));
      _setLoading(false);
    } catch (e) {
      _setError('Auth initialization failed: ${e.toString()}');
      _setLoading(false);
    }
  }
}