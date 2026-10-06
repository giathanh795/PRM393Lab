import 'package:flutter/material.dart';
import 'screens/optimized_task_screen.dart';

void main() {
  runApp(const Lab12App());
}

class Lab12App extends StatelessWidget {
  const Lab12App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 12 - Performance Optimization & Deployment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const OptimizedTaskScreen(),
    );
  }
}
