import '../model/login_model/login_model.dart';
import '../services/login_services.dart';

class LoginRepository {
  final LoginService _loginService=LoginService();
  Future<String> loginUser(LoginModel user) {
    return _loginService.loginUser(user);
  }
}
