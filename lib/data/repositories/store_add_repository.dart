import '../model/add_store_model/add_store_model.dart';
import '../services/add_store_service.dart';

class StoreAddRepository{

  final AddStoreService _service=AddStoreService();
  Future<String>addStore(AddStoreModel data){
    print('Repository:${data}');
    return _service.addStore(data);
  }

}