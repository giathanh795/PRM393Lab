import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'optimization_report_screen.dart';

class OptimizedTaskScreen extends StatefulWidget {
  const OptimizedTaskScreen({super.key});

  @override
  State<OptimizedTaskScreen> createState() => _OptimizedTaskScreenState();
}

class _OptimizedTaskScreenState extends State<OptimizedTaskScreen> {
  final List<Task> _tasks = [
    const Task(id: '1', title: 'Code refactoring & clean architecture', isCompleted: true),
    const Task(id: '2', title: 'Widget tree breakdown with const constructors', isCompleted: true),
    const Task(id: '3', title: 'Asset precaching implementation', isCompleted: false),
    const Task(id: '4', title: 'Profile mode FPS monitoring & trace analysis', isCompleted: false),
  ];

  final TextEditingController _controller = TextEditingController();
  int _screenRebuildCount = 0;
  bool _isImagePrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Exercise 12.2: Precache asset image in didChangeDependencies to prevent frame drops
    if (!_isImagePrecached) {
      precacheImage(const AssetImage('assets/images/task_icon.png'), context);
      _isImagePrecached = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _tasks.insert(
        0,
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
        ),
      );
      _controller.clear();
    });
  }

  void _toggleTask(int index, bool? val) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isCompleted: val ?? false);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenRebuildCount++;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Taskly - Lab 12 Optimized'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'View Optimization Report',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OptimizationReportScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card with Precached Asset Image & Rebuild Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.withValues(alpha: 0.08),
            child: Row(
              children: [
                // Exercise 12.2: Optimized 128x128 precached asset image
                Image.asset(
                  'assets/images/task_icon.png',
                  width: 52,
                  height: 52,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.speed,
                    size: 52,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Performance Optimization HUD',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total Screen Rebuilds: $_screenRebuildCount',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const Text(
                        'Image Precached: Yes | Extracted TaskTile: Yes',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OptimizationReportScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.deepPurple,
                  ),
                  child: const Text('Report'),
                ),
              ],
            ),
          ),

          // Add Task Input Row
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter optimized task...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // Task List using extracted TaskTile (Exercise 12.1)
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      // Exercise 12.1: Keyed TaskTile prevents unnecessary widget reallocation
                      return TaskTile(
                        key: ValueKey<String>(task.id),
                        task: task,
                        onToggle: (val) => _toggleTask(index, val),
                        onDelete: () => _deleteTask(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
