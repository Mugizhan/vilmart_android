import '../model/product_store_model/product_store.dart';
import '../services/product_service.dart';

class ProductCategoryRepository {
  final ProductService _shopService = ProductService();

  Future<ProductStoreModel> fetchProducts(String shopId) async {
    return await _shopService.getShopProduct(shopId:shopId);
  }
}
