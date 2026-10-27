import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardsaathi/core/constants/app_constants.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/widgets/profile/developer_info_footer.dart';
import 'package:cardsaathi/presentation/widgets/profile/google_play_policy_modal.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('hi'),
    ],
    locale: const Locale('en'),
    home: Scaffold(body: child),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppConstants & Developer Identity Tests', () {
    test('AppConstants contains Innovix Solutions, version 1.0.0 and Google Play policy URL', () {
      expect(AppConstants.developerName, equals('Innovix Solutions'));
      expect(AppConstants.appVersion, equals('1.0.0'));
      expect(AppConstants.buildNumber, equals('1'));
      expect(AppConstants.madeInIndiaForWorld, contains('Made with ❤️ in India, for the World'));
      expect(AppConstants.madeInIndiaForWorldHi, contains('भारत में निर्मित, पूरी दुनिया के लिए'));
      expect(AppConstants.googlePlayPolicyUrl, equals('https://play.google/developer-content-policy/'));
      expect(AppConstants.developerEmail, equals('support@innovixsolutions.com'));
    });
  });

  group('DeveloperInfoFooter Widget Tests', () {
    testWidgets('Renders Made in India badge, Innovix Solutions, and Policy link', (tester) async {
      await tester.pumpWidget(createTestApp(const DeveloperInfoFooter()));
      await tester.pumpAndSettle();

      // Verify Made in India badge
      expect(find.textContaining('Made with ❤️ in India, for the World'), findsOneWidget);

      // Verify Innovix Solutions and Version
      expect(find.textContaining('Developed by Innovix Solutions'), findsOneWidget);
      expect(find.textContaining('CardSaathi v1.0.0 (Build 1)'), findsOneWidget);

      // Verify Google Play policy compliance link
      expect(find.text('Google Play Developer Content Policy Compliant'), findsOneWidget);
    });
  });

  group('GooglePlayPolicyModal Widget Tests', () {
    testWidgets('Renders Developer Entity, Policy sections, and Official Policy action button', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => GooglePlayPolicyModal.show(context),
                child: const Text('Show Policy'),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Modal
      await tester.tap(find.text('Show Policy'));
      await tester.pumpAndSettle();

      // Verify Developer Entity & Mission
      expect(find.text('Developer Entity & Mission'), findsOneWidget);
      expect(find.textContaining('Innovix Solutions'), findsAtLeastNWidgets(1));

      // Verify Google Play Policy sections (scrolling through ListView)
      expect(find.text('1. Developer Content Policy Adherence'), findsOneWidget);
      expect(find.text('2. User Data Safety & Non-Harvesting'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('3. Minimum Necessary Permissions'),
        100.0,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('3. Minimum Necessary Permissions'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Open Google Play Content Policy'),
        200.0,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Open Google Play Content Policy'), findsOneWidget);
    });
  });
}
