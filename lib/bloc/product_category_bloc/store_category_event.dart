import 'package:equatable/equatable.dart';

abstract class ProductCategoryEvent extends Equatable {
  const ProductCategoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchProduct extends ProductCategoryEvent {
  final String shopId;
  const FetchProduct({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}
