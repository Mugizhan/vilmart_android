import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/add_to_cart/add_to_cart.dart';
import '../../data/repositories/add_to_cart_repository.dart';
import 'add_to_cart_event.dart';
import 'add_to_cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartRepository cartService;

  CartBloc({required this.cartService}) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItem);
    on<RemoveItemFromCart>(_onRemoveItem);
    on<UpdateCartItemQuantity>(_onUpdateQuantity);
    on<CheckoutCart>(_onCheckout);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await cartService.getCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddItem(AddItemToCart event, Emitter<CartState> emit) async {
    await cartService.addToCart(event.item);
    add(LoadCart());
  }

  Future<void> _onRemoveItem(RemoveItemFromCart event, Emitter<CartState> emit) async {
    await cartService.removeFromCart(event.productId);
    add(LoadCart());
  }

  Future<void> _onUpdateQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      final item = items.firstWhere((i) => i.productId == event.productId);
      final updatedItem = item.copyWith(quantity: event.quantity);
      await cartService.addToCart(updatedItem);
      add(LoadCart());
    }
  }

  Future<void> _onCheckout(CheckoutCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await cartService.checkout();
      emit(CartCheckoutSuccess());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
