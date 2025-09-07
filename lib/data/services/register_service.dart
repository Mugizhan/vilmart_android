import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/register_model/register_model.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser(RegisterModel model) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );

      print('user: ${credential.user}');
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'role': 'customer',
        ...model.toJson(),
      });

      return credential.user;
    } catch (e) {
      throw Exception(e);
    }
  }
}

