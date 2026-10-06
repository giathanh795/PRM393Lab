import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/models/task.dart';
import 'package:lap_11/repositories/task_repository.dart';

void main() {
  group('Lab 11.1 - TaskRepository Unit Tests (AAA Pattern)', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() adds a new task to repository list', () {
      // Arrange
      final task = Task(id: '1', title: 'Prepare presentation');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Prepare presentation');
    });

    test('deleteTask() removes existing task from repository', () {
      // Arrange
      final task1 = Task(id: '1', title: 'Task 1');
      final task2 = Task(id: '2', title: 'Task 2');
      repository.addTask(task1);
      repository.addTask(task2);

      // Act
      final result = repository.deleteTask('1');

      // Assert
      expect(result, true);
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.id, '2');
    });

    test('updateTask() updates task title and description', () {
      // Arrange
      final task = Task(id: '1', title: 'Old Title', description: 'Old Desc');
      repository.addTask(task);

      // Act
      final updated = Task(id: '1', title: 'New Title', description: 'New Desc');
      final success = repository.updateTask(updated);

      // Assert
      expect(success, true);
      expect(repository.tasks.first.title, 'New Title');
      expect(repository.tasks.first.description, 'New Desc');
    });

    test('toggleTask() toggles completion status in repository', () {
      // Arrange
      final task = Task(id: '1', title: 'Study Dart', isCompleted: false);
      repository.addTask(task);

      // Act
      repository.toggleTask('1');

      // Assert
      expect(repository.tasks.first.isCompleted, true);
    });
  });
}
