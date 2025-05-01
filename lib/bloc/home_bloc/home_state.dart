import 'package:equatable/equatable.dart';
import 'package:vilmart_android/data/model/home_model/home_model.dart';
import '../form_bloc/data_fetch_status.dart';

class HomeState extends Equatable {
  final List<HomeModel> productData;
  final DataFetchStatus status;
  final String? errorMessage;

  const HomeState({
    this.productData = const [],
    this.status = const InitialDataStatus(),
    this.errorMessage,
  });

  HomeState copyWith({
    List<HomeModel>? productData,
    DataFetchStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      productData: productData ?? this.productData,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [productData, status, errorMessage];
}
