import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/product_register_model/product_register_model.dart';

class AddProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> addProductData(Product data) async {
    try {
      // Get user ID and shop ID from secure storage
      String? uid = await _storage.read(key: "uid");
      String? shopId = await _storage.read(key: "shopId");

      if (uid == null || uid.isEmpty) {
        throw Exception("User UID not found in secure storage.");
      }

      if (shopId == null || shopId.isEmpty) {
        throw Exception("Shop ID not found in secure storage.");
      }

      // Create a new document to generate a productId
      DocumentReference productRef = _db
          .collection('shops')
          .doc(shopId)
          .collection('products')
          .doc(); // Auto-generated ID

      // Combine original product data with productId and shopId
      final productJson = {
        ...data.toJson(),
        'productId': productRef.id,
        'shopId': shopId,
      };

      // Add the product to Firestore
      await productRef.set(productJson);

      print('Product added with ID: ${productRef.id}');
      return "Product added successfully";
    } catch (e, stackTrace) {
      print('Add product failed: $e');
      print(stackTrace);
      throw Exception('Failed to add product: ${e.toString()}');
    }
  }
}
