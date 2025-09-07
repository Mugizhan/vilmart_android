import 'package:equatable/equatable.dart';

abstract class ShopRegisterEvent extends Equatable{
  const ShopRegisterEvent();
  @override
  List<Object?> get props => [];
}

class onCategoryChange extends ShopRegisterEvent{
  final int index;
  final String category;
  const onCategoryChange({required this.index,required this.category});
  @override
  List<Object?>get props=>[index,category];

}


class onShopNameChange extends ShopRegisterEvent{
  final String shopName;
  const onShopNameChange({required this.shopName});
  @override
  List<Object?>get props=>[shopName];

}

class onShopOwnerChange extends ShopRegisterEvent{
  final String ownerName;
  const onShopOwnerChange({required this.ownerName});
  @override
  List<Object?>get props=>[ownerName];
}

class onShopPhoneChange extends ShopRegisterEvent{
  final String phone;
  const onShopPhoneChange({required this.phone});
  @override
  List<Object?>get props=>[phone];
}

class onShopEmailChange extends ShopRegisterEvent{
  final String email;
  const onShopEmailChange({required this.email});
  @override
  List<Object?>get props=>[email];
}
class onShopImageLinkChange extends ShopRegisterEvent{
  final String shopImageLink;
  const onShopImageLinkChange({required this.shopImageLink});
  @override
  List<Object?>get props=>[shopImageLink];
}
class onShopLocationChange extends ShopRegisterEvent{
  final double latitude;
  final double longitude;
  const onShopLocationChange({required this.latitude,required this.longitude});
  @override
  List<Object?>get props=>[latitude,longitude];
}

class onShopAddressChange extends ShopRegisterEvent{
  final String address;
  const onShopAddressChange({required this.address});
  @override
  List<Object?>get props=>[address];
}
class onShopCityChange extends ShopRegisterEvent{
  final String city;
  const onShopCityChange({required this.city});
  @override
  List<Object?>get props=>[city];
}
class onShopStateChange extends ShopRegisterEvent{
  final String state;
  const onShopStateChange({required this.state});
  @override
  List<Object?>get props=>[state];
}
class onShopCountryChange extends ShopRegisterEvent{
  final String country;
  const onShopCountryChange({required this.country});
  @override
  List<Object?>get props=>[country];
}
class onShopPincodeChange extends ShopRegisterEvent{
  final String pincode;
  const onShopPincodeChange({required this.pincode});
  @override
  List<Object?>get props=>[pincode];
}

class onShopGstChange extends ShopRegisterEvent{
  final String gst;
  const onShopGstChange({required this.gst});
  @override
  List<Object?>get props=>[gst];
}



class onSubmitButtonCLicked extends ShopRegisterEvent{}