import 'package:equatable/equatable.dart';
import '../../data/model/product_register_model/product_register_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomePageLoad extends HomeEvent {}

class LogoutClick extends HomeEvent {}
