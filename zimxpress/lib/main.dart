import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart'; // Ensure this path is correct based on your project structure
import 'screens/landing_page.dart'; // Assuming you have these screen implementations
import 'screens/feeds.dart';
import 'screens/search.dart';
import 'screens/cart/cart.dart';
import 'screens/user_info.dart' as UserInfo;
import 'screens/order_tracking_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'provider/user_provider.dart';
import 'provider/orders_provider.dart';
import 'provider/location_provider.dart';
import 'provider/cart_provider.dart';
import 'screens/auth/login.dart';
import 'screens/home.dart';
import 'screens/auth/sign_up.dart';
import 'services/payment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/assets/.env");
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ZimXpress());
}

class ZimXpress extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<ZimXpress> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrderTrackingProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'ZimXpress',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: LandingPage(),
        routes: {
          '/Shopper_home': (context) => UserHome(),
          '/Shop_home': (context) => ShopHomePage(),
          '/Cart': (context) => CartScreen(),
          '/Order_tracking': (context) => OrderTrackingScreen(),
          '/Payment_gateway': (context) => PayNowWebView(),
          '/Login': (context) => LoginScreen(userChoice: '',),
          '/Sign_up': (context) => SignUpScreen(),
        },
      ),
    );
  }
}
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserHome(), // Replace CategoriesFeedsScreen with HomePage
      bottomNavigationBar: BottomBarScreen(),
    );
  }
}

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedPageIndex = 0;

  final List<Widget> _screens = [
    UserHome(),
    Feeds(),
    Search(),
    CartScreen(),
    UserInfo.UserInfo(),
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
    );
  }
}

class Detect extends StatefulWidget {
  @override
  _DetectState createState() => _DetectState();
}

class _DetectState extends State<Detect> {
  @override
  void initState() {
    super.initState();
    // Check sign-in status when the app initializes
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkSignInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Check if the user is logged in
          if (!authProvider.isLoggedIn) {
            // Show login prompt
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showLoginPrompt(context);
            });
            return Center(
                child:
                    CircularProgressIndicator()); // Show loading while checking login status
          }
          return MainScreen();
        },
      ),
    );
  }

  // Show dialog prompting login
  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Required'),
        content: Text('Please log in to continue.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          userChoice: '',
                        )),
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
