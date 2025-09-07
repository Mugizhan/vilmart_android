import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/login_model/login_model.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> loginUser(LoginModel user) async {
    try {
      print("Attempting to sign in with email: ${user.phone} and password: ${user.password}");

      // Sign in using email and password
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: user.phone,
        password: user.password,
      );

      User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        print("Login successful. Storing user data.");

        // Save basic auth info
        await _storage.write(key: "uid", value: firebaseUser.uid);
        await _storage.write(key: "email", value: firebaseUser.email);

        // 🔹 Fetch username from Firestore 'users' collection
        final userDoc = await _db.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          final username = userDoc.data()?['username'] ?? '';
          await _storage.write(key: "userName", value: username);
          print("Username found and saved: $username");
        } else {
          print("User document not found for uid: ${firebaseUser.uid}");
        }

        // 🔹 Fetch user's shop document and save shopId
        final shopSnapshot = await _db.collection('shops')
            .where('ownerId', isEqualTo: firebaseUser.uid)
            .limit(1)
            .get();

        if (shopSnapshot.docs.isNotEmpty) {
          final shopId = shopSnapshot.docs.first.id;
          await _storage.write(key: "shopId", value: shopId);
          print("Shop ID found and saved: $shopId");
        } else {
          print("No shop found for this user.");
        }

        return firebaseUser;
      } else {
        print("No user found after authentication.");
        throw Exception("Authentication failed.");
      }
    } catch (e) {
      print("Error during login: $e");
      throw Exception("Login failed: $e");
    }
  }
}
