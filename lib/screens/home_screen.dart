import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilmart_android/bloc/form_bloc/data_fetch_status.dart';
import 'package:vilmart_android/bloc/form_bloc/form_submission_status.dart';
import 'package:vilmart_android/bloc/home_bloc/home_bloc.dart';
import 'package:vilmart_android/widgets/loading_screen.dart';
import '../bloc/home_bloc/home_event.dart';
import '../bloc/home_bloc/home_state.dart';
import '../data/repositories/home_repository.dart';
import '../widgets/bottom_navigation.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> categories = [
    {
      'title': 'Restaurant',
      'image': 'https://as1.ftcdn.net/jpg/05/66/68/36/1000_F_566683667_BeBecGFABNQYkZhquqJxhSj7UOcCY7ZJ.jpg'
    },
    {
      'title': 'Groceries',
      'image': 'https://as2.ftcdn.net/jpg/05/20/72/29/1000_F_520722991_dKI3TA92Yvdhwh3n2OU53oZge9hWLNyg.jpg'
    },
    {
      'title': 'Electronics & Gadgets',
      'image': 'https://cdn3d.iconscout.com/3d/premium/thumb/gadgets-3d-illustration-download-in-png-blend-fbx-gltf-file-formats--devices-game-controller-remote-objects-pack-tools-equipment-illustrations-3408776@0.png'
    },
    {
      'title': 'Fashion & Apparel',
      'image': 'https://png.pngtree.com/png-clipart/20230430/original/pngtree-3d-cosmetic-makeup-set-png-image_9124645.png'
    },
    {
      'title': 'Home & Furniture',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4kpSCBrW89Gb6UOaW8gMd5Bul-AAmWiXNzEyZt_rUpkpv7kSbeUOQuX1QuDWX2PLh0Vw&usqp=CAU'
    },
    {
      'title': 'Health & Beauty',
      'image': 'https://cdn3d.iconscout.com/3d/premium/thumb/medicine-with-pills-3d-icon-download-in-png-blend-fbx-gltf-file-formats--bottle-healthcare-doctor-pack-medical-icons-5889248.png?f=webp'
    },
    {
      'title': 'Toys & Hobbies',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7uZgXKU2KwDoDuEzDVpawS5nb6EPAlrqFljsGePgvMi2vrC616UgMOTiG5Dl4RO17keY&usqp=CAU'
    },
    {
      'title': 'Books & Stationery',
      'image': 'https://static.vecteezy.com/system/resources/previews/013/313/384/non_2x/book-icon-3d-illustration-vector.jpg'
    },
    {
      'title': 'Sports & Outdoors',
      'image': 'https://cdn3d.iconscout.com/3d/premium/thumb/equipamiento-deportivo-6358812-5272652.png'
    },
  ];


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(homeRepository: context.read<HomeRepository>())..add(HomePageLoad()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status is DataFetchFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error")),
            );
          }
          if (state.status is DataFetchSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Product fetched"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status is DataFetchLoading) {
              return const LoadingScreen();
            }

            if (state.status is DataFetchSuccess) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    leading: IconButton(onPressed: (){}, icon: Icon(Icons.grid_view_rounded,size: 30,)),
                    actions: [
                  Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHJhbmRvbSUyMHBlb3BsZXxlbnwwfHwwfHx8MA%3D%3D",
                    ),
                  ),)
                    ],
                  ),
                  body:SingleChildScrollView(
                    child: Container(
                      child: Padding(
                          padding:EdgeInsets.all(20),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Find all Products",style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),),
                          Text("around you.",style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: Icon(Icons.search_outlined),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius:BorderRadius.circular(10)
                                ),
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.tune_rounded)),
                              )
                            ],
                          ),
                            SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(2),
                            width: double.infinity,
                            height: 150, // Adjust height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),

                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/ad.png'
                              ,  fit: BoxFit.cover ),
                          ),
                          SizedBox(height: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    return Container(
                                      width: 80,
                                      margin: EdgeInsets.only(right: 16),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.grey[200],

                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30),
                                              child: Image.network(
                                                category['image']!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            category['title']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text('Top Item',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(5),
                            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: state.productData.length,
                            itemBuilder: (context, index) {
                              final product = state.productData[index];
                              return Card(
                                color: Colors.grey[100],
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        child: Image.network(
                                          product.image,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "₹${product.price}",
                                            style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );

                            },
                          ),

                        ],
                      )
                      ),
                    ),
                  ),

                  bottomNavigationBar: BottomNavigation(),
                );

              }
              return const Center(child: Text("No Data Available"));
            },
          ),
      ),
    );
  }
}
