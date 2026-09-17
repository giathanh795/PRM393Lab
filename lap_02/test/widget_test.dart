import 'package:flutter_test/flutter_test.dart';
import 'package:lap_02/main.dart';

void main() {
  testWidgets('Lab 2 smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab2App());
    expect(find.text('PRM393 - Lab 2: Dart Essentials'), findsOneWidget);
  });
}
