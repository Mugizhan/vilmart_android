import '../model/add_to_cart/add_to_cart.dart';
import '../services/add_to_cart_service.dart';


class AddToCartRepository {
  final CartService _cartService = CartService();

  Future<void> addToCart(CartItem item) async {
    await _cartService.addToCart(item);
  }

  Future<void> removeFromCart(String productId) async {
    await _cartService.removeFromCart(productId);
  }

  Future<List<CartItem>> getCartItems() async {
    return await _cartService.getCartItems();
  }

  Future<void> checkout() async {
    await _cartService.checkout();
  }

  Future<void> updateOrderStatusToPaid(String userId) async {
    await _cartService.updateOrderStatusToPaid(userId);
  }
}
