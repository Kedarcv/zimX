import '../provider/auth_provider.dart';
import 'package:untitled1/screens/order_tracking_screen.dart';
import 'package:untitled1/screens/search.dart';
import 'package:untitled1/screens/user_info.dart';
import 'package:untitled1/screens/landing_page.dart'; // Make sure to import your LandingPage
import 'package:flutter/material.dart';
import 'cart/cart.dart';
import 'feeds.dart';
// Assuming this is not used anymore
// Assuming this is not used anymore
import 'package:provider/provider.dart'; // Import provider package

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedPageIndex = 0;

  final List<Widget> _screens = [
    LandingPage(), // Changed to LandingPage
    Feeds(),
    Search(),
    CartScreen(),
    UserInfo(), // Updated to match your original code
    OrderTrackingScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: 'Feeds'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
    BottomNavigationBarItem(
        icon: Icon(Icons.local_shipping), label: 'Order Tracking'),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logout(context); // Handle logging out
        },
        child: Icon(Icons.logout),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Center the FAB if needed
    );
  }
}
