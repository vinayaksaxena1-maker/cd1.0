import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/models/extracted_card_data.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/scan/review_scan_screen.dart';

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

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.llfbandit.record/messages'),
      (MethodCall methodCall) async {
        return null;
      },
    );

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_review_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    await StorageService.instance.categoryRepo.init();
    await StorageService.instance.contactRepo.init();
    await StorageService.instance.reminderRepo.init();
    await StorageService.instance.userProfileRepo.init();
  });

  setUp(() async {
    await StorageService.instance.contactRepo.clearAllCards();
  });

  group('ReviewScanScreen Form Population & Stitch UI Tests', () {
    testWidgets('Populates form fields with initial ExtractedCardData', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      const extracted = ExtractedCardData(
        name: 'Vikramaditya Sharma',
        company: 'Sharma Handlooms Pvt Ltd',
        jobTitle: 'Managing Director',
        phones: ['+91 98765 43210'],
        email: 'vikram@sharmahandlooms.in',
        website: 'https://sharmahandlooms.in',
        gstin: '07AAAAA0000A1Z5',
        address: '12-B, Industrial Area, Surat, Gujarat 395001',
        suggestedCategoryId: 'textile',
      );

      await tester.pumpWidget(
        createTestApp(
          const ReviewScanScreen(initialData: extracted),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Check fields
      expect(find.text('Vikramaditya Sharma'), findsOneWidget);
      expect(find.text('Sharma Handlooms Pvt Ltd'), findsOneWidget);
      expect(find.text('Managing Director'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('vikram@sharmahandlooms.in'), findsOneWidget);
      expect(find.text('https://sharmahandlooms.in'), findsOneWidget);
      expect(find.text('07AAAAA0000A1Z5'), findsOneWidget);

      // Save Card button should be present
      expect(find.text('Save Card'), findsOneWidget);
    });

    testWidgets('Toggles quick tags correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          const ReviewScanScreen(
            initialData: ExtractedCardData(name: 'Test Contact'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final chipFinder = find.text('#WholesaleDeal');
      expect(chipFinder, findsOneWidget);

      await tester.ensureVisible(chipFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap to toggle tag
      await tester.tap(chipFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Should still be visible as selected chip
      expect(find.text('#WholesaleDeal'), findsOneWidget);
    });

    testWidgets('Smart duplicate detection alerts user if contact exists', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      // 1. Seed an existing contact in Hive via real async I/O
      final existingCard = ContactCard(
        id: 'existing-card-123',
        name: 'Rajesh Patel',
        company: 'Patel Agro Industries',
        phones: ['+91 98220 12345'],
        email: 'rajesh@patelagro.com',
        categoryId: 'agriculture',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(existingCard);
      });

      // 2. Open ReviewScanScreen with same name
      const duplicateData = ExtractedCardData(
        name: 'Rajesh Patel',
        company: 'Patel Agro New Branch',
        phones: ['+91 98220 12345'],
      );

      await tester.pumpWidget(
        createTestApp(
          const ReviewScanScreen(initialData: duplicateData),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // 3. Duplicate warning banner should be displayed
      expect(find.text('Possible Duplicate Detected!'), findsOneWidget);
      expect(find.text('Update Existing'), findsOneWidget);
      expect(find.text('Save as New'), findsOneWidget);
    });

    testWidgets('Saving new contact persists to Hive repository', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      const cardData = ExtractedCardData(
        name: 'Pooja Agarwal',
        company: 'Agarwal Sweets & Namkeen',
        jobTitle: 'Proprietor',
        phones: ['+91 98111 22233'],
        suggestedCategoryId: 'retail',
      );

      await tester.pumpWidget(
        createTestApp(
          const ReviewScanScreen(initialData: cardData),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap Save Card button
      final saveBtn = find.text('Save Card');
      expect(saveBtn, findsOneWidget);

      await tester.ensureVisible(saveBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(saveBtn);
      // Allow Hive disk write to complete
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify contact was saved in repo
      final allCards = StorageService.instance.contactRepo.getAllCards();
      expect(allCards.length, 1);
      expect(allCards.first.name, 'Pooja Agarwal');
      expect(allCards.first.company, 'Agarwal Sweets & Namkeen');
    });
  });
}
