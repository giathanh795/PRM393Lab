import '../models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Add a new task to repository
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Delete a task by id
  bool deleteTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks.removeAt(index);
      return true;
    }
    return false;
  }

  /// Update existing task fields
  bool updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      return true;
    }
    return false;
  }

  /// Toggle task completion
  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].toggle();
    }
  }

  /// Clear all tasks
  void clear() {
    _tasks.clear();
  }
}
