import 'package:flutter_test/flutter_test.dart';
import 'package:vidangestp_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VidangeSTPApp());
    expect(find.text('Saint-Pacôme 2026'), findsOneWidget);
  });
}
