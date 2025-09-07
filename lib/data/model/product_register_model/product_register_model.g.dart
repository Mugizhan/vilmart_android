// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['productId'] as String,
      shopId: json['shopId'] as String,
      productName: json['productName'] as String,
      productDescription: json['productDescription'] as String,
      productCategory: json['productCategory'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      productImages: json['productImages'] as String,
      brand: json['brand'] as String,
      discountOrOffers: json['discountOrOffers'] as String,
      productLocation: json['productLocation'] as String,
      deliveryTime: json['deliveryTime'] as String,
      productRating: json['productRating'] as int,
      availabilityStatus: json['availabilityStatus'] as String,
      warranty: json['warranty'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productId': instance.productId,
      'shopId': instance.shopId,
      'productName': instance.productName,
      'productDescription': instance.productDescription,
      'productCategory': instance.productCategory,
      'price': instance.price,
      'quantity': instance.quantity,
      'productImages': instance.productImages,
      'brand': instance.brand,
      'discountOrOffers': instance.discountOrOffers,
      'productLocation': instance.productLocation,
      'deliveryTime': instance.deliveryTime,
      'productRating': instance.productRating,
      'availabilityStatus': instance.availabilityStatus,
      'warranty': instance.warranty,
    };
