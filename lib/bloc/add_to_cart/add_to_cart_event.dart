import 'package:equatable/equatable.dart';
import '../../data/model/add_to_cart/add_to_cart.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final CartItem item;
  AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItemFromCart extends CartEvent {
  final String productId;
  RemoveItemFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateCartItemQuantity(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class CheckoutCart extends CartEvent {}
