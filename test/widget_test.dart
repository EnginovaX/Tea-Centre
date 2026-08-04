import 'package:flutter_test/flutter_test.dart';
import 'package:tea_centre/main.dart';

void main() {
  testWidgets('App landing/login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for the route routing to finish
    await tester.pumpAndSettle();

    // Verify that the login screen is displayed initially.
    expect(find.text('Customer Login Screen'), findsOneWidget);
  });
}
