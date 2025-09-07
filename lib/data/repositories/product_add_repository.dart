import '../model/product_register_model/product_register_model.dart';
import '../services/add_product_service.dart';

class AddProductRepository{

  AddProductService _service=AddProductService();

  Future<String>addProduct(Product data){
    return _service.addProductData(data);
  }
}