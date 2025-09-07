import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/form_bloc/data_fetch_status.dart';
import '../../bloc/store_category_bloc/store_category_bloc.dart';
import '../../bloc/store_category_bloc/store_category_event.dart';
import '../../bloc/store_category_bloc/store_category_state.dart';
import '../../data/repositories/store_category_repository.dart';
import '../../widgets/loading_screen.dart';

class CataegoryScreen extends StatefulWidget {
  final String category;
  final String location;

  const CataegoryScreen({super.key, required this.category, required this.location});

  @override
  State<CataegoryScreen> createState() => _CataegoryScreenState();
}

class _CataegoryScreenState extends State<CataegoryScreen> {
  late StoreCategoryBloc _bloc;
  late int mainIndex = int.parse(widget.category);

  List<Map<String, String>> categories = [
    {
      'title': 'Restaurant',
      'image': 'https://img.freepik.com/premium-photo/indian-cuisine-food-table-restaurant_663838-136.jpg'
    },
    {
      'title': 'Groceries',
      'image': 'https://t3.ftcdn.net/jpg/10/52/04/50/360_F_1052045092_q84uPpI88Fbj0BaTM80pI270LK8PbkPK.jpg'
    },
    {
      'title': 'Electronics & Gadgets',
      'image': 'https://png.pngtree.com/thumb_back/fh260/background/20240415/pngtree-new-mobile-smartphone-in-telecommunication-electronic-store-display-showcase-image_15659077.jpg'
    },
    {
      'title': 'Fashion & Apparel',
      'image': 'https://st5.depositphotos.com/10614052/66097/i/450/depositphotos_660976240-stock-photo-beautiful-prom-dresses-hanging-boutique.jpg'
    },
    {
      'title': 'Home & Furniture',
      'image': 'https://png.pngtree.com/thumb_back/fh260/background/20230714/pngtree-d-render-of-furniture-store-on-white-background-with-square-space-image_3874614.jpg'
    },
    {
      'title': 'Health & Beauty',
      'image': 'https://www.bunburycentral.com.au/wp-content/uploads/2018/11/BeautyShop.jpg'
    },
    {
      'title': 'Books & Stationery',
      'image': 'https://t3.ftcdn.net/jpg/06/22/02/68/360_F_622026865_d2peVxLJABynkj74e3Q6mTvxrBaiMl1h.jpg'
    },
    {
      'title': 'Sports & Outdoors',
      'image': 'https://t4.ftcdn.net/jpg/06/09/10/81/360_F_609108111_rbRMlgGe8j1Npnfo7vd3IzLKgH7sRB3b.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _bloc = StoreCategoryBloc(categoryRepo: context.read<ShopCategoryRepository>());
    _bloc.add(FetchStore(
      category: widget.category,
      city: widget.location.toLowerCase(),
    ));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },

            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          ),
          title: Text(
            categories[mainIndex]['title']!,
            style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: BlocConsumer<StoreCategoryBloc, StoreCategoryState>(
          listener: (context, state) {
            if (state.formStatus is DataFetchFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to fetch shops'), behavior: SnackBarBehavior.floating, backgroundColor: Colors.red),
              );
            } else if (state.stores == null || state.stores!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No shops available'), behavior: SnackBarBehavior.floating, backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state.formStatus is DataFetchLoading) {
              return const LoadingScreen();
            } else {
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(categories[mainIndex]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(color: Colors.black.withOpacity(0.5)),
                      ),
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      ),
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
                          SizedBox(height: 20),
                          Text(
                            "${state.stores!.length} ${categories[mainIndex]['title']!} found in & around ${widget.location}",
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.stores!.length,
                              itemBuilder: (context, index) {
                                final shop = state.stores![index];
                                return MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => context.push('/product/${shop.shopId}'),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: Card(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              shop.shopImageLink,
                                              width: double.infinity,
                                              height: 170,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: double.infinity,
                                                  height: 170,
                                                  color: Colors.grey[300],
                                                  alignment: Alignment.center,
                                                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(12),
                                                  bottomRight: Radius.circular(12),
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [Colors.black, Colors.transparent],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 10,
                                            right: 10,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      shop.shopName.toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text('Rating: ', style: TextStyle(fontSize: 15, color: Colors.white)),
                                                        for (int i = 0; i < int.parse(shop.rating); i++)
                                                          const Icon(Icons.star, color: Colors.orange, size: 12),
                                                        for (int i = 0; i < 5 - int.parse(shop.rating); i++)
                                                          const Icon(Icons.star_border, color: Colors.orange, size: 10),
                                                        Text(
                                                          ' (${shop.rating})',
                                                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${shop.address.address}, ${shop.address.city}, ${shop.phone}',
                                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
            }
          },
        ),
      ),
    );
  }
}
