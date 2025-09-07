import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mib/screens/profile_screen.dart';
import '../bloc/add_to_cart/add_to_cart_bloc.dart';
import '../bloc/add_to_cart/add_to_cart_state.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../data/repositories/profile_repository.dart';
import 'cart_page.dart';
import 'shop_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? uid;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _loadUid();
  }

  Future<void> _loadUid() async {
    String? storedUid = await _storage.read(key: "uid");
    setState(() {
      uid = storedUid;
    });
  }

  List<Widget> get _screen {
    if (uid == null) {
      return [const Center(child: CircularProgressIndicator())];
    } else {
      return [
        const HomeScreen(),
        CataegoryScreen(location: 'coimbatore',),
        const CartPage(),
        BlocProvider(
          create: (context) => ProfileBloc(
            repository: context.read<ProfileRepository>(),
          )..add(LoadUserProfileAndShops()),
          child: const ProfilePage(),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen.length > index ? _screen[index] : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 20,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                int cartItemCount = 0;
                if (state is CartLoaded) {
                  cartItemCount = state.items.length;
                }
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartItemCount > 0)
                      Positioned(
                        right: -6,
                        top: -10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
