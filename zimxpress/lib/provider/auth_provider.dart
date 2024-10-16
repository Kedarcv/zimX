import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
      _isLoggedIn = true;
      notifyListeners();
    } catch (error) {
      print('Login failed: $error');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkSignInStatus() async {
    _isLoggedIn = await _googleSignIn.isSignedIn();
    notifyListeners();
  }
}
