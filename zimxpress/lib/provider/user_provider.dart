import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Separate authentication state and user info
class AuthenticationState with ChangeNotifier {
  bool isAuthenticated = false;
}

class UserInfo {
  final String uid;
  final String? email;
  final String? displayName;

  UserInfo({required this.uid, this.email, this.displayName});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }
}

class UserProvider with ChangeNotifier {
  AuthenticationState _authenticationState = AuthenticationState();
  UserInfo? _userInfo;

  AuthenticationState get authenticationState => _authenticationState;
  UserInfo? get userInfo => _userInfo;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProvider() {
    // Set persistence (optional)
    _auth.setPersistence(Persistence.LOCAL);

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _authenticationState.isAuthenticated = true;
        _userInfo = UserInfo(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );
      } else {
        _authenticationState.isAuthenticated = false;
        _userInfo = null;
      }
      notifyListeners();
    });
  }

  // ... (signIn, signUp, signOut methods - with improved error handling)

  Future<void> updateUserInfo(UserInfo userInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userInfo.uid)
          .update(userInfo.toMap());

      _userInfo = userInfo;
      notifyListeners();
    } catch (e) {
      // ... error handling
    }
  }
}
