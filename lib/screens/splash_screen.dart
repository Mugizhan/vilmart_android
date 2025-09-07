import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    try {
      final String? uid = await _storage.read(key: 'uid');
      if (context.mounted) {
        if (uid != null && uid.isNotEmpty) {
          context.go('/home');
        } else {
          context.go('/');
        }
      }
    } catch (e) {
      debugPrint('Error reading from secure storage: $e');
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        'assets/images/icon.png',
        width: 400,
        height: 400,
      ),
      splashIconSize: 450,
      nextScreen: const SizedBox.shrink(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000,
      backgroundColor: Colors.red,
    );
  }
}
