import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/widgets/voice_memo/voice_memo_widget.dart';

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

  group('VoiceMemoWidget 3-State Tests', () {
    testWidgets('Renders idle state with record action and subtitle', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          VoiceMemoWidget(
            onMemoChanged: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Record 10s Voice Memo'), findsOneWidget);
      expect(find.text('10-second quick context audio memo'), findsOneWidget);
      expect(find.text('Record'), findsOneWidget);
      expect(find.byIcon(Icons.mic_none_outlined), findsOneWidget);
    });

    testWidgets('Tapping Record triggers Google Play 2026 Microphone Disclosure Dialog', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          VoiceMemoWidget(
            onMemoChanged: (_) {},
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Record'));
      await tester.pumpAndSettle();

      // Verify prominent disclosure dialog
      expect(find.text('Record 10s Voice Memo'), findsNWidgets(2)); // Tile + Dialog title
      expect(find.text('Agree & Continue'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Cancel dismisses dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('Renders saved state with playback controls and delete option', (tester) async {
      String? updatedPath = 'initial';

      await tester.pumpWidget(
        createTestApp(
          VoiceMemoWidget(
            initialMemoPath: '/data/user/0/com.cardsaathi.app/memo_123.m4a',
            onMemoChanged: (p) => updatedPath = p,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Voice memo attached'), findsOneWidget);
      expect(find.text('10s offline audio note'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      // Tap Delete
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      expect(updatedPath, isNull);
    });
  });
}
