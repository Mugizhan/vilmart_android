import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mib/bloc/store_category_bloc/store_category_event.dart';
import 'package:mib/bloc/store_category_bloc/store_category_state.dart';
import '../../data/repositories/store_category_repository.dart';
import '../form_bloc/data_fetch_status.dart';

class StoreCategoryBloc extends Bloc<StoreCategoryEvent, StoreCategoryState> {
  final ShopCategoryRepository categoryRepo;

  StoreCategoryBloc({required this.categoryRepo}) : super(const StoreCategoryState()) {
    on<FetchStore>(_onFetchStoreEventToState);
  }

  Future<void> _onFetchStoreEventToState(
      FetchStore event,
      Emitter<StoreCategoryState> emit,
      ) async {
    try {
      final shops = await categoryRepo.fetchProducts(
        event.category,
        event.city,
      );

      emit(StoreCategoryState(
        stores: shops,
        formStatus: const DataFetchSuccess(),
      ));
    } catch (e) {
      emit(const StoreCategoryState(
        stores: [],
        formStatus: DataFetchFailed(),
      ));
    }
  }
}
