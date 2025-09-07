import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart.g.dart';

@JsonSerializable()
class CartItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String sellerId;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.sellerId,
    required this.imageUrl,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      productName: productName,
      quantity: quantity ?? this.quantity,
      price: price,
      sellerId: sellerId,
      imageUrl: imageUrl,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
