import '../models/orders_attr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OrdersProvider with ChangeNotifier {
  List<OrdersAttr> _orders = [];
  List<OrdersAttr> get getOrders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    if (_user == null) {
      print('No user is currently signed in.');
      return;
    }
    var _uid = _user.uid;
    print('the user Id is equal to $_uid');
    try {
      final QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('order')
          .where('userId', isEqualTo: _uid)
          .get();

      _orders.clear();
      for (var element in ordersSnapshot.docs) {
        _orders.insert(
          0,
          OrdersAttr(
            orderId: element['orderId'],
            productId: element['productId'],
            userId: element['userId'],
            price: element['price'].toString(),
            quantity: element['quantity'].toString(),
            imageUrl: element['imageUrl'],
            title: element['title'],
            orderDate: element['orderDate'],
          ),
        );
      }
    } catch (error) {
      print('Printing error while fetching order $error');
    }
    notifyListeners();
  }
}
