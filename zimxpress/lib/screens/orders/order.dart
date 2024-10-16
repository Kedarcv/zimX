import 'package:untitled1/consts/my_icons.dart';
import 'package:untitled1/provider/cart_provider.dart';
import 'package:untitled1/provider/orders_provider.dart';
import 'package:untitled1/services/global_method.dart';
import 'package:untitled1/services/payment.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog2/progress_dialog2.dart';
import 'package:provider/provider.dart';

import 'order_empty.dart';
import 'order_full.dart';

class OrderScreen extends StatefulWidget {
  //To be known 1) the amount must be an integer 2) the amount must not be double 3) the minimum amount should be less than 0.5 $
  static const routeName = '/OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PayNowService.initiatePaymentUri;
  }

  void payWithCard({required int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await PayNowService.payWithPayNow(
        currency: 'USD',
        amount: amount.toString(),
        reference: '',
        context: context);
    await dialog.hide();
    print('response : ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final orderProvider = Provider.of<OrdersProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    print('orderProvider.getOrders length ${orderProvider.getOrders.length}');
    return FutureBuilder(
        future: orderProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderProvider.getOrders.isEmpty
              ? Scaffold(body: OrderEmpty())
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Text('Orders (${orderProvider.getOrders.length})'),
                    actions: [
                      IconButton(
                        onPressed: () {
                          // globalMethods.showDialogg(
                          //     'Clear cart!',
                          //     'Your cart will be cleared!',
                          //     () => cartProvider.clearCart(),
                          //     context);
                        },
                        icon: Icon(MyAppIcons.trash),
                      )
                    ],
                  ),
                  body: Container(
                    margin: EdgeInsets.only(bottom: 60),
                    child: ListView.builder(
                        itemCount: orderProvider.getOrders.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ChangeNotifierProvider.value(
                              value: orderProvider.getOrders[index],
                              child: OrderFull());
                        }),
                  ));
        });
  }
}
