import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/home_model/home_model.dart';

class HomeService {
  Future<List<HomeModel>> homeService() async {
    final url = Uri.parse('https://fakestoreapi.com/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<HomeModel> products = jsonData.map((item) => HomeModel.fromJson(item)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e)

    {
      throw Exception('${e}');
    }
  }
}
