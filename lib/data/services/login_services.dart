import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/login_model/login_model.dart';

class LoginService {

  Future<String> loginUser(LoginModel user) async {
    final url = Uri.parse('http://localhost:8000/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200||response.statusCode == 201) {
        return responseData['message'];
      } else {
        throw responseData['message'];
      }
    } catch (e) {
      throw Exception("Login Failed: ${e.toString()}");
    }
  }
}
