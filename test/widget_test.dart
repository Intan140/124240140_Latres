import 'package:flutter_test/flutter_test.dart';
import 'package:latihan_responsi/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RickAndMortyApp());
  });
}