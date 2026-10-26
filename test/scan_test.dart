import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/widgets/scan/card_guide_overlay.dart';
import 'package:cardsaathi/presentation/widgets/scan/camera_disclosure_dialog.dart';
import 'package:cardsaathi/presentation/screens/scan/scan_screen.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: child),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('CardGuideOverlay & Stitch Framing Tests', () {
    testWidgets('Renders 3:2 visiting card frame with status and brackets', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 400,
            height: 800,
            child: CardGuideOverlay(
              statusText: 'Align visiting card in frame',
              isFrontSide: true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Align visiting card in frame'), findsOneWidget);
      expect(find.text('FRONT SIDE'), findsOneWidget);
    });

    testWidgets('Toggles to BACK SIDE guidance correctly', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 400,
            height: 800,
            child: CardGuideOverlay(
              statusText: 'Align back of card',
              isFrontSide: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Align back of card'), findsOneWidget);
      expect(find.text('BACK SIDE'), findsOneWidget);
    });
  });

  group('Google Play 2026 Prominent Camera Disclosure Dialog Tests', () {
    testWidgets('Displays prominent privacy text and handles actions', (tester) async {
      bool agreed = false;
      bool usedGallery = false;

      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => CameraDisclosureDialog.show(
                context,
                onAgree: () => agreed = true,
                onUseGallery: () => usedGallery = true,
              ),
              child: const Text('Open Disclosure'),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Disclosure'));
      await tester.pumpAndSettle();

      // Verify prominent disclosure elements
      expect(find.text('Camera Permission Disclosure'), findsOneWidget);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.text('Agree & Continue'), findsOneWidget);
      expect(find.text('Use Gallery Only'), findsOneWidget);

      // Tap Agree
      await tester.tap(find.text('Agree & Continue'));
      await tester.pumpAndSettle();
      expect(agreed, isTrue);
      expect(usedGallery, isFalse);
    });
  });

  group('ScanScreen UI Layout Tests', () {
    testWidgets('Renders camera controls, side switcher, and gallery picker', (tester) async {
      await tester.pumpWidget(createTestApp(const ScanScreen()));
      await tester.pump(const Duration(milliseconds: 200));

      // Verify top actions
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Front Side'), findsOneWidget);
      expect(find.text('Back Side'), findsOneWidget);

      // Verify bottom dock
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      expect(find.text('Scans stored 100% locally on your phone. Safe & private.'), findsOneWidget);
    });
  });
}
