import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/main.dart';
import 'package:lap_11/models/task.dart';
import 'package:lap_11/repositories/task_repository.dart';

void main() {
  group('Lab 11.3 - Navigation Testing (TaskList -> TaskDetail)', () {
    testWidgets('Tapping a task navigates to TaskDetailScreen with detailTitleField',
        (tester) async {
      // Seed repository with at least one task
      final repository = TaskRepository();
      repository.addTask(
        Task(
          id: 'test-nav-1',
          title: 'Learn Navigation Testing',
          description: 'Initial description',
        ),
      );

      // Pump TasklyApp
      await tester.pumpWidget(TasklyApp(repository: repository));

      // Verify task exists in the list
      expect(find.text('Learn Navigation Testing'), findsOneWidget);

      // Tap on the task
      await tester.tap(find.text('Learn Navigation Testing'));

      // Wait for navigation animation to settle
      await tester.pumpAndSettle();

      // Validate AppBar title: "Task Detail"
      expect(find.text('Task Detail'), findsOneWidget);

      // Validate TextField with Key: detailTitleField
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);

      // Validate text inside field matches task title
      final textField = tester.widget<TextField>(find.byKey(const Key('detailTitleField')));
      expect(textField.controller?.text, 'Learn Navigation Testing');
    });
  });
}
