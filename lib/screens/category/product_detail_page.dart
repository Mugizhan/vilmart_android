import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/product_category_bloc/store_category_bloc.dart';
import '../../bloc/product_category_bloc/store_category_state.dart';
import '../../bloc/add_to_cart/add_to_cart_bloc.dart';
import '../../bloc/add_to_cart/add_to_cart_event.dart';
import '../../data/model/add_to_cart/add_to_cart.dart';
import '../../data/model/product_register_model/product_register_model.dart';
import '../../widgets/loading_screen.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String shopId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
    required this.shopId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
          builder: (context, state) {
            final shopName = state.store?.shopName ?? 'Shop';
            return AppBar(
              backgroundColor: Colors.transparent,
              elevation: 50,
              title: Text(shopName),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
        builder: (context, state) {
          Product? product;
          try {
            product = state.products.firstWhere((p) => p.productId == productId);
          } catch (_) {
            product = null;
          }

          if (product == null) {
            return const LoadingScreen();
          }

          final rating = int.tryParse(product.productRating.toString()) ?? 0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product.productImages),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Product details section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.productName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(
                                rating,
                                    (_) => const Icon(Icons.star, color: Colors.orange, size: 20),
                              ),
                              ...List.generate(
                                5 - rating,
                                    (_) => const Icon(Icons.star_border, color: Colors.orange, size: 20),
                              ),
                              const SizedBox(width: 8),
                              Text('($rating)'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Provider: ${state.store?.shopName ?? 'N/A'}',
                        style: const TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.productDescription,
                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // Price
                      Row(
                        children: [
                          const Text(
                            'M.R.P : ₹ ',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            '${product.price}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Offer
                      Row(
                        children: [
                          const Icon(Icons.local_offer_rounded, color: Colors.blue, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            product.discountOrOffers,
                            style: const TextStyle(fontSize: 15, color: Colors.blue),
                          ),
                        ],
                      ),

                      const Divider(thickness: 1),
                      const SizedBox(height: 10),

                      // Availability
                      Text(
                        'Status: ${product.availabilityStatus}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Wishlist functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Add to WishList',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final cartItem = CartItem(
                              productId: product!.productId,
                              productName: product.productName,
                              price: product.price,
                              quantity: 1,
                              sellerId: shopId,
                              imageUrl: product.productImages,
                            );

                            context.read<CartBloc>().add(AddItemToCart(cartItem));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.productName} added to cart')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
