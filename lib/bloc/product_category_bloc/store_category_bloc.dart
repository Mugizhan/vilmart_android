import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mib/bloc/product_category_bloc/store_category_event.dart';
import 'package:mib/bloc/product_category_bloc/store_category_state.dart';
import '../../data/repositories/product_category_repository.dart';
import '../form_bloc/data_fetch_status.dart';

class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final ProductCategoryRepository categoryRepo;

  ProductCategoryBloc({required this.categoryRepo}) : super(const ProductCategoryState()) {
    on<FetchProduct>(_onFetchProductEventToState);
  }

  Future<void> _onFetchProductEventToState(
      FetchProduct event,
      Emitter<ProductCategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(formStatus: const DataFetchLoading()));

      final storeData = await categoryRepo.fetchProducts(event.shopId);

      emit(ProductCategoryState(
        store: storeData.shop,
        products: storeData.products,
        formStatus: const DataFetchSuccess(),
      ));
    } catch (e) {
      emit(const ProductCategoryState(
        store: null,
        products: [],
        formStatus: DataFetchFailed(),
      ));
    }
  }
}
