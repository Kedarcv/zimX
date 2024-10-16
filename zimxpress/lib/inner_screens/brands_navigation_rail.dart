import '../models/product.dart';
import '../provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brands_rail_widget.dart';

class BrandNavigationRailScreen extends StatefulWidget {
  BrandNavigationRailScreen({Key? key}) : super(key: key);

  static const routeName = '/brands_navigation_rail';

  @override
  _BrandNavigationRailScreenState createState() =>
      _BrandNavigationRailScreenState();
}

class _BrandNavigationRailScreenState extends State<BrandNavigationRailScreen> {
  int _selectedIndex = 0;
  String brand = '';

  final Map<int, String> _brands = {
    0: 'Addidas',
    1: 'Apple',
    2: 'Dell',
    3: 'H&M',
    4: 'Nike',
    5: 'Samsung',
    6: 'Huawei',
    7: 'All',
  };

  @override
  void didChangeDependencies() {
    _selectedIndex = ModalRoute.of(context)?.settings.arguments as int;
    brand = _brands[_selectedIndex]!; // Use the map to get the brand
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      minWidth: 56.0,
                      groupAlignment: 1.0,
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                          brand = _brands[index]!;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Center(
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                            ),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                      selectedLabelTextStyle: TextStyle(
                        color: Color(0xffffe6bc97),
                        fontSize: 20,
                        letterSpacing: 1,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.5,
                      ),
                      unselectedLabelTextStyle: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.8,
                      ),
                      destinations: [
                        buildRotatedTextRailDestination('Addidas', 8.0),
                        buildRotatedTextRailDestination("Apple", 8.0),
                        buildRotatedTextRailDestination("Dell", 8.0),
                        buildRotatedTextRailDestination("H&M", 8.0),
                        buildRotatedTextRailDestination("Nike", 8.0),
                        buildRotatedTextRailDestination("Samsung", 8.0),
                        buildRotatedTextRailDestination("Huawei", 8.0),
                        buildRotatedTextRailDestination("All", 8.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ContentSpace(context, brand), // Pass the brand to ContentSpace
        ],
      ),
    );
  }
}

NavigationRailDestination buildRotatedTextRailDestination(
    String text, double padding) {
  return NavigationRailDestination(
    icon: SizedBox.shrink(),
    label: Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(text),
      ),
    ),
  );
}

class ContentSpace extends StatelessWidget {
  final String brand;
  ContentSpace(BuildContext context, this.brand);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final productsBrand = _getProductsByBrand(productsData);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: productsBrand.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error, // Replace with your desired icon
                      size: 80,
                    ),
                    SizedBox(height: 40),
                    Text(
                      'No products related to this brand',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: productsBrand.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ChangeNotifierProvider.value(
                    value: productsBrand[index],
                    child: BrandsNavigationRail(),
                  ),
                ),
        ),
      ),
    );
  }

  List<Product> _getProductsByBrand(Products productsData) {
    return brand == 'All'
        ? productsData.products
        : productsData.findByBrand(brand);
  }
}
