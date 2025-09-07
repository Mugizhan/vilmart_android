import 'package:equatable/equatable.dart';

import '../../data/model/add_store_model/add_store_model.dart';
import '../form_bloc/data_fetch_status.dart';

class StoreCategoryState extends Equatable {
  final List<AddStoreModel>? stores;
  final DataFetchStatus formStatus;

  const StoreCategoryState({
    this.stores = const [],
    this.formStatus = const DataFetchLoading(),
  });

  StoreCategoryState copyWith({
    List<AddStoreModel>? stores,
    DataFetchStatus? formStatus,
  }) {
    return StoreCategoryState(
      stores: stores ?? this.stores,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [stores ?? [], formStatus];
}
