import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> signup(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await userCredential.user?.sendEmailVerification();
    return userCredential;
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> addToCart(String productId) async {
    String userId = _auth.currentUser?.uid ?? '';
    await _firestore.collection('cart').add({
      'userId': userId,
      'productId': productId,
      'quantity': 1,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> removeFromCart(String cartItemId) async {
    await _firestore.collection('cart').doc(cartItemId).delete();
  }

  static Future<void> addProduct(
      String name, double price, String description, String imageUrl) async {
    await _firestore.collection('products').add({
      'name': name,
      'price': price,
      'description': description,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
