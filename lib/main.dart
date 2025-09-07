import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mib/router/router_config.dart';
import 'bloc/add_to_cart/add_to_cart_bloc.dart';
import 'bloc/product_category_bloc/store_category_bloc.dart';

import 'data/repositories/add_to_cart_repository.dart';
import 'data/repositories/home_repository.dart';
import 'data/repositories/login_repositories.dart';
import 'data/repositories/product_add_repository.dart';
import 'data/repositories/product_category_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/register_repository.dart';
import 'data/repositories/store_add_repository.dart';
import 'data/repositories/store_category_repository.dart';
import 'data/services/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final router = await createRouter();

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoginRepository>(create: (_) => LoginRepository()),
        RepositoryProvider<RegisterRepository>(create: (_) => RegisterRepository()),
        RepositoryProvider<HomeRepository>(create: (_) => HomeRepository()),
        RepositoryProvider<StoreAddRepository>(create: (_) => StoreAddRepository()),
        RepositoryProvider<AddProductRepository>(create: (_) => AddProductRepository()),
        RepositoryProvider<ShopCategoryRepository>(create: (_) => ShopCategoryRepository()),
        RepositoryProvider<ProductCategoryRepository>(create: (_) => ProductCategoryRepository()),
        RepositoryProvider<AddToCartRepository>(create: (_) => AddToCartRepository()),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepository(ProfileService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductCategoryBloc>(
            create: (context) => ProductCategoryBloc(
              categoryRepo: context.read<ProductCategoryRepository>(),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              cartService: context.read<AddToCartRepository>(),
            ),
          ),
          // Add other Blocs if needed
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'VilMart',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
        ),
      ),
    );
  }
}
