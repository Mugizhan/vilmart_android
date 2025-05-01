import 'package:bloc/bloc.dart';
import 'package:vilmart_android/bloc/form_bloc/data_fetch_status.dart';
import 'package:vilmart_android/data/repositories/home_repository.dart';
import '../../data/model/home_model/home_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(const HomeState()) {
    on<HomePageLoad>(_onHomePageLoad);
  }

  Future<void> _onHomePageLoad(
      HomePageLoad event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(status: const DataFetchLoading()));

    try {
      final List<HomeModel> products = await homeRepository.FetchProduct();
      emit(state.copyWith(
        productData: products,
        status: const DataFetchSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: const DataFetchFailed(),
        errorMessage: e.toString(),
      ));
    }
  }
}
