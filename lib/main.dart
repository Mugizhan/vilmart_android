import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilmart_android/data/repositories/home_repository.dart';
import 'package:vilmart_android/data/repositories/login_repositories.dart';
import 'package:vilmart_android/router/router_config.dart';


void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<LoginRepository>(create: (context)=>LoginRepository()),
      RepositoryProvider<HomeRepository>(create: (context)=>HomeRepository())
    ],
        child:  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    ));
  }
}
