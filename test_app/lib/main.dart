import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DawiniApp());
}

class DawiniApp extends StatelessWidget {
  const DawiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dawini',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Application du thème global
      home: const SplashScreen(),
    );
  }
}