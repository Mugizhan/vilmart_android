import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/form_bloc/data_fetch_status.dart';
import '../../bloc/product_category_bloc/store_category_bloc.dart';
import '../../data/repositories/product_category_repository.dart';
import '../../bloc/product_category_bloc/store_category_state.dart';
import '../../bloc/product_category_bloc/store_category_event.dart';
import '../../widgets/loading_screen.dart';
import '../category/product_detail_page.dart';

class ShopProduct extends StatelessWidget {
  final String shopId;

  const ShopProduct({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final categoryRepo = context.read<ProductCategoryRepository>();
    return BlocProvider(
      create: (_) =>
      ProductCategoryBloc(categoryRepo: categoryRepo)..add(FetchProduct(shopId: shopId)),
      child: const _ShopProductView(),
    );
  }
}

class _ShopProductView extends StatelessWidget {
  const _ShopProductView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
        actions: [
          BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
            builder: (context, state) {
              final shopName = state.store?.shopName.toUpperCase() ?? 'SHOP';
              final address = state.store?.address;
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      shopName,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (address != null)
                      Text(
                        '${address.address}, ${address.city}, ${address.state}',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductCategoryBloc, ProductCategoryState>(
        listener: (context, state) {
          if (state.formStatus is DataFetchFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to access this store'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.formStatus is DataFetchLoading) {
            return const LoadingScreen();
          }

          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('${state.store?.shopImageLink ?? ''}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: Colors.black.withOpacity(0.65),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.13,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  prefixIcon: const Icon(Icons.search_outlined),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.tune_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${state.products.length} products found in & around ${state.store?.shopName ?? ''}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ProductCategoryBloc>(),
                                      child: ProductDetailPage(
                                        productId: product.productId,
                                        shopId: state.store?.shopId ?? '',
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product.productImages,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: product.availabilityStatus.toLowerCase() == 'in stock'
                                              ? [Colors.black, Colors.transparent]
                                              : [Colors.red, Colors.transparent],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 10,
                                      bottom: 10,
                                      right: 10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('₹${product.price}',
                                                  style: const TextStyle(fontSize: 12, color: Colors.green)),
                                              Text(product.availabilityStatus,
                                                  style: const TextStyle(fontSize: 12, color: Colors.white)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
