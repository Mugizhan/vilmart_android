import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/profile_model/profile_model.dart' as profile_model;

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<profile_model.CompleteUserData> getUserProfileShopsOrdersCart() async {
    try {
      final uid = await _secureStorage.read(key: 'uid');
      if (uid == null) throw Exception('UID not found');

      // 1. Fetch user profile
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists || userDoc.data() == null) {
        throw Exception('User document not found or empty');
      }
      final userProfile = profile_model.UserProfile.fromJson(userDoc.data()!);

      // 2. Fetch shops owned by user
      final shopQuery = await _firestore
          .collection('shops')
          .where('ownerId', isEqualTo: uid)
          .get();

      final userShops = shopQuery.docs.map((doc) {
        final data = doc.data();
        // Use 'id' key as per your model
        data['id'] = doc.id;
        return profile_model.Shop.fromJson(data);
      }).toList();

      // 3. Fetch orders from all shops owned by user
      List<profile_model.Order> allOrders = [];
      for (var shop in userShops) {
        final ordersSnapshot = await _firestore
            .collection('shops')
            .doc(shop.id) // Use 'id' from Shop model
            .collection('orders')
            .get();

        final orders = ordersSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;  // 'id' for Order model
          return profile_model.Order.fromJson(data);
        });
        allOrders.addAll(orders);
      }

      // 4. Fetch cart items for user
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('cart')
          .get();

      final cartItems = cartSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // 'id' for CartItem model
        return profile_model.CartItem.fromJson(data);
      }).toList();

      return profile_model.CompleteUserData(
        userProfile: userProfile,
        userShops: userShops,
        orders: allOrders,   // Non-nullable lists in model, so pass empty list if none
        cartItems: cartItems,
      );
    } catch (e) {
      print('Error loading profile, cart, or orders: $e');
      rethrow;
    }
  }
}
