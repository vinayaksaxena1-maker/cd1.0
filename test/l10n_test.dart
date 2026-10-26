import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardsaathi/core/localization/locale_controller.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';

void main() {
  group('Bilingual Localization Verification (EN & HI)', () {
    test('LocaleController toggles locale correctly', () {
      final controller = LocaleController();
      expect(controller.locale, const Locale('en'));
      expect(controller.isHindi, false);

      controller.toggleLocale();
      expect(controller.locale, const Locale('hi'));
      expect(controller.isHindi, true);

      controller.setLocale(const Locale('en'));
      expect(controller.locale, const Locale('en'));
    });

    testWidgets('AppLocalizations loads English strings properly', (tester) async {
      late AppLocalizations localizations;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              localizations = AppLocalizations.of(context)!;
              return Text(localizations.appTitle);
            },
          ),
        ),
      );

      expect(localizations.appTitle, 'CardSaathi');
      expect(localizations.navHome, 'Home');
      expect(localizations.scanCardButton, 'Scan Visiting Card');
      expect(find.text('CardSaathi'), findsOneWidget);
    });

    testWidgets('AppLocalizations loads Hindi strings properly', (tester) async {
      late AppLocalizations localizations;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('hi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              localizations = AppLocalizations.of(context)!;
              return Text(localizations.appTitle);
            },
          ),
        ),
      );

      expect(localizations.appTitle, 'कार्डसाथी');
      expect(localizations.navHome, 'होम');
      expect(localizations.scanCardButton, 'विज़िटिंग कार्ड स्कैन करें');
      expect(find.text('कार्डसाथी'), findsOneWidget);
    });
  });
}
