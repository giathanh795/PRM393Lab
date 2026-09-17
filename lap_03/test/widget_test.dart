import 'package:flutter_test/flutter_test.dart';
import 'package:lap_03/main.dart';

void main() {
  testWidgets('Lab 3 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab3App());
    expect(find.text('PRM393 - Lab 3: Advanced Dart'), findsOneWidget);
  });
}
