
import 'package:flutter_test/flutter_test.dart';
import 'package:wildlife_sanctuary_guide/main.dart';

void main() {
  testWidgets('Wildlife Sanctuary Guide loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WildlifeApp());

    expect(find.text('Wildlife Sanctuary Guide'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Wildlife'), findsOneWidget);
    expect(find.text('Places'), findsOneWidget);
    expect(find.text('Protect'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
