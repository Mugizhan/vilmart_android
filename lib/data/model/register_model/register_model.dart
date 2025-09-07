import 'package:json_annotation/json_annotation.dart';
part 'register_model.g.dart';

@JsonSerializable()
class RegisterModel {

  @JsonKey(name: 'username')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'number')
  final int phoneNumber;
  @JsonKey(name: 'password')
  final String password;

  RegisterModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String,dynamic> json)=>_$RegisterModelFromJson(json);

  Map<String,dynamic> toJson()=>_$RegisterModelToJson(this);

}

