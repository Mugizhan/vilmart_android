import 'package:firebase_auth/firebase_auth.dart';

import '../model/login_model/login_model.dart';
import '../services/login_services.dart';

class LoginRepository {
  final LoginService _loginService=LoginService();
  Future<User?> loginUser(LoginModel user) {
    return _loginService.loginUser(user);
  }
}
