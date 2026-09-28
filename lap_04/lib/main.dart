import 'package:flutter/material.dart';
import 'exercises/exercise1.dart';
import 'exercises/exercise2.dart';
import 'exercises/exercise3.dart';
import 'exercises/exercise4.dart';
import 'exercises/exercise5.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Lab4HomePage(),
    );
  }
}

class Lab4HomePage extends StatelessWidget {
  const Lab4HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các exercise
    final exercises = [
      {
        'title': 'Exercise 1',
        'subtitle': 'Core Widgets\nText, Image, Icon, Card, ListTile',
        'icon': Icons.widgets,
        'color': Colors.deepPurple,
        'route': const Exercise1CoreWidgets(),
      },
      {
        'title': 'Exercise 2',
        'subtitle': 'Input Widgets\nSlider, Switch, RadioListTile, DatePicker',
        'icon': Icons.tune,
        'color': Colors.teal,
        'route': const Exercise2InputWidgets(),
      },
      {
        'title': 'Exercise 3',
        'subtitle': 'Layout Basics\nColumn, Row, Padding, ListView',
        'icon': Icons.view_column,
        'color': Colors.indigo,
        'route': const Exercise3Layout(),
      },
      {
        'title': 'Exercise 4',
        'subtitle': 'App Structure\nScaffold, AppBar, FAB & ThemeData',
        'icon': Icons.architecture,
        'color': Colors.deepPurple[700]!,
        'route': const Exercise4Scaffold(),
      },
      {
        'title': 'Exercise 5',
        'subtitle': 'Debug & Fix\nCommon UI Errors & Fixes',
        'icon': Icons.bug_report,
        'color': Colors.red[700]!,
        'route': const Exercise5Debug(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PRM393 - Lab 4: Flutter UI Fundamentals'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 3,
              color: Colors.deepPurple[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎓 Lab 4 - Flutter UI Fundamentals',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Nhấn vào từng Exercise để xem kết quả',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Exercise list
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ex['route'] as Widget,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Icon circle
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: (ex['color'] as Color).withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  ex['icon'] as IconData,
                                  color: ex['color'] as Color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Title + subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ex['title'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      ex['subtitle'] as String,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: ex['color'] as Color, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
