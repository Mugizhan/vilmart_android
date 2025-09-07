import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/add_store_model/add_store_model.dart';
import '../model/product_register_model/product_register_model.dart';
import '../model/product_store_model/product_store.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<ProductStoreModel> getShopProduct({
    required String shopId,
  }) async {
    try {
      final querySnapshot = await _db
          .collection('shops')
          .doc(shopId)
          .collection('products')
          .get();


      if (querySnapshot.docs.isEmpty) {
        throw Exception("No shop found for category: $shopId");
      }

      final shops = await _db.collection('shops').doc(shopId).get();

      final shopData = shops.data();

      if (shopData == null) {
        throw Exception("Shop data not found for id: $shopId");
      }

      final AddStoreModel shop = AddStoreModel.fromJson(shopData);


      final List<Product> shopProduct = querySnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();


      final ProductStoreModel finalData=ProductStoreModel(shop: shop, products: shopProduct);

      return finalData;
    } catch (e) {
      throw Exception("Failed to fetch shops: $e");
    }
  }
}
