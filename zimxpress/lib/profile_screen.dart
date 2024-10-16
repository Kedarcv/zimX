import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Consumer<AuthProvider?>(
        builder: (context, authProvider, child) {
          return Column(
            children: [
              ListTile(
                title: Text(authProvider?.user?.email ?? ''),
                subtitle: Text(authProvider?.userRole ?? ''),
              ),
              ElevatedButton(
                child: Text('Logout'),
                onPressed: () => authProvider?.logout(),
              ),
            ],
          );
        },
      ),
    );
  }
}
