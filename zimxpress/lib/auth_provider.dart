import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _userRole;

  User? get user => _user;
  String? get userRole => _userRole;

  Future<void> login(String email, String password) async {
    UserCredential userCredential =
        await FirebaseService.login(email, password);
    _user = userCredential.user;
    _userRole = await _getUserRole(_user?.uid);
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    UserCredential userCredential =
        await FirebaseService.signup(email, password);
    _user = userCredential.user;
    notifyListeners();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _userRole = null;
    notifyListeners();
  }

  Future<String> _getUserRole(String? userId) async {
    if (userId == null) return '';
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data()?['role'] ?? '';
  }
}
