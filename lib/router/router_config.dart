import 'package:go_router/go_router.dart';
import 'package:vilmart_android/screens/home_screen.dart';
import 'package:vilmart_android/screens/login_screen.dart';

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
           builder: (context,state)=>HomeScreen()
       ),

 ]);
}