import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/form_bloc/form_submission_status.dart';
import '../bloc/shop_register_bloc/shop_register_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../bloc/shop_register_bloc/shop_register_event.dart';
import '../bloc/shop_register_bloc/shop_register_state.dart';
import '../data/repositories/store_add_repository.dart';

class AddStore extends StatefulWidget {
  const AddStore({super.key});

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ShopRegisterBloc(storeAddRepository:context.read<StoreAddRepository>()),
  child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent[200],
        elevation: 0,
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.store,color: Colors.white),
        ),
        title: const Text('Create Your Store',style: TextStyle(
          color:Colors.white,
          fontWeight: FontWeight.bold
        )),
      ),
      body: BlocListener<ShopRegisterBloc, ShopRegisterState>(
          listener: (context, state) async{
            if (state.formStatus is SubmissionSuccess) {
              final successState = state.formStatus as SubmissionSuccess;
              await  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Row(
                  children: [
                    Icon(Icons.task_alt,color:Colors.white),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        successState.message,
                        overflow: TextOverflow.ellipsis,  // Ensures text is truncated if it overflows
                        maxLines: 1,  // Prevents text from wrapping to multiple lines
                      ),
                    ),
                  ],
                ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
              context.go('/home');
            } else if (state.formStatus is SubmissionFailed) {
              final failedState = state.formStatus as SubmissionFailed;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:Row(
                      children: [
                        Icon(Icons.error,color:Colors.white),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            failedState.message,
                            overflow: TextOverflow.ellipsis,  // Ensures text is truncated if it overflows
                            maxLines: 1,  // Prevents text from wrapping to multiple lines
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior:SnackBarBehavior.floating
                ),

              );
            }
          },
  child: Container(
        color: Colors.redAccent[200],
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red[100],
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black38,
                  tabs: const [
                    Tab(icon: Icon(Icons.store)),
                    Tab(icon: Icon(Icons.check_circle)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: TabBarView(
                  children: [
                    InnerTabView(), // ✅ Nested tabs handled properly
                    StoreConfirm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
),
    ),
);
  }
}


class InnerTabView extends StatelessWidget {
  const InnerTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: const [
          TabBar(
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              dividerColor:Colors.transparent,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(child: Text('Add Shop Details',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ))),
                Tab(child: Text('Document Verification',style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ))),
              ],
            ),
          Expanded(
            child: TabBarView(
              children: [
                StoreDetails(),
               Center(child: Text('Document Verification'),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// StoreDetails.dart
class StoreDetails extends StatefulWidget {
  const StoreDetails({super.key});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ShopRegisterBloc, ShopRegisterState>(
  builder: (context, state) {
    final selectedLocation = state.latitude != 0 && state.longitude != 0
        ? LatLng(state.latitude, state.longitude)
        : null;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft:Radius.circular(30),topRight: Radius.circular(30))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader('1/3', 'Add Store Details', 'Setup your shop by entering your description'),
          const SizedBox(height: 20),
          const Text('Select Shop Category', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
              buildCategoryTile(index: 0, label: 'Restaurant', image: 'assets/images/Categories/cooking.png',),
              buildCategoryTile(index: 1, label: 'Groceries', image: 'assets/images/Categories/grocery.png'),
              buildCategoryTile(index: 2, label: 'Electronics & Gadgets', image: 'assets/images/Categories/gadgets.png'),
              buildCategoryTile(index: 3, label: 'Fashion & Apparel', image: 'assets/images/Categories/wardrobe.png'),
              buildCategoryTile(index: 4, label: 'Home & Furniture', image: 'assets/images/Categories/livingroom.png'),
              buildCategoryTile(index: 5, label: 'Health & Beauty', image: 'assets/images/Categories/skin-care.png'),
              buildCategoryTile(index: 6, label: 'Books & Stationery', image: 'assets/images/Categories/stationery.png'),
              buildCategoryTile(index: 7, label: 'Sports & Outdoors', image: 'assets/images/Categories/badminton.png'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Add shop description', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 24),

          const Text('Shop name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopNameChange(shopName: value));
              },
              decoration: InputDecoration(
                hintText: 'Shop Name',
                errorText: state.isShopName ? null : "Enter the shop name",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.store),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Owner name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopOwnerChange(ownerName: value));
              },
              decoration: InputDecoration(
                hintText: 'Owner Name',
                errorText: state.isOwnerName ? null : "Enter the Owner name",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.person),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Shop Contact Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopPhoneChange(phone: value));
              },
              decoration: InputDecoration(
                hintText: 'Phone Number',
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.phone),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Shop Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopEmailChange(email: value));
              },
              decoration: InputDecoration(
                hintText: 'Email',
                errorText: state.isEmail ? null : "Enter the valid mail",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.email),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Shop IMage Link', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopImageLinkChange(shopImageLink: value));
              },
              decoration: InputDecoration(
                hintText: 'Copy & paste the shop image link here',
                errorText: state.isEmail ? null : "Enter the valid url",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.link),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Select you location', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          SizedBox(
            height: 200,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: const LatLng(20.5937, 78.9629),
                        initialZoom: 5.0,
                        onTap: (tapPosition, point) {
                          context.read<ShopRegisterBloc>().add(
                            onShopLocationChange(latitude: point.latitude, longitude: point.longitude),
                          );
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        if (selectedLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: selectedLocation!,
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                child: const Icon(Icons.store, color: Colors.red, size: 30),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Lat:${state.latitude}'),
                      Text('lon:${state.longitude}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Text('Shop Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopAddressChange(address: value));
              },
              decoration: InputDecoration(
                hintText: 'Address',
                errorText: state.isAddress ? null : "Enter the address",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.location_on),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('City', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopCityChange(city: value));
              },
              decoration: InputDecoration(
                hintText: 'City',
                errorText: state.isCity ? null : "Enter the City",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.business),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('State', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopStateChange(state: value));
              },
              decoration: InputDecoration(
                hintText: 'State',
                errorText: state.isState ? null : "Enter the State",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.account_balance),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Country', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopCountryChange(country: value));
              },
              decoration: InputDecoration(
                hintText: 'Country',
                errorText: state.isCountry ? null : "Enter the Country",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.public),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('Shop Pincode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopPincodeChange(pincode: value));
              },
              decoration: InputDecoration(
                hintText: 'Pincode',
                errorText: state.isPincode ? null : "Enter the valid pincode",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.pin_drop),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const Text('GST Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              onChanged: (value) {
                context.read<ShopRegisterBloc>().add(onShopGstChange(gst: value));
              },
              decoration: InputDecoration(
                hintText: 'GST Number',
                errorText: state.isGst ? null : "Enter the valid GST number",
                fillColor: Colors.grey[50],
                filled: true,
                prefixIcon: const Icon(Icons.price_change_outlined),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<ShopRegisterBloc>().add(onSubmitButtonCLicked());
              },
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Colors.redAccent[200],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Add Store', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  },
),
    );
  }

  Widget buildCategoryTile({required int index, required String label, required String image}) {
    final isSelected = context.read<ShopRegisterBloc>().state.categoryIndex==index;
    return GestureDetector(
      onTap: (){
       context.read<ShopRegisterBloc>().add(onCategoryChange(index: index, category: label));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(image, width: 40, height: 40, color: Colors.black87),
                  const SizedBox(height: 12),
                  Text(label, style: const TextStyle(fontSize: 10,),textAlign: TextAlign.center,),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }



  Widget sectionHeader(String step, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(step, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}

// ProductDetails.dart

// StoreConfirm.dart
class StoreConfirm extends StatelessWidget {
  const StoreConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 50),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height:300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Shopadded.png'),
                  fit: BoxFit.cover, // You can change this as needed
                ),
              ),
            ),
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text("Store Setup Complete!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("You're all set to start adding and managing your products."),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text("Go to Dashboard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

