import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_register_model/product_register_model.dart';

class HomeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    try {
      final querySnapshot = await _db.collectionGroup('products').get();

      List<Product> products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromJson(data);
      }).toList();
      return products;
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching home products: $e');
    }
  }
}
