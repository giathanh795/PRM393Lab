import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const Lab5App());
}

class Lab5App extends StatelessWidget {
  const Lab5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5 - Movie Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Khởi động từ HomeScreen
      home: const HomeScreen(),
    );
  }
}
