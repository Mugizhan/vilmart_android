import 'package:go_router/go_router.dart';
import 'package:vilmart_android/screens/add_store.dart';
import 'package:vilmart_android/screens/home_screen.dart';
import 'package:vilmart_android/screens/login_screen.dart';
import 'package:vilmart_android/screens/main_screen.dart';

class AppRouter{
 static GoRouter router=GoRouter(
     initialLocation: '/',
     routes: [
       GoRoute(
         name: 'login',
           path: '/',
       builder: (context,state)=>LoginScreen()
       ),
       GoRoute(
           name: 'home',
           path: '/home',
           builder: (context,state)=>MainScreen()
       ),
       GoRoute(
           name: 'addstore',
           path: '/store',
           builder: (context,state)=>AddStore()
       ),

 ]);
}