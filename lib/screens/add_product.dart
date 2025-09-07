  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import 'package:go_router/go_router.dart';
  import '../bloc/product_register_bloc/product_register_bloc.dart';
  import '../bloc/product_register_bloc/product_register_event.dart';
  import '../bloc/product_register_bloc/product_register_state.dart';
import '../data/repositories/product_add_repository.dart';

  class AddProduct extends StatefulWidget {
    const AddProduct({super.key});
    @override
    State<AddProduct> createState() => _AddProductState();
  }

  class _AddProductState extends State<AddProduct> {
    @override
    final _storage = const FlutterSecureStorage();
    String? shopId;

    @override
    void initState() {
      super.initState();
      _loadShopId();
    }

    Future<void> _loadShopId() async {
      final storedShopId = await _storage.read(key: "shopId");
      setState(() {
        shopId = storedShopId ?? "";
      });
    }

    @override
    Widget build(BuildContext context) {
      // Show loading spinner while fetching shopId
      if (shopId == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return BlocProvider(
        create: (_) => CatalogBloc(
          addProductRepo: context.read<AddProductRepository>(),
          shopId: shopId!,
        ),
  child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.redAccent[200],
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.store, color: Colors.white),
            ),
            title: const Text(
              'Create Your Store',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
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
                        ExcelFileGenerator(),
                        StoreConfirm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
);
    }
  }



  class ExcelFileGenerator extends StatefulWidget {
    const ExcelFileGenerator({super.key});

    @override
    State<ExcelFileGenerator> createState() => _ExcelFileGeneratorState();
  }

  class _ExcelFileGeneratorState extends State<ExcelFileGenerator> {
    final _storage = const FlutterSecureStorage();
    String? shopId;

    @override
    void initState() {
      super.initState();
      _loadShopId();
    }

    Future<void> _loadShopId() async {
      final storedShopId = await _storage.read(key: "shopId");
      setState(() {
        shopId = storedShopId ?? "";
      });
    }

    @override
    Widget build(BuildContext context) {
      if (shopId == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return BlocProvider(
        create: (_) => CatalogBloc(
          addProductRepo: context.read<AddProductRepository>(),
          shopId: shopId!,
        ),
        child: Scaffold(
          body: BlocConsumer<CatalogBloc, CatalogState>(
            listener: (context, state) {
              if (state is CatalogFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)), // use state.message instead of state.error for consistency
                );
              } else if (state is CatalogDownloadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sample file downloaded!")),
                );
              } else if (state is CatalogUploadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File uploaded Successfully!")),
                );
              }
            },
            builder: (context, state) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Upload Catalog'),
                        Tab(text: 'Document Verification'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Bulk Upload Catalog',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () => context.read<CatalogBloc>().add(UploadExcelFile()),
                                          icon: const Icon(Icons.file_upload_outlined),
                                          label: const Text("UPLOAD EXCEL FILE"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.info_outline, size: 18, color: Colors.grey),
                                          SizedBox(width: 10),
                                          Text(
                                            'Uploading catalog file will not replace the old catalog',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: Colors.grey[100],
                                    padding: const EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Please download the sample catalog file, add items, price etc & upload it back to create your catalog',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => context.read<CatalogBloc>().add(DownloadSampleExcel()),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.black,
                                            elevation: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "Download Sample Catalog File",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Icon(Icons.chevron_right, size: 25),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const ProductPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }


  class ProductPage extends StatefulWidget {
    const ProductPage({super.key});

    @override
    State<ProductPage> createState() => _ProductPageState();
  }

  class _ProductPageState extends State<ProductPage> {
    @override
    Widget build(BuildContext context) {
      return BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogUploadSuccess) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(20),
                      child: const Text('Product preview',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey))),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            child: Row(
                              children: [
                                Builder(
                                  builder: (context) {
                                    final imageUrl = product.productImages?.trim() ?? '';

                                    return ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft:Radius.circular(10),bottomLeft:Radius.circular(10)),
                                      child: Image.network(imageUrl,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.image_not_supported, size: 50);
                                        },
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(width: 10),
                                // Product Details
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          product.productDescription,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Category: ${product.productCategory}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹${product.price}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              product.availabilityStatus,
                                              style: TextStyle(
                                                color: [
                                                  'in stock',
                                                  'available',
                                                ].contains(product.availabilityStatus.toLowerCase())
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Text(
                                              'Rating:',
                                              style:  TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            // Display filled stars
                                            for (int i = 0; i < product.productRating.toInt(); i++)
                                              const Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                                size: 14,
                                              ),
                                            // Display half star if there's a fractional rating
                                            // Display empty stars
                                            for (int i = 0; i < (5 - product.productRating.toInt() - (product.productRating % 1 != 0 ? 1 : 0)); i++)
                                              const Icon(
                                                Icons.star_border,
                                                color: Colors.orange,
                                                size: 14,
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 5),
                                        Text(
                                          'Warranty: ${product.warranty}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
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
            );
          } else if (state is CatalogLoading) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Text('No Products Uploaded'),
            ),
          );
        },
      );
    }
  }


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
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.red,
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(30)
                  )
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
