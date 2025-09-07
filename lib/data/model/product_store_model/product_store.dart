import 'package:json_annotation/json_annotation.dart';
import '../add_store_model/add_store_model.dart';
import '../product_register_model/product_register_model.dart';

part 'product_store.g.dart';

@JsonSerializable()
class ProductStoreModel{
  final AddStoreModel shop;
  final List<Product> products;
  const ProductStoreModel({required this.shop,required this.products});

  factory ProductStoreModel.fromJson(Map<String,dynamic> json)=>_$ProductStoreModelFromJson(json);

  Map<String,dynamic> toJson()=>_$ProductStoreModelToJson(this);
}