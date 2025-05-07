// // lib/services/auth_service.dart
// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class AuthService extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   User? _user;
//   bool _isOffline = false;
//   bool _isInitialized = false;

//   User? get user => _user;
//   bool get isOffline => _isOffline;
//   bool get isAuthenticated => _user != null;
//   bool get isInitialized => _isInitialized;

//   AuthService() {
//     _initializeAuth();
//   }

//   Future<void> _initializeAuth() async {
//     // Check connectivity
//     var connectivityResult = await Connectivity().checkConnectivity();
//     _isOffline = connectivityResult == ConnectivityResult.none;

//     // Listen for auth state changes
//     _auth.authStateChanges().listen((User? user) {
//       _user = user;
//       if (user != null) {
//         _saveUserLocally(user);
//       }
//       notifyListeners();
//     });

//     // If offline, try to load user from local storage
//     if (_isOffline) {
//       await _loadUserFromLocal();
//     }
    
//     _isInitialized = true;
//     notifyListeners();
//   }

//   // Save user data locally for offline access
//   Future<void> _saveUserLocally(User user) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userData = {
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName,
//         'photoURL': user.photoURL,
//       };
//       await prefs.setString('user', jsonEncode(userData));
//       await prefs.setBool('isLoggedIn', true);
//     } catch (e) {
//       debugPrint('Error saving user locally: $e');
//     }
//   }

//   // Load user data from local storage
//   Future<void> _loadUserFromLocal() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
//       if (isLoggedIn) {
//         final userJson = prefs.getString('user');
//         if (userJson != null) {
//           // We can't create a full Firebase User object, but we can set _user
//           // to indicate the user is authenticated for offline use
//           _user = _auth.currentUser;
//           notifyListeners();
//         }
//       }
//     } catch (e) {
//       debugPrint('Error loading user from local storage: $e');
//     }
//   }

//   // Email & Password Sign Up
//   Future<UserCredential?> registerWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await _saveUserLocally(result.user!);
//       return result;
//     } catch (e) {
//       debugPrint('Error during registration: $e');
//       rethrow;
//     }
//   }

//   // Email & Password Login
//   Future<UserCredential?> loginWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       final result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await _saveUserLocally(result.user!);
//       return result;
//     } catch (e) {
//       debugPrint('Error during login: $e');
//       rethrow;
//     }
//   }

//   // Google Sign In
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
//       if (googleUser == null) return null;
      
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
      
//       final result = await _auth.signInWithCredential(credential);
//       await _saveUserLocally(result.user!);
//       return result;
//     } catch (e) {
//       debugPrint('Error during Google sign in: $e');
//       rethrow;
//     }
//   }

//   // Facebook Sign In
//   Future<UserCredential?> signInWithFacebook() async {
//     try {
//       final LoginResult result = await FacebookAuth.instance.login();
      
//       if (result.status != LoginStatus.success) return null;
      
//       final OAuthCredential credential = FacebookAuthProvider.credential(
//         result.accessToken!.token,
//       );
      
//       final userCredential = await _auth.signInWithCredential(credential);
//       await _saveUserLocally(userCredential.user!);
//       return userCredential;
//     } catch (e) {
//       debugPrint('Error during Facebook sign in: $e');
//       rethrow;
//     }
//   }

//   // Apple Sign In
//   Future<UserCredential?> signInWithApple() async {
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );
      
//       final oauthCredential = OAuthProvider('apple.com').credential(
//         idToken: credential.identityToken,
//         accessToken: credential.authorizationCode,
//       );
      
//       final result = await _auth.signInWithCredential(oauthCredential);
//       await _saveUserLocally(result.user!);
//       return result;
//     } catch (e) {
//       debugPrint('Error during Apple sign in: $e');
//       rethrow;
//     }
//   }

//   // Sign Out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut();
      
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', false);
//       await prefs.remove('user');
      
//       _user = null;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error signing out: $e');
//       rethrow;
//     }
//   }

//   // Password Reset
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       debugPrint('Error sending password reset email: $e');
//       rethrow;
//     }
//   }
// }