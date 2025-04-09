import 'package:equatable/equatable.dart';
import 'package:vilmart_android/data/model/home_model/home_model.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomePageLoad extends HomeEvent {}

class HomePageLoaded extends HomeEvent {
  final List<HomeModel> productData;

  HomePageLoaded({required this.productData});

  @override
  List<Object?> get props => [productData];
}

class HomePageLoadFailed extends HomeEvent {
  final String error;

  HomePageLoadFailed({required this.error});

  @override
  List<Object?> get props => [error];
}
