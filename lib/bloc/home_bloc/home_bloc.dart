import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/product_register_model/product_register_model.dart';
import '../../data/repositories/home_repository.dart';
import '../form_bloc/data_fetch_status.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(const HomeState()) {
    on<HomePageLoad>(_onHomePageLoad);
    on<LogoutClick>(_onLogoutClick);
  }

  Future<void> _onHomePageLoad(
      HomePageLoad event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(status: const DataFetchLoading()));

    try {
      final List<Product> products = await homeRepository.fetchProducts();
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

  Future<void> _onLogoutClick(
      LogoutClick event,
      Emitter<HomeState> emit,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPhone');
    await prefs.remove('userPassword');
    emit(const HomeState()); // reset state
  }
}
