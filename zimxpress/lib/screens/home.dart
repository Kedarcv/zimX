import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:untitled1/consts/colors.dart';
import 'package:untitled1/inner_screens/brands_navigation_rail.dart';
import 'package:untitled1/provider/products.dart';
import 'package:untitled1/screens/feeds.dart';
import 'package:untitled1/screens/upload_product_form.dart';
import 'package:untitled1/widget/backlayer.dart';
import 'package:untitled1/widget/category.dart';
import 'package:untitled1/widget/popular_products.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:provider/provider.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List _carouselImages = [
    'assets/images/carousel1.png',
    'assets/images/carousel2.jpeg',
    'assets/images/carousel3.jpg',
    'assets/images/carousel4.png',
  ];

  List _brandImages = [
    'assets/images/addidas.jpg',
    'assets/images/apple.jpg',
    'assets/images/dell.jpg',
    'assets/images/h&m.jpg',
    'assets/images/nike.jpg',
    'assets/images/samsung.jpg',
    'assets/images/huawei.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    productsData.fetchProducts();

    final popularItems = productsData.popularProducts;
    print('popularItems length ${popularItems.length}');
    return Scaffold(
      body: BackdropScaffold(
        frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerHeight: MediaQuery.of(context).size.height * 0.25,
        appBar: BackdropAppBar(
          title: Text("Home"),
          leading: BackdropToggleButton(icon: AnimatedIcons.home_menu),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ColorsConsts.starterColor,
              ColorsConsts.endColor
            ])),
          ),
          actions: <Widget>[
            IconButton(
              iconSize: 15,
              padding: const EdgeInsets.all(10),
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 13,
                  backgroundImage: NetworkImage(
                      'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                ),
              ),
              onPressed: () {},
            )
          ],
        ),
        backLayer: BackLayerMenu(),
        frontLayer: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 190.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: _carouselImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                        child: Image.asset(
                          i,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, int index) {
                    return CategoryWidget(
                      index: index,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Brands',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          BrandNavigationRailScreen.routeName,
                          arguments: {
                            7,
                          },
                        );
                      },
                      child: Text(
                        'View all...',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 210,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Swiper(
                  itemCount: _brandImages.length,
                  autoplay: true,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  onTap: (index) {
                    Navigator.of(context).pushNamed(
                      BrandNavigationRailScreen.routeName,
                      arguments: {
                        index,
                      },
                    );
                  },
                  itemBuilder: (BuildContext ctx, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.blueGrey,
                        child: Image.asset(
                          _brandImages[index],
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Popular Products',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Feeds.routeName, arguments: 'popular');
                      },
                      child: Text(
                        'View all...',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 285,
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularItems.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                        value: popularItems[index],
                        child: PopularProducts(),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class ShopHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductUploadForm()));
              },
              child: Text('Post Product'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/analytics');
              },
              child: Text('View Analytics'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManageOrdersPage()));
              },
              child: Text('Manage Orders'),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').where('shopId', isEqualTo: FirebaseAuthWeb.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text('Order #${doc.id}'),
                subtitle: Text('Status: ${doc['status']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Update Order Status'),
                          content: DropdownButton<String>(
                            value: doc['status'],
                            items: <String>['Pending', 'Processing', 'Shipped', 'Delivered']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(doc.id)
                                    .update({'status': newValue}).then((_) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Order status updated successfully')),
                                  );
                                }).catchError((error) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to update order status')),
                                  );
                                });
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Update Status'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
