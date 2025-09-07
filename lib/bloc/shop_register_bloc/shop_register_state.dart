import 'package:equatable/equatable.dart';
import '../form_bloc/form_submission_status.dart';

class ShopRegisterState extends Equatable {
  final String category;
  final int categoryIndex;
  final String shopName;
  final String ownerName;
  final String phone;
  final String email;
  final String shopImageLink;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String gst;
  final String rating;

  final bool isShopName;
  final bool isOwnerName;
  final bool isPhone;
  final bool isEmail;
  final bool isShopImageLink;
  final bool isAddress;
  final bool isCity;
  final bool isState;
  final bool isCountry;
  final bool isPincode;
  final bool isGst;

  final FormSubmissionStatus formStatus;

  ShopRegisterState({
    this.categoryIndex = 0,
    this.category = '',
    this.shopName = '',
    this.ownerName = '',
    this.phone = '',
    this.email = '',
    this.shopImageLink='',
    this.latitude = 0,
    this.longitude = 0,
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.pincode = '',
    this.gst = '',
    this.rating='1',
    this.isShopName = true,
    this.isOwnerName = true,
    this.isPhone = true,
    this.isEmail = true,
    this.isShopImageLink=true,
    this.isAddress = true,
    this.isCity = true,
    this.isState = true,
    this.isCountry = true,
    this.isPincode = true,
    this.isGst = true,
    this.formStatus = const InitialFormStatus(),
  });

  ShopRegisterState copyWith({
    int? categoryIndex,
    String? category,
    String? shopName,
    String? ownerName,
    String? phone,
    String? email,
    String? shopImageLink,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? gst,
    String? rating,
    bool? isShopName,
    bool? isOwnerName,
    bool? isPhone,
    bool? isEmail,
    bool? isShopImageLink,
    bool? isAddress,
    bool? isCity,
    bool? isState,
    bool? isCountry,
    bool? isPincode,
    bool? isGst,
    FormSubmissionStatus? formStatus,
  }) {
    return ShopRegisterState(
      categoryIndex: categoryIndex ?? this.categoryIndex,
      category: category ?? this.category,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      shopImageLink:shopImageLink??this.shopImageLink,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      gst: gst ?? this.gst,
      rating: rating??this.rating,
      isShopName: isShopName ?? this.isShopName,
      isOwnerName: isOwnerName ?? this.isOwnerName,
      isPhone: isPhone ?? this.isPhone,
      isEmail: isEmail ?? this.isEmail,
      isShopImageLink:isShopImageLink??this.isShopImageLink,
      isAddress: isAddress ?? this.isAddress,
      isCity: isCity ?? this.isCity,
      isState: isState ?? this.isState,
      isCountry: isCountry ?? this.isCountry,
      isPincode: isPincode ?? this.isPincode,
      isGst: isGst ?? this.isGst,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [
    category,
    categoryIndex,
    shopName,
    ownerName,
    phone,
    email,
    shopImageLink,
    latitude,
    longitude,
    address,
    city,
    state,
    country,
    pincode,
    gst,
    rating,
    isShopName,
    isOwnerName,
    isPhone,
    isEmail,
    isShopImageLink,
    isAddress,
    isCity,
    isState,
    isCountry,
    isPincode,
    isGst,
    formStatus,
  ];
}
