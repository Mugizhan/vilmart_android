import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/add_store_model/add_store_model.dart';

class AddStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> addStore(AddStoreModel data) async {
    try {
      String? uid = await _storage.read(key: "uid");

      if (uid == null || uid.isEmpty) {
        throw Exception("User UID not found in secure storage.");
      }

      final docRef = _db.collection('shops').doc();
      final shopId = docRef.id;

      final jsonData = {
        'shopId': shopId,
        'category': data.category,
        'shopName': data.shopName,
        'ownerName': data.ownerName,
        'phone': data.phone,
        'email': data.email,
        'shopImageLink': data.shopImageLink,
        'latlon': data.latlon.toJson(),
        'address': data.address.toJson(),
        'gst': data.gst,
        'ownerId': uid,
        'rating': '1'
      };

      print('Data to store: $jsonData');
      await docRef.set(jsonData);

      // Save shop ID locally
      await _storage.write(key: 'shopId', value: shopId);

      // ✅ Update user's role to "owner"
      await _db.collection('users').doc(uid).update({
        'role': 'owner',
      });

      print('Register successful');
      return "Register Successfully";
    } catch (e, stackTrace) {
      print('Register failed: $e');
      print(stackTrace);
      throw Exception('Failed to register shop: ${e.toString()}');
    }
  }
}
