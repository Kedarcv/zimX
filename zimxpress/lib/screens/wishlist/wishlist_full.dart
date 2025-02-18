import 'package:untitled1/consts/colors.dart';
import 'package:untitled1/models/favs_attr.dart';
import 'package:untitled1/provider/favs_provider.dart';
import 'package:untitled1/services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistFull extends StatefulWidget {
  final String productId;

  const WishlistFull({Key? key, required this.productId}) : super(key: key);

  @override
  _WishlistFullState createState() => _WishlistFullState();
}

class _WishlistFullState extends State<WishlistFull> {
  @override
  Widget build(BuildContext context) {
    final favsAttr = Provider.of<FavsAttr>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      child: Image.network(favsAttr.imageUrl),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            favsAttr.title,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "\$ ${favsAttr.price}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        positionedRemove(widget.productId),
      ],
    );
  }

  Widget positionedRemove(String productId) {
    final favsProvider = Provider.of<FavsProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();
    return Positioned(
      top: 20,
      right: 15,
      child: SizedBox(
        height: 30,
        width: 30,
        child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            padding: EdgeInsets.zero,
            color: ColorsConsts.favColor,
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              globalMethods.showDialogg(
                  'Remove wish!',
                  'This product will be removed from your wishlist!',
                  () => favsProvider.removeItem(productId),
                  context);
            }),
      ),
    );
  }
}
