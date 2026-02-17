import 'package:flutter/material.dart';
import 'package:explorasyon_peyi/pages/splash_screen.dart';
import 'package:explorasyon_peyi/pages/home_page.dart';
import 'package:explorasyon_peyi/pages/auth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Explore Peyi',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/auth': (context) => const AuthPage(),
      },
    );
  }
}
