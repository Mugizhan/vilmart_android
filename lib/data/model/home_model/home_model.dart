import 'package:json_annotation/json_annotation.dart';
part 'home_model.g.dart';
@JsonSerializable()
class HomeModel{

  @JsonKey(name:'title')
  final String title;
  @JsonKey(name:'price')
  final int price;
  @JsonKey(name:'description')
  final String description;
  @JsonKey(name:'image')
  final String image;

  HomeModel({required this.title,required this.description,required this.price,required this.image});

  factory HomeModel.fromJson(Map<String,dynamic> json)=>_$HomeModelFromJson(json);

  Map<String,dynamic> toJson()=>_$HomeModelToJson(this);
}