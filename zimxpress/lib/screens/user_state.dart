import '../screens/landing_page.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Define UserInfo class
class UserInfo {
  final String uid;
  final String email;
  final String displayName;

  UserInfo({required this.uid, required this.email, required this.displayName});
}

// Define IsAuthenticated class
class IsAuthenticated {
  final bool isLoggedIn;

  IsAuthenticated({required this.isLoggedIn});
}

// Define Initial class

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.connectionState == ConnectionState.active) {
            if (userSnapshot.hasData) {
              print('The user is already logged in');
              return ZimXpress();
            } else {
              print('The user didn\'t login yet');
              return LandingPage();
            }
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text('Error occured'),
            );
          }
          // Add a default return statement
          return Center(
            child: Text('Unexpected state'),
          );
        });
  }

  static UserState initial() {
    return UserState();
  }
}
