import 'package:vilmart_android/data/model/home_model/home_model.dart';
import 'package:vilmart_android/data/services/home_service.dart';

class HomeRepository{

  final HomeService _homeService=HomeService();

  Future<List<HomeModel>> FetchProduct() async {

      return await _homeService.homeService();
  }
}