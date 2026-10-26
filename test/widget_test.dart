import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardsaathi/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('CardSaathi App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CardSaathiApp());
    await tester.pumpAndSettle();

    expect(find.text('CardSaathi'), findsOneWidget);
  });
}
