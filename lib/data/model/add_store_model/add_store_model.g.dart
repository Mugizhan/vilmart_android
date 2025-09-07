// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddStoreModel _$AddStoreModelFromJson(Map<String, dynamic> json) =>
    AddStoreModel(
      shopId: json['shopId'] as String? ?? '',
      category: json['category'] as String,
      shopName: json['shopName'] as String,
      ownerName: json['ownerName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      shopImageLink: json['shopImageLink'] as String,
      latlon: LatLonModel.fromJson(json['latlon'] as Map<String, dynamic>),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      gst: json['gst'] as String,
      rating: json['rating'] as String,
    );

Map<String, dynamic> _$AddStoreModelToJson(AddStoreModel instance) =>
    <String, dynamic>{
      'shopId': instance.shopId,
      'category': instance.category,
      'shopName': instance.shopName,
      'ownerName': instance.ownerName,
      'phone': instance.phone,
      'email': instance.email,
      'shopImageLink': instance.shopImageLink,
      'latlon': instance.latlon,
      'address': instance.address,
      'gst': instance.gst,
      'rating': instance.rating,
    };

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      pincode: json['pincode'] as String,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
    };

LatLonModel _$LatLonModelFromJson(Map<String, dynamic> json) => LatLonModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLonModelToJson(LatLonModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
