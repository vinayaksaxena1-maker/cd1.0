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
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/cards/card_detail_screen.dart';

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

    // Mock audioplayers method channels
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async {
        return 1;
      },
    );

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_detail_test_');
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

  group('CardDetailScreen UI & Indian Communication Suite Tests', () {
    testWidgets('Renders full card details, credentials, and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final card = ContactCard(
        id: 'detail_card_1',
        name: 'Sanjay Singhania',
        company: 'Singhania Logistics Ltd',
        jobTitle: 'Chief Operating Officer',
        phones: ['9876543210'],
        email: 'sanjay@singhanialogistics.com',
        website: 'singhanialogistics.com',
        address: 'Nariman Point, Mumbai, Maharashtra 400021',
        gstin: '27AAAAA1234A1Z5',
        categoryId: 'transport_logistics',
        voiceMemoPath: '/data/audio/memo.m4a',
        notes: 'Discussion regarding bulk container fleet',
        tags: ['#BulkDeal', '#VIPClient'],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(createTestApp(
        const CardDetailScreen(cardId: 'detail_card_1'),
      ));
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Sanjay Singhania'), findsOneWidget);
      expect(find.textContaining('Singhania Logistics Ltd'), findsOneWidget);
      expect(find.textContaining('Chief Operating Officer'), findsOneWidget);

      // Verify One-Tap Quick Actions
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Google Maps'), findsOneWidget);

      // Verify Indian Business Credentials (GSTIN & PAN)
      expect(find.text('GSTIN: 27AAAAA1234A1Z5'), findsOneWidget);
      expect(find.text('PAN: AAAAA1234A'), findsOneWidget);

      // Verify Contact Details
      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('sanjay@singhanialogistics.com'), findsOneWidget);
      expect(find.text('singhanialogistics.com'), findsOneWidget);
      expect(find.textContaining('Nariman Point, Mumbai'), findsOneWidget);

      // Verify Notes and Tags
      expect(find.textContaining('Discussion regarding bulk container fleet'), findsOneWidget);
      expect(find.text('#BulkDeal'), findsOneWidget);
      expect(find.text('#VIPClient'), findsOneWidget);
    });

    testWidgets('Renders Card Not Found state gracefully for invalid card ID', (tester) async {
      await tester.pumpWidget(createTestApp(
        const CardDetailScreen(cardId: 'non_existent_id'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Card not found or has been deleted'), findsOneWidget);
      expect(find.byIcon(Icons.credit_card_off_outlined), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('Tapping Copy GSTIN triggers confirmation feedback', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final card = ContactCard(
        id: 'copy_test_card',
        name: 'Alok Gupta',
        company: 'Gupta Traders',
        jobTitle: 'Proprietor',
        phones: ['9811002233'],
        email: 'alok@gupta.com',
        address: 'Chandni Chowk, Delhi',
        gstin: '07AAAAA9999A1Z9',
        categoryId: 'retail_kirana',
        notes: '',
        tags: [],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(createTestApp(
        const CardDetailScreen(cardId: 'copy_test_card'),
      ));
      await tester.pumpAndSettle();

      // Find copy button next to GSTIN
      final copyBtn = find.byTooltip('Copy GSTIN');
      expect(copyBtn, findsOneWidget);

      await tester.tap(copyBtn);
      await tester.pump(); // Show snackbar

      expect(find.textContaining('Copied to clipboard'), findsOneWidget);
    });

    testWidgets('Tapping Delete button shows confirmation alert dialog', (tester) async {
      final card = ContactCard(
        id: 'delete_test_card',
        name: 'Ramesh Verma',
        company: 'Verma Jewellers',
        jobTitle: '',
        phones: ['9822110099'],
        email: '',
        address: '',
        gstin: '',
        categoryId: 'gems_jewellery',
        notes: '',
        tags: [],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(createTestApp(
        const CardDetailScreen(cardId: 'delete_test_card'),
      ));
      await tester.pumpAndSettle();

      // Tap Delete icon in AppBar
      final deleteIcon = find.byTooltip('Delete Card');
      expect(deleteIcon, findsOneWidget);

      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      // Verify AlertDialog is visible
      expect(find.text('Are you sure you want to delete this card?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify dialog dismissed and card still exists
      expect(find.text('Are you sure you want to delete this card?'), findsNothing);
      expect(find.text('Ramesh Verma'), findsOneWidget);
    });
  });
}
