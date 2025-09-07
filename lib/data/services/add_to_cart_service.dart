import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/add_to_cart/add_to_cart.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserId() async {
    return _auth.currentUser?.uid;
  }

  Future<void> addToCart(CartItem item) async {
    final userId = await getUserId();
    if (userId == null) throw Exception('User not logged in');

    final cartCollection = _db.collection('users').doc(userId).collection('cart');

    final existingItemQuery = await cartCollection
        .where('productId', isEqualTo: item.productId)
        .limit(1)
        .get();

    if (existingItemQuery.docs.isNotEmpty) {
      final doc = existingItemQuery.docs.first;
      final currentQty = doc.data()['quantity'] as int;
      await doc.reference.update({'quantity': currentQty + item.quantity});
    } else {
      await cartCollection.add(item.toJson());
    }
  }

  Future<void> removeFromCart(String productId) async {
    final userId = await getUserId();
    if (userId == null) throw Exception('User not logged in');

    final cartCollection = _db.collection('users').doc(userId).collection('cart');

    final query = await cartCollection
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.delete();
    }
  }

  Future<List<CartItem>> getCartItems() async {
    final userId = await getUserId();
    if (userId == null) throw Exception('User not logged in');

    final snapshot =
    await _db.collection('users').doc(userId).collection('cart').get();

    return snapshot.docs.map<CartItem>((doc) {
      final data = doc.data();
      return CartItem.fromJson(data);
    }).toList();
  }

  Future<void> checkout() async {
    final userId = await getUserId();
    if (userId == null) throw Exception('User not logged in');

    final cartSnapshot = await _db.collection('users').doc(userId).collection('cart').get();
    final batch = _db.batch();

    for (var cartDoc in cartSnapshot.docs) {
      final data = cartDoc.data();
      final productId = data['productId'] as String;
      final productImage = data['imageUrl'] as String;
      final productName = data['productName'] as String;
      final sellerId = data['sellerId'] as String;
      final quantity = data['quantity'] as int;
      final price = (data['price'] as num).toDouble();

      final orderData = {
        'productId': productId,
        'imageUrl': productImage,
        'productName': productName,
        'userId': userId,
        'quantity': quantity,
        'price': price,
        'status': 'pending',
        'orderDate': FieldValue.serverTimestamp(),
      };

      // Save to seller's order collection
      final sellerOrderRef = _db.collection('shops').doc(sellerId).collection('orders').doc();
      batch.set(sellerOrderRef, orderData);

      // Save to user's order collection
      final userOrderRef = _db.collection('users').doc(userId).collection('orders').doc();
      batch.set(userOrderRef, orderData);
    }

    // Clear user's cart after checkout
    for (var cartDoc in cartSnapshot.docs) {
      batch.delete(cartDoc.reference);
    }

    await batch.commit();
  }


  Future<void> updateOrderStatusToPaid(String userId) async {
    final shopsSnapshot = await _db.collection('shops').get();
    final batch = _db.batch();

    for (var shopDoc in shopsSnapshot.docs) {
      final ordersRef = shopDoc.reference.collection('orders');
      final userOrdersSnapshot =
      await ordersRef.where('userId', isEqualTo: userId).get();

      for (var orderDoc in userOrdersSnapshot.docs) {
        batch.update(orderDoc.reference, {'status': 'paid'});
      }
    }

    await batch.commit();
  }
}
