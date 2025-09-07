import 'package:json_annotation/json_annotation.dart';

part 'product_register_model.g.dart';

@JsonSerializable()
class Product {
  final String productId;
  final String shopId;
  final String productName;
  final String productDescription;
  final String productCategory;
  final double price;
  final int quantity;
  final String productImages;
  final String brand;
  final String discountOrOffers;
  final String productLocation;
  final String deliveryTime;
  final int productRating;
  final String availabilityStatus;
  final String warranty;

  Product({
    required this.productId,
    required this.shopId,
    required this.productName,
    required this.productDescription,
    required this.productCategory,
    required this.price,
    required this.quantity,
    required this.productImages,
    required this.brand,
    required this.discountOrOffers,
    required this.productLocation,
    required this.deliveryTime,
    required this.productRating,
    required this.availabilityStatus,
    required this.warranty,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
