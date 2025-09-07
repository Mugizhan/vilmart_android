import '../services/profile_service.dart';
import '../model/profile_model/profile_model.dart';

class ProfileRepository {
  final ProfileService _profileService;

  ProfileRepository(this._profileService);

  Future<CompleteUserData> fetchUserProfileShopsOrdersCart() async {
    try {
      final CompleteUserData? data = await _profileService.getUserProfileShopsOrdersCart();

      if (data == null) {
        // Return empty default data or throw error based on your logic
        print('Warning: fetched CompleteUserData is null, returning empty data');
        return CompleteUserData(
          userProfile: UserProfile(),
          userShops: [],
          orders: [],
          cartItems: [],
        );
      }


      return data;
    } catch (e) {
      print('Error fetching CompleteUserData: $e');
      rethrow;
    }
  }
}
