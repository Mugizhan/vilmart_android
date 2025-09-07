import 'package:bloc/bloc.dart';
import 'package:mib/bloc/shop_register_bloc/shop_register_event.dart';
import 'package:mib/bloc/shop_register_bloc/shop_register_state.dart';
import '../../data/model/add_store_model/add_store_model.dart';
import '../../data/repositories/store_add_repository.dart';
import '../form_bloc/form_submission_status.dart';

class ShopRegisterBloc extends Bloc<ShopRegisterEvent, ShopRegisterState> {
  final StoreAddRepository storeAddRepository;

  ShopRegisterBloc({required this.storeAddRepository})
      : super(ShopRegisterState()) {
    on<ShopRegisterEvent>(_onMapEventToState);
  }

  Future<void> _onMapEventToState(
      ShopRegisterEvent event, Emitter<ShopRegisterState> emit) async {
    if (event is onCategoryChange) {
      emit(state.copyWith(
        categoryIndex: event.index,
        category: event.category,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopNameChange) {
      emit(state.copyWith(
        shopName: event.shopName,
        isShopName: event.shopName.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopOwnerChange) {
      emit(state.copyWith(
        ownerName: event.ownerName,
        isOwnerName: event.ownerName.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopPhoneChange) {
      emit(state.copyWith(
        phone: event.phone,
        isPhone: RegExp(r'^\d{10}$').hasMatch(event.phone),
        formStatus: FormEditing(),
      ));
    } else if (event is onShopEmailChange) {
      emit(state.copyWith(
        email: event.email,
        isEmail: RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
            event.email),
        formStatus: FormEditing(),
      ));
    }
    else if (event is onShopImageLinkChange) {
      emit(state.copyWith(
        shopImageLink: event.shopImageLink,
        isShopImageLink: event.shopImageLink.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopLocationChange) {

      print('Latitude: ${event.latitude}');
      print('Longitude: ${event.longitude}');
      emit(state.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopAddressChange) {
      emit(state.copyWith(
        address: event.address,
        isAddress: event.address.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopCityChange) {
      emit(state.copyWith(
        city: event.city,
        isCity: event.city.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopStateChange) {

      emit(state.copyWith(
        state: event.state,
        isState: event.state.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopCountryChange) {
      emit(state.copyWith(
        country: event.country,
        isCountry: event.country.isNotEmpty,
        formStatus: FormEditing(),
      ));
    } else if (event is onShopPincodeChange) {
      emit(state.copyWith(
        pincode: event.pincode,
        isPincode: RegExp(r'^\d{6}$').hasMatch(event.pincode),
        formStatus: FormEditing(),
      ));
    } else if (event is onShopGstChange) {
      emit(state.copyWith(
        gst: event.gst,
        isGst: RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$')
            .hasMatch(event.gst),
        formStatus: FormEditing(),
      ));
    } else if (event is onSubmitButtonCLicked) {
      print("Submit clicked");
      final isValid = state.isShopName &&
          state.isOwnerName &&
          state.isPhone &&
          state.isEmail &&
          state.isAddress &&
          state.isCity &&
          state.isState &&
          state.isCountry &&
          state.isPincode;

      emit(state.copyWith(formStatus: FormSubmitting()));

      if (isValid) {
        // Print state for debugging
        print('--- Form State Data ---');
        print('Category: ${state.category}');
        print('Shop Name: ${state.shopName}');
        print('Owner Name: ${state.ownerName}');
        print('Phone: ${state.phone}');
        print('Email: ${state.email}');
        print('Latitude: ${state.latitude}');
        print('Longitude: ${state.longitude}');
        print('Address: ${state.address}');
        print('City: ${state.city}');
        print('Country: ${state.country}');
        print('Country: ${state.country}');
        print('Pincode: ${state.pincode}');
        print('GST: ${state.gst}');
        final storeAddress = AddressModel(
          address: state.address,
          city: state.city,
          state: state.state,
          country: state.country,
          pincode: state.pincode,
        );
        final storeLocation = LatLonModel(
          latitude: state.latitude,
          longitude: state.longitude,
        );
        final storeData = AddStoreModel(
          category: state.category,
          shopName: state.shopName,
          ownerName: state.ownerName,
          phone: state.phone,
          email: state.email,
          shopImageLink:state.shopImageLink,
          latlon: storeLocation,
          address: storeAddress,
          gst: state.gst,
          rating: state.rating,


        );
        try {
          final response = await storeAddRepository.addStore(storeData);
          emit(state.copyWith(formStatus: SubmissionSuccess(message: response)));
        } catch (e) {
          emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
        }
      } else {
        emit(state.copyWith(formStatus: SubmissionFailed('Invalid form')));
      }
    }
  }
}
