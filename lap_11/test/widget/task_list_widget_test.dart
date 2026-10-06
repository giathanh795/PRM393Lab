import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/main.dart';
import 'package:lap_11/repositories/task_repository.dart';

void main() {
  group('Lab 11.2 - TaskList Widget Tests', () {
    testWidgets('Empty State displays "No tasks yet. Add one!"', (tester) async {
      final repository = TaskRepository();

      await tester.pumpWidget(TasklyApp(repository: repository));

      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates', (tester) async {
      final repository = TaskRepository();

      await tester.pumpWidget(TasklyApp(repository: repository));

      // Enter text into add task field
      final textFieldFinder = find.byKey(const Key('addTaskField'));
      await tester.enterText(textFieldFinder, 'Complete Lab 11');

      // Tap Add button
      final addButtonFinder = find.byKey(const Key('addTaskButton'));
      await tester.tap(addButtonFinder);

      // Rebuild widget tree
      await tester.pump();

      // Verify task is now visible and empty message disappeared
      expect(find.text('Complete Lab 11'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible', (tester) async {
      final repository = TaskRepository();

      await tester.pumpWidget(TasklyApp(repository: repository));

      final textFieldFinder = find.byKey(const Key('addTaskField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      // Add first task
      await tester.enterText(textFieldFinder, 'First Task');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Add second task
      await tester.enterText(textFieldFinder, 'Second Task');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Verify both tasks visible
      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('Second Task'), findsOneWidget);
    });
  });
}
