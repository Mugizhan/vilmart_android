import 'package:equatable/equatable.dart';

abstract class StoreCategoryEvent extends Equatable {
  const StoreCategoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchStore extends StoreCategoryEvent {
  final String category;
  final String city;
  const FetchStore({required this.category, required this.city});

  @override
  List<Object?> get props => [category, city];
}
