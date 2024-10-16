import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    print('Fetch method is called');
    try {
      final QuerySnapshot productsSnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      _products = productsSnapshot.docs.map((doc) {
        return Product(
          id: doc.get('productId'),
          title: doc.get('productTitle'),
          description: doc.get('productDescription'),
          price: double.parse(doc.get('price')),
          imageUrl: doc.get('productImage'),
          brand: doc.get('productBrand'),
          productCategoryName: doc.get('productCategory'),
          quantity: int.parse(doc.get('quantity')),
          isPopular: doc.get('isPopular') ?? false,
        );
      }).toList();
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  List<Product> get popularProducts {
    return _products.where((element) => element.isPopular).toList();
  }

  Product findById(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String categoryName) {
    return _products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }

  List<Product> findByBrand(String brandName) {
    return _products
        .where((element) =>
            element.brand.toLowerCase().contains(brandName.toLowerCase()))
        .toList();
  }

  List<Product> searchQuery(String searchText) {
    return _products
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }
}
