import 'package:flutter/material.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  final repository = TaskRepository();
  runApp(TasklyApp(repository: repository));
}

class TasklyApp extends StatelessWidget {
  final TaskRepository repository;

  const TasklyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly - Lab 11 Testing App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: TaskListScreen(repository: repository),
    );
  }
}
