// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      sellerId: json['sellerId'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
      'price': instance.price,
      'sellerId': instance.sellerId,
      'imageUrl': instance.imageUrl,
    };
