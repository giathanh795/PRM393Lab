import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/main.dart';
import 'package:lap_11/repositories/task_repository.dart';

void main() {
  group('Lab 11.4 - Integration Test (Full End-to-End Flow)', () {
    testWidgets('Full Flow: Add -> Open Detail -> Edit -> Save -> Verify in List',
        (tester) async {
      final repository = TaskRepository();

      await tester.pumpWidget(TasklyApp(repository: repository));

      // 1. Add "Original title"
      final addField = find.byKey(const Key('addTaskField'));
      final addButton = find.byKey(const Key('addTaskButton'));

      await tester.enterText(addField, 'Original title');
      await tester.tap(addButton);
      await tester.pump();

      // Verify "Original title" is in list
      expect(find.text('Original title'), findsOneWidget);

      // 2. Tap task to open TaskDetailScreen
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Verify we are on TaskDetailScreen
      expect(find.text('Task Detail'), findsOneWidget);

      // 3. Edit title to "Updated title"
      final detailField = find.byKey(const Key('detailTitleField'));
      await tester.enterText(detailField, 'Updated title');

      // 4. Tap Save Changes button
      final saveButton = find.byKey(const Key('saveTaskButton'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // 5. Verify back on TaskListScreen and updated title appears
      expect(find.text('Task Detail'), findsNothing);
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}
