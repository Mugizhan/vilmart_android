import 'package:equatable/equatable.dart';
import '../../data/model/add_store_model/add_store_model.dart';
import '../../data/model/product_register_model/product_register_model.dart';
import '../form_bloc/data_fetch_status.dart';

class ProductCategoryState extends Equatable {
  final AddStoreModel? store;
  final List<Product> products;
  final DataFetchStatus formStatus;

  const ProductCategoryState({
    this.store,
    this.products = const [],
    this.formStatus = const DataFetchLoading(),
  });

  ProductCategoryState copyWith({
    AddStoreModel? store,
    List<Product>? products,
    DataFetchStatus? formStatus,
  }) {
    return ProductCategoryState(
      store: store ?? this.store,
      products: products ?? this.products,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [store, products, formStatus];
}
