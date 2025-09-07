import 'package:firebase_auth/firebase_auth.dart';

import '../model/register_model/register_model.dart';
import '../services/register_service.dart';

class RegisterRepository {
  final RegisterService _registerService = RegisterService();

  Future<User?> storeData(RegisterModel data) {
    return _registerService.registerUser(data);
  }
}