import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/meeting_reminder.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/reminders/reminders_screen.dart';
import 'package:cardsaathi/presentation/widgets/reminders/add_edit_reminder_sheet.dart';
import 'package:cardsaathi/presentation/widgets/reminders/meeting_reminder_card.dart';

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

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_reminders_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    await StorageService.instance.contactRepo.init();
    await StorageService.instance.reminderRepo.init();
  });

  group('ReminderRepository Filtering Tests', () {
    test('Correctly categorizes today, upcoming, overdue, and completed reminders', () async {
      final repo = StorageService.instance.reminderRepo;
      await repo.clearAllReminders();

      final now = DateTime.now();
      final todayMeeting = MeetingReminder(
        id: 'rem_today',
        title: 'Today Textile Meeting',
        dateTime: DateTime(now.year, now.month, now.day, 16, 0),
        notificationId: 101,
        createdAt: now,
      );

      final upcomingMeeting = MeetingReminder(
        id: 'rem_upcoming',
        title: 'Next Week Fabric Review',
        dateTime: now.add(const Duration(days: 3)),
        notificationId: 102,
        createdAt: now,
      );

      final overdueMeeting = MeetingReminder(
        id: 'rem_overdue',
        title: 'Past Payment Follow-up',
        dateTime: now.subtract(const Duration(days: 2)),
        notificationId: 103,
        createdAt: now,
      );

      final completedMeeting = MeetingReminder(
        id: 'rem_completed',
        title: 'Finished Sampling Discussion',
        dateTime: now.subtract(const Duration(days: 1)),
        isCompleted: true,
        notificationId: 104,
        createdAt: now,
      );

      await repo.saveReminder(todayMeeting);
      await repo.saveReminder(upcomingMeeting);
      await repo.saveReminder(overdueMeeting);
      await repo.saveReminder(completedMeeting);

      final todayList = repo.getTodayReminders();
      expect(todayList.any((r) => r.id == 'rem_today'), isTrue);
      expect(todayList.any((r) => r.id == 'rem_completed'), isFalse);

      final upcomingList = repo.getUpcomingReminders();
      expect(upcomingList.any((r) => r.id == 'rem_upcoming'), isTrue);

      final overdueList = repo.getOverdueReminders();
      expect(overdueList.any((r) => r.id == 'rem_overdue'), isTrue);

      final completedList = repo.getCompletedReminders();
      expect(completedList.any((r) => r.id == 'rem_completed'), isTrue);

      // Toggle completion
      await repo.toggleCompleted('rem_today');
      expect(repo.getCompletedReminders().any((r) => r.id == 'rem_today'), isTrue);
      expect(repo.getTodayReminders().any((r) => r.id == 'rem_today'), isFalse);

      // Delete reminder
      await repo.deleteReminder('rem_today');
      expect(repo.getReminderById('rem_today'), isNull);
    });
  });

  group('MeetingReminderCard Widget Tests', () {
    testWidgets('Renders meeting title, agenda, status badge, and linked contact', (tester) async {
      final now = DateTime.now();
      final contact = ContactCard(
        id: 'contact_99',
        name: 'Amit Patel',
        company: 'Patel Electronics',
        phones: ['9876543210'],
        createdAt: now,
        updatedAt: now,
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(contact);
      });

      final reminder = MeetingReminder(
        id: 'rem_test_card',
        title: 'Quarterly Vendor Meet',
        agenda: 'Review component supply rate cards',
        dateTime: now.add(const Duration(days: 1)),
        contactCardId: 'contact_99',
        notificationId: 105,
        createdAt: now,
      );

      bool toggleCalled = false;
      bool editCalled = false;

      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: MeetingReminderCard(
              reminder: reminder,
              onToggleCompleted: () => toggleCalled = true,
              onEdit: () => editCalled = true,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Quarterly Vendor Meet'), findsOneWidget);
      expect(find.text('Review component supply rate cards'), findsOneWidget);
      expect(find.text('Amit Patel'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      // Tap Checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(toggleCalled, isTrue);

      // Tap Card for Edit
      await tester.tap(find.text('Quarterly Vendor Meet'));
      await tester.pump();
      expect(editCalled, isTrue);
    });
  });

  group('AddEditReminderSheet Widget Tests', () {
    testWidgets('Validates required title and saves new meeting reminder', (tester) async {
      MeetingReminder? savedReminder;

      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: AddEditReminderSheet(
              onSaved: (r) => savedReminder = r,
            ),
          ),
        ),
      );
      await tester.pump();

      // Tap save without title (validation error)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Title is required'), findsOneWidget);
      expect(savedReminder, isNull);

      // Enter title and agenda
      await tester.enterText(find.byType(TextFormField).first, 'Annual Deal Review');
      await tester.enterText(find.byType(TextFormField).last, 'Discuss volume discounts');
      await tester.pump();

      // Tap save within runAsync to allow Hive disk writes
      await tester.runAsync(() async {
        await tester.tap(find.byType(ElevatedButton));
        await Future.delayed(const Duration(milliseconds: 600));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(savedReminder, isNotNull);
      expect(savedReminder!.title, 'Annual Deal Review');
      expect(savedReminder!.agenda, 'Discuss volume discounts');
    });
  });

  group('RemindersScreen 3-Tab & Completed Toggle Tests', () {
    testWidgets('Renders 3 tabs, shows badge counts, switches tabs, and toggles completed', (tester) async {
      final repo = StorageService.instance.reminderRepo;

      final now = DateTime.now();
      final todayMeeting = MeetingReminder(
        id: 'tab_today_1',
        title: 'Today Inspection',
        dateTime: DateTime(now.year, now.month, now.day, 23, 59),
        notificationId: 201,
        createdAt: now,
      );
      final upcomingMeeting = MeetingReminder(
        id: 'tab_up_1',
        title: 'Upcoming Delivery',
        dateTime: now.add(const Duration(days: 4)),
        notificationId: 202,
        createdAt: now,
      );
      final completedMeeting = MeetingReminder(
        id: 'tab_done_1',
        title: 'Done Contract',
        dateTime: now.subtract(const Duration(days: 1)),
        isCompleted: true,
        notificationId: 203,
        createdAt: now,
      );

      await tester.runAsync(() async {
        await repo.clearAllReminders();
        await repo.saveReminder(todayMeeting);
        await repo.saveReminder(upcomingMeeting);
        await repo.saveReminder(completedMeeting);
      });

      await tester.pumpWidget(createTestApp(const RemindersScreen()));
      await tester.pump();

      // Check Tabs exist
      expect(find.widgetWithText(Tab, 'Today'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Upcoming'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Overdue'), findsOneWidget);

      // Today meeting visible
      expect(find.text('Today Inspection'), findsOneWidget);

      // Switch to Upcoming Tab
      await tester.tap(find.widgetWithText(Tab, 'Upcoming'));
      await tester.pumpAndSettle();
      expect(find.text('Upcoming Delivery'), findsOneWidget);

      // Switch to Overdue Tab
      await tester.tap(find.widgetWithText(Tab, 'Overdue'));
      await tester.pumpAndSettle();
      expect(find.text('All Caught Up!'), findsOneWidget);

      // Toggle completed meetings icon in AppBar
      await tester.tap(find.byIcon(Icons.check_circle_outline));
      await tester.pumpAndSettle();
      expect(find.text('Done Contract'), findsOneWidget);

      // Floating Action Button exists
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
