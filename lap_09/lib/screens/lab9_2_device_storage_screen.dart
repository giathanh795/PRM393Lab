import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/local_storage_service.dart';

class Lab92DeviceStorageScreen extends StatefulWidget {
  const Lab92DeviceStorageScreen({super.key});

  @override
  State<Lab92DeviceStorageScreen> createState() => _Lab92DeviceStorageScreenState();
}

class _Lab92DeviceStorageScreenState extends State<Lab92DeviceStorageScreen> {
  static const String _fileName = 'tasks_storage.json';
  final List<TaskItem> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasksFromStorage();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  /// Lab 9.2: Read existing JSON file from application storage
  Future<void> _loadTasksFromStorage() async {
    setState(() => _isLoading = true);
    final data = await LocalStorageService.readJson(_fileName);
    setState(() {
      _tasks.clear();
      _tasks.addAll(
        data.map((item) => TaskItem.fromJson(item as Map<String, dynamic>)),
      );
      _isLoading = false;
    });
  }

  /// Lab 9.2: Save updated JSON back to storage
  Future<void> _saveTasksToStorage({bool showNotice = true}) async {
    final jsonList = _tasks.map((t) => t.toJson()).toList();
    await LocalStorageService.writeJson(_fileName, jsonList);
    if (showNotice && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully persisted tasks to JSON file on device!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      _tasks.insert(
        0,
        TaskItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
        ),
      );
      _taskController.clear();
    });

    _saveTasksToStorage(showNotice: true);
  }

  void _toggleTask(TaskItem task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    _saveTasksToStorage(showNotice: false);
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasksToStorage(showNotice: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Lab 9.2 - Device Storage JSON'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Force Save JSON',
            onPressed: () => _saveTasksToStorage(showNotice: true),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload from Disk',
            onPressed: _loadTasksFromStorage,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : Column(
              children: [
                // Info banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.indigo.withValues(alpha: 0.08),
                  child: Row(
                    children: [
                      const Icon(Icons.sd_card, color: Colors.indigo),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Persisting to "$_fileName" in Application Documents Directory via path_provider.',
                          style: const TextStyle(fontSize: 12, color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),

                // Input bar to add item
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            hintText: 'Enter new task...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => _addTask(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _addTask,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Task list
                Expanded(
                  child: _tasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.task_alt, size: 60, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'No tasks stored yet.\nAdd a task to write to local JSON.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  activeColor: Colors.indigo,
                                  onChanged: (_) => _toggleTask(task),
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? Colors.grey
                                        : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => _deleteTask(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
