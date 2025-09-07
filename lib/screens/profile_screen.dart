import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(LoadUserProfileAndShops());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Profile'),
        actions: const [
          Icon(Icons.qr_code, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is ProfileLoaded) {
            final data = state.profileData;
            final user = data.userProfile;
            final shops = data.userShops;
            final orders = data.orders;
            final cartItems = data.cartItems;

            return Column(
              children: [
                Stack(
                  children: [
                    if (shops != null && shops.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...shops.where((shop) => shop.shopImageLink != null && shop.shopImageLink!.isNotEmpty).map(
                            (shop) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(shop.shopImageLink!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 30,
                                child: Icon(Icons.person, size: 30, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.username?.toUpperCase() ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user?.role ?? 'Customer',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(user?.email ?? 'No Email',
                                      style: const TextStyle(color: Colors.grey)),
                                  Text(user?.number?.toString() ?? 'No Number',
                                      style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (shops != null && shops.isNotEmpty) ...[
                            const Text(
                              'Your Shops',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ...shops.map((shop) => ListTile(
                              title: Row(
                                children: [
                                  Text(shop.shopName?.toUpperCase() ?? 'No Name'),
                                  Text(
                                    ' (${shop.category})',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${shop.address?.address}, ${shop.address?.city}, ${shop.address?.state}, ${shop.address?.pincode}',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            )),
                          ],
                          const Divider(height: 32),
                          SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star, color: Colors.grey),
                                    const Text('Ratings:'),
                                    Text(
                                      '${shops?.first.rating ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(width: 20, color: Colors.grey),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.inventory_rounded, color: Colors.grey),
                                    const Text('Orders:'),
                                    Text(
                                      '${orders?.length ?? 0}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(width: 20, color: Colors.grey),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.shopping_cart, color: Colors.grey),
                                    const Text('Cart:'),
                                    Text(
                                      '${cartItems?.length ?? 0}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Orders',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: orders!.map((order) {
                                final product = order.item!;
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    elevation: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                                              ? Image.network(
                                            product.imageUrl!,
                                            width: double.infinity,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image, size: 100),
                                          )
                                              : const Icon(Icons.broken_image, size: 100),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.productName ?? 'null',
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                              ),
                                              Text('Qty: ${product.quantity} • ₹${product.price}'),
                                              Text('Status: ${order.status}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const Divider(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Cart Items',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'See all',
                                style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...cartItems!.map((item) => Card(
                            child: ListTile(
                              leading: Image.network(
                                item.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                              ),
                              title: Text(item.productName!),
                              subtitle: Text('Qty: ${item.quantity} • ₹${item.price}'),
                              trailing: Text('Seller: ${item.sellerId}'),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
