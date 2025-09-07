import '../model/product_register_model/product_register_model.dart';
import '../services/home_service.dart';

class HomeRepository {
  final HomeService _homeService = HomeService();

  Future<List<Product>> fetchProducts() async {
    return await _homeService.fetchProducts();
  }
}
