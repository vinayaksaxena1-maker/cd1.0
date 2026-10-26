import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardsaathi/main.dart';
import 'package:cardsaathi/core/localization/locale_controller.dart';
import 'package:cardsaathi/core/routing/app_router.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Declarative Routing & Navigation Tests', () {
    setUp(() {
      AppRouter.router.go('/');
    });

    testWidgets('App launches with Home Dashboard on initial route', (tester) async {
      localeController.setLocale(const Locale('en'));
      await tester.pumpWidget(const CardSaathiApp());
      await tester.pumpAndSettle();

      // Verify Home Screen elements
      expect(find.text('CardSaathi'), findsOneWidget);
      expect(find.text('Scan Visiting Card'), findsOneWidget);
      expect(find.text('Quick Actions'), findsNothing);

      // Verify 4 Bottom Navigation Bar Destinations (Cards & Reminders also appear in quick stats)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Cards'), findsNWidgets(2));
      expect(find.text('Reminders'), findsNWidgets(2));
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Tapping bottom navigation tabs switches branches', (tester) async {
      localeController.setLocale(const Locale('en'));
      await tester.pumpWidget(const CardSaathiApp());
      await tester.pumpAndSettle();

      // Tap "Cards" tab
      await tester.tap(find.byIcon(Icons.contact_phone_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      // Tap "Reminders" tab
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Tab, 'Today'), findsOneWidget);

      // Tap "Profile" tab
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('My Digital Card (vCard)'), findsOneWidget);
    });

    testWidgets('Bilingual Language Switch updates UI dynamically', (tester) async {
      localeController.setLocale(const Locale('en'));
      await tester.pumpWidget(const CardSaathiApp());
      await tester.pumpAndSettle();

      expect(find.text('Scan Visiting Card'), findsOneWidget);

      // Tap language toggle chip
      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();

      // Verify UI updated to Hindi
      expect(find.text('विज़िटिंग कार्ड स्कैन करें'), findsOneWidget);
      expect(find.text('कार्डसाथी'), findsOneWidget);
    });
  });
}
