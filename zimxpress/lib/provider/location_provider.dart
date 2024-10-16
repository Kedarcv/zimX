import 'package:flutter/material.dart';
import '../screens/order_tracking_screen.dart';

class OrderTrackingProvider with ChangeNotifier {
  OrderTrackingScreen? _orderTrackingScreen;

  OrderTrackingScreen? get orderTrackingScreen => _orderTrackingScreen;

  void initializeOrderTracking(BuildContext context) {
    _orderTrackingScreen = OrderTrackingScreen();
    notifyListeners();
  }
}
