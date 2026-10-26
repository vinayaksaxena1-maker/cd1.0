import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/services/notification_service.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/meeting_reminder.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/cards/card_detail_screen.dart';
import 'package:cardsaathi/presentation/widgets/cards/card_meetings_section.dart';
import 'package:cardsaathi/presentation/widgets/reminders/alarm_disclosure_dialog.dart';

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
    home: child,
  );
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_m4p2_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    await StorageService.instance.contactRepo.init();
    await StorageService.instance.categoryRepo.init();
    await StorageService.instance.reminderRepo.init();
  });

  group('AlarmDisclosureDialog Google Play Compliance Tests', () {
    testWidgets('Renders prominent disclosure dialog and handles allow/cancel', (tester) async {
      bool? result;

      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await AlarmDisclosureDialog.show(context);
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );
      await tester.pump();

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Meeting Reminders & Exact Alarms'), findsOneWidget);
      expect(find.textContaining('CardSaathi requires notification and exact alarm permissions'), findsOneWidget);
      expect(find.text('Allow & Enable'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap Allow & Enable
      await tester.tap(find.text('Allow & Enable'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });
  });

  group('NotificationService Resilience Tests', () {
    test('NotificationService methods execute safely without unhandled crashes', () async {
      final service = NotificationService.instance;
      await service.init();
      expect(service.isInitialized, isTrue);

      final now = DateTime.now();
      final reminder = MeetingReminder(
        id: 'notif_test_1',
        title: 'Client Review',
        dateTime: now.add(const Duration(hours: 2)),
        notificationId: 901,
        createdAt: now,
      );

      final contact = ContactCard(
        id: 'c_notif_1',
        name: 'Vikas Gupta',
        phones: ['9876543210'],
        createdAt: now,
        updatedAt: now,
      );

      // Schedule meeting notification
      await service.scheduleMeetingNotification(reminder, contact: contact);

      // Show sticky daily summary
      await service.showStickyTodayMeetingsSummary([reminder]);

      // Cancel notification
      await service.cancelMeetingNotification(901);
    });
  });

  group('CardMeetingsSection & CardDetail Integration Tests', () {
    testWidgets('Renders empty state when contact has no meetings', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const Scaffold(
            body: CardMeetingsSection(
              cardId: 'contact_no_meetings',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Meetings & Follow-ups'), findsOneWidget);
      expect(find.text('No meetings scheduled with this contact'), findsOneWidget);
      expect(find.text('Schedule Meeting / Follow-up'), findsOneWidget);
    });

    testWidgets('Renders linked meetings and updates badge count for contact', (tester) async {
      final now = DateTime.now();
      final contact = ContactCard(
        id: 'contact_with_meetings',
        name: 'Deepak Sharma',
        company: 'Sharma Logistics',
        phones: ['9820011223'],
        createdAt: now,
        updatedAt: now,
      );

      final reminder = MeetingReminder(
        id: 'rem_linked_1',
        title: 'Annual Contract Renewal',
        agenda: 'Review revised tariff sheets',
        dateTime: now.add(const Duration(days: 2)),
        contactCardId: 'contact_with_meetings',
        notificationId: 902,
        createdAt: now,
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(contact);
        await StorageService.instance.reminderRepo.saveReminder(reminder);
      });

      await tester.pumpWidget(
        createTestApp(
          const Scaffold(
            body: CardMeetingsSection(
              cardId: 'contact_with_meetings',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Meetings & Follow-ups'), findsOneWidget);
      expect(find.text('Annual Contract Renewal'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // Badge count
    });

    testWidgets('CardDetailScreen renders embedded CardMeetingsSection', (tester) async {
      final now = DateTime.now();
      final card = ContactCard(
        id: 'detail_section_test_card',
        name: 'Kavita Menon',
        company: 'Menon Biotech',
        phones: ['9833012345'],
        email: 'kavita@menonbio.com',
        createdAt: now,
        updatedAt: now,
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(
        createTestApp(
          const CardDetailScreen(cardId: 'detail_section_test_card'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kavita Menon'), findsOneWidget);
      expect(find.byType(CardMeetingsSection), findsOneWidget);
      expect(find.text('Meetings & Follow-ups'), findsOneWidget);
    });
  });
}
