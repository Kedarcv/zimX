import '../inner_screens/categories_feeds.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final List<Map<String, String>> categories = [
    {
      'categoryName': 'Phones',
      'categoryImagesPath': 'assets/images/CatPhones.png',
    },
    {
      'categoryName': 'Clothes',
      'categoryImagesPath': 'assets/images/CatClothes.jpg',
    },
    {
      'categoryName': 'Shoes',
      'categoryImagesPath': 'assets/images/CatShoes.jpg',
    },
    {
      'categoryName': 'Beauty&Health',
      'categoryImagesPath': 'assets/images/CatBeauty.jpg',
    },
    {
      'categoryName': 'Laptops',
      'categoryImagesPath': 'assets/images/CatLaptops.png',
    },
    {
      'categoryName': 'Furniture',
      'categoryImagesPath': 'assets/images/CatFurniture.jpg',
    },
    {
      'categoryName': 'Watches',
      'categoryImagesPath': 'assets/images/CatWatches.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(CategoriesFeedsScreen.routeName,
                arguments: categories[widget.index]['categoryName']);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(
                      categories[widget.index]['categoryImagesPath']!),
                  fit: BoxFit.cover),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 10,
          right: 10,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Theme.of(context).colorScheme.surface,
            child: Text(
              categories[widget.index]['categoryName']!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        )
      ],
    );
  }
}
