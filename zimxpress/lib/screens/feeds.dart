import 'package:untitled1/consts/colors.dart';
import 'package:untitled1/consts/my_icons.dart';
import 'package:untitled1/models/product.dart';
import 'package:untitled1/provider/cart_provider.dart';
import 'package:untitled1/provider/favs_provider.dart';
import 'package:untitled1/provider/products.dart';
import 'package:untitled1/screens/wishlist/wishlist.dart';
import 'package:untitled1/widget/feeds_products.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart/cart.dart';

class Feeds extends StatefulWidget {
  static const routeName = '/Feeds';

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<FavsProvider>(
          create: (_) => FavsProvider(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final popular = ModalRoute.of(context)?.settings.arguments as String?;
          final productsProvider = Provider.of<Products>(context);

          List<Product> productsList = productsProvider.products;
          if (popular == 'popular') {
            productsList = productsProvider.popularProducts;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).cardColor,
              title: Text('Feeds'),
              actions: [
                Consumer<FavsProvider>(
                  builder: (_, favs, ch) => badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: ColorsConsts.cartBadgeColor,
                    ),
                    position: badges.BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      favs.getFavsItems.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        MyAppIcons.wishlist,
                        color: ColorsConsts.favColor,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName);
                      },
                    ),
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (_, cart, ch) => badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: ColorsConsts.cartBadgeColor,
                    ),
                    position: badges.BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      cart.getCartItems.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        MyAppIcons.cart,
                        color: ColorsConsts.cartColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _getProductsOnRefresh,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 235 / 420,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(productsList.length, (index) {
                  return ChangeNotifierProvider.value(
                    value: productsList[index],
                    child: FeedProducts(),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
