// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) =>
    RegisterModel(
      name: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['number'] as int,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{
      'username': instance.name,
      'email': instance.email,
      'number': instance.phoneNumber,
      'password': instance.password,
    };
