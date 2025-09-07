import '../../data/model/product_register_model/product_register_model.dart';

abstract class CatalogState {}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogUploadSuccess extends CatalogState {
  final List<Product> products;
  CatalogUploadSuccess(this.products);
}

class CatalogFailure extends CatalogState {
  final String error;
  CatalogFailure(this.error);
}

class CatalogDownloadSuccess extends CatalogState {}
