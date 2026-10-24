import 'package:flutter_test/flutter_test.dart';
import 'package:wildlife_sanctuary_guide/main.dart';

void main() {
  testWidgets('Wildlife guide displays navigation tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WildlifeGuideApp());

    expect(find.text('Wild India'), findsOneWidget);
    expect(find.text('Sanctuaries'), findsWidgets);
    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Conservation'), findsOneWidget);
  });
}
