import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width:MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ecommerce.gif"),
              fit: BoxFit.cover,
            ),
          ),
        )
    );
  }
}
