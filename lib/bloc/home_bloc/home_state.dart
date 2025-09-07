import 'package:equatable/equatable.dart';
import '../../data/model/product_register_model/product_register_model.dart';
import '../form_bloc/data_fetch_status.dart';

class HomeState extends Equatable {
  final List<Product> productData;
  final DataFetchStatus status;
  final String? errorMessage;

  const HomeState({
    this.productData = const [],
    this.status = const DataFetchLoading(),
    this.errorMessage,
  });

  HomeState copyWith({
    List<Product>? productData,
    DataFetchStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      productData: productData ?? this.productData,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [productData, status, errorMessage];
}
