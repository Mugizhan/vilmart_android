// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductStoreModel _$ProductStoreModelFromJson(Map<String, dynamic> json) =>
    ProductStoreModel(
      shop: AddStoreModel.fromJson(json['shop'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductStoreModelToJson(ProductStoreModel instance) =>
    <String, dynamic>{
      'shop': instance.shop,
      'products': instance.products,
    };
