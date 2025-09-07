import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/profile_model/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadUserProfileAndShops>(_onLoadUserProfileAndShops);
  }

  Future<void> _onLoadUserProfileAndShops(
      LoadUserProfileAndShops event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profileData = await repository.fetchUserProfileShopsOrdersCart();

      // ✅ Print full model data
      print('User Profile: ${profileData.userProfile}');
      print('Shops: ${profileData.userShops}');
      print('Orders: ${profileData.orders}');
      print('Cart Items: ${profileData.cartItems}');

      // Optionally print as JSON if your model supports `.toJson()`
      // print('Full Profile JSON: ${profileData.toJson()}');
      emit(ProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
