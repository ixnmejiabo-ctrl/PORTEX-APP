import 'package:flutter_test/flutter_test.dart';

import 'package:portex/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PortexApp());

    // Verify that app loads
    expect(find.text('¡Bienvenido a PORTEX!'), findsOneWidget);
  });
}
