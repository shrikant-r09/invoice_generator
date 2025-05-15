import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart'; // Ensure correct import

void main() {
  testWidgets('MyApp displays hello message', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Hello, Flutter!'), findsOneWidget);
    expect(find.text('Not Found'), findsNothing);
  });
}