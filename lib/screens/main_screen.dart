import 'package:flutter/material.dart';
import 'package:vilmart_android/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int index=0;
  final List<Widget> _screen=[
    HomeScreen(),
    Center(child: Text("WishList"),),
    Center(child: Text("Cart"),),
    Center(child: Text("Profile"),),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation:20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        onTap: (Value){
          setState(() {
            index=Value;
          });
        },
      ),
    );
  }
}
