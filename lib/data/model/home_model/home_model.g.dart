// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      image: json['image'] as String,
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'image': instance.image,
    };
