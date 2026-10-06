import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/models/task.dart';

void main() {
  group('Lab 11.1 - Task Model Unit Tests', () {
    test('Default completed value should be false', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy groceries');

      // Assert
      expect(task.isCompleted, false);
      expect(task.title, 'Buy groceries');
      expect(task.description, '');
    });

    test('toggle() switches isCompleted from false to true and back to false', () {
      // Arrange
      final task = Task(id: '2', title: 'Read Flutter docs');

      // Act 1
      task.toggle();

      // Assert 1
      expect(task.isCompleted, true);

      // Act 2
      task.toggle();

      // Assert 2
      expect(task.isCompleted, false);
    });

    test('copyWith() returns updated clone without mutating original', () {
      // Arrange
      final original = Task(id: '3', title: 'Workout', isCompleted: false);

      // Act
      final updated = original.copyWith(title: 'Gym Workout', isCompleted: true);

      // Assert
      expect(updated.id, '3');
      expect(updated.title, 'Gym Workout');
      expect(updated.isCompleted, true);
      expect(original.title, 'Workout');
    });
  });
}
