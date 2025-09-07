import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mib/screens/payment_page.dart';
import '../bloc/add_to_cart/add_to_cart_bloc.dart';
import '../bloc/add_to_cart/add_to_cart_event.dart';
import '../bloc/add_to_cart/add_to_cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search_outlined),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.tune_rounded, color: Colors.black),
            ),
          ),
          Tooltip(
            message: 'favorite',
            child: Container(
              padding: EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite, color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),

      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartCheckoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Checkout successful!')),
            );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            final items = state.items;
            if (items.isEmpty) return const Center(child: Text('Your cart is empty'));

            final total = items.fold<double>(0, (sum, item) => sum + item.price * item.quantity);

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ElevatedButton(
                    onPressed: ()async{
                      final confirmed = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(amount: total),
                        ),
                      );

                      if (confirmed == true) {
                        // Payment success - now trigger checkout in bloc
                        context.read<CartBloc>().add(CheckoutCart());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Proceed to Buy (${items.length} items)',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                item.imageUrl,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 50);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: item.quantity > 1
                                              ? () {
                                            context.read<CartBloc>().add(UpdateCartItemQuantity(item.productId, item.quantity - 1));
                                          }
                                              : null,
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            context.read<CartBloc>().add(UpdateCartItemQuantity(item.productId, item.quantity + 1));
                                          },
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            context.read<CartBloc>().add(RemoveItemFromCart(item.productId));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subtotal: ₹',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        '${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            );
          }

          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
