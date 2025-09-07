import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/form_bloc/data_fetch_status.dart';
import '../../bloc/store_category_bloc/store_category_bloc.dart';
import '../../bloc/store_category_bloc/store_category_event.dart';
import '../../bloc/store_category_bloc/store_category_state.dart';
import '../../data/repositories/store_category_repository.dart';
import '../widgets/loading_screen.dart';

class CataegoryScreen extends StatefulWidget {
  final String location;

  const CataegoryScreen({super.key, required this.location});

  @override
  State<CataegoryScreen> createState() => _CataegoryScreenState();
}

class _CataegoryScreenState extends State<CataegoryScreen> {
  late StoreCategoryBloc _bloc;



  @override
  void initState() {
    super.initState();
    _bloc = StoreCategoryBloc(categoryRepo: context.read<ShopCategoryRepository>());
    _bloc.add(FetchStore(
      category:'all',
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
            'Stores',
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://s3.india.com/wp-content/uploads/2024/08/vellore-handicraft.jpg##image/jpg'),
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
                            "${state.stores!.length} shops found in & around ${widget.location}",
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
