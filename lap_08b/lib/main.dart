import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(const Lab8BApp());
}

class Lab8BApp extends StatelessWidget {
  const Lab8BApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8B - Weather Companion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
