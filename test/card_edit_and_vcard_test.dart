import 'dart:io';
import 'package:audioplayers_platform_interface/audioplayers_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/services/vcard_service.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/category.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/cards/card_detail_screen.dart';
import 'package:cardsaathi/presentation/screens/cards/card_edit_screen.dart';

Widget createTestApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: child,
  );
}

Widget createTestAppWithNavigation(Widget screen, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => screen),
            ),
            child: const Text('OpenScreen'),
          ),
        ),
      ),
    ),
  );
}

class FakeAudioplayersPlatform extends AudioplayersPlatformInterface {
  @override
  Stream<AudioEvent> getEventStream(String playerId) => const Stream.empty();

  @override
  Future<int?> getCurrentPosition(String playerId) async => 0;

  @override
  Future<int?> getDuration(String playerId) async => 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => Future.value();
}

class FakeGlobalAudioplayersPlatform extends GlobalAudioplayersPlatformInterface {
  @override
  Stream<GlobalAudioEvent> getGlobalEventStream() => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => Future.value();
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;

    AudioplayersPlatformInterface.instance = FakeAudioplayersPlatform();
    GlobalAudioplayersPlatformInterface.instance = FakeGlobalAudioplayersPlatform();

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_edit_test_');

    // Mock path_provider
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => tempDir.path,
    );

    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    await StorageService.instance.categoryRepo.init();
    await StorageService.instance.contactRepo.init();
    await StorageService.instance.reminderRepo.init();
    await StorageService.instance.userProfileRepo.init();
  });

  setUp(() async {
    await StorageService.instance.contactRepo.clearAllCards();
    final box = Hive.box<Category>(HiveRegistrar.categoriesBox);
    await box.clear();
    await StorageService.instance.categoryRepo.seedDefaultCategories();
  });

  group('RFC 6350 vCard Service Tests', () {
    test('Generates RFC 6350 compliant vCard 3.0 content with full Indian credentials', () {
      final card = ContactCard(
        id: 'vcard_test_1',
        name: 'Rajesh Kumar Sharma',
        company: 'Sharma Wholesale Fabrics',
        jobTitle: 'Managing Partner',
        phones: const ['9876543210', '0261234567'],
        email: 'rajesh@sharmafabrics.com',
        website: 'sharmafabrics.com',
        gstin: '24AAAAA0000A1Z5',
        address: 'Ring Road, Surat, Gujarat 395002',
        notes: 'Met at national textile convention',
        tags: const ['#Wholesale', '#Supplier'],
        categoryId: 'wholesale',
        createdAt: DateTime.utc(2026, 10, 26, 12, 0, 0),
      );

      final vcard = VCardService.generateVCardString(card);

      expect(vcard.contains('BEGIN:VCARD'), isTrue);
      expect(vcard.contains('VERSION:3.0'), isTrue);
      expect(vcard.contains('FN;CHARSET=UTF-8:Rajesh Kumar Sharma'), isTrue);
      expect(vcard.contains('N;CHARSET=UTF-8:Sharma;Rajesh Kumar;;;'), isTrue);
      expect(vcard.contains('ORG;CHARSET=UTF-8:Sharma Wholesale Fabrics'), isTrue);
      expect(vcard.contains('TITLE;CHARSET=UTF-8:Managing Partner'), isTrue);
      expect(vcard.contains('TEL;TYPE=CELL,VOICE,PREF:9876543210'), isTrue);
      expect(vcard.contains('TEL;TYPE=WORK,VOICE:0261234567'), isTrue);
      expect(vcard.contains('EMAIL;TYPE=WORK,INTERNET:rajesh@sharmafabrics.com'), isTrue);
      expect(vcard.contains('URL:https://sharmafabrics.com'), isTrue);
      expect(vcard.contains('NOTE;CHARSET=UTF-8:GSTIN: 24AAAAA0000A1Z5\\nMet at national textile convention\\nTags: #Wholesale, #Supplier'), isTrue);
      expect(vcard.contains('CATEGORIES:wholesale'), isTrue);
      expect(vcard.contains('END:VCARD'), isTrue);
    });

    test('Exports vCard string to valid file on disk', () async {
      final card = ContactCard(
        id: 'file_test_card',
        name: 'Vikas Gupta',
        company: 'Gupta Enterprises',
        phones: const ['9822110099'],
        createdAt: DateTime.now(),
      );

      final file = await VCardService.exportVCardFile(card);
      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('.vcf'), isTrue);

      final content = await file.readAsString();
      expect(content.contains('BEGIN:VCARD'), isTrue);
      expect(content.contains('FN;CHARSET=UTF-8:Vikas Gupta'), isTrue);
      expect(content.contains('END:VCARD'), isTrue);
    });
  });

  group('CardEditScreen Form Population & Validation Tests', () {
    testWidgets('Populates all form fields from existing ContactCard', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final card = ContactCard(
        id: 'edit_pop_card',
        name: 'Anita Desai',
        company: 'Desai Legal Chambers',
        jobTitle: 'Senior Advocate',
        phones: const ['9811002233', '9811002244'],
        email: 'anita@desailaw.in',
        website: 'desailaw.in',
        gstin: '27AAAAA0000A1Z5',
        address: 'Nariman Point, Mumbai',
        notes: 'Consultation retainer',
        tags: const ['#Retainer', '#Corporate'],
        categoryId: 'legal',
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(createTestApp(const CardEditScreen(cardId: 'edit_pop_card')));
      await tester.pumpAndSettle();

      expect(find.text('Edit Card'), findsOneWidget);
      expect(find.text('Anita Desai'), findsOneWidget);
      expect(find.text('Desai Legal Chambers'), findsOneWidget);
      expect(find.text('Senior Advocate'), findsOneWidget);
      expect(find.text('9811002233'), findsOneWidget);
      expect(find.text('9811002244'), findsOneWidget);
      expect(find.text('anita@desailaw.in'), findsOneWidget);
      expect(find.text('#Retainer'), findsOneWidget);
      expect(find.text('#Corporate'), findsOneWidget);
    });

    testWidgets('Validates invalid GSTIN and invalid email', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final card = ContactCard(
        id: 'val_test_card',
        name: 'Test Contact',
        phones: const ['9800000000'],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(createTestApp(const CardEditScreen(cardId: 'val_test_card')));
      await tester.pumpAndSettle();

      // Enter invalid email
      final emailFinder = find.widgetWithText(TextFormField, 'Email Address');
      await tester.enterText(emailFinder, 'invalid-email-address');

      // Enter invalid GSTIN
      final gstinFinder = find.widgetWithText(TextFormField, '15-character GSTIN');
      await tester.enterText(gstinFinder, '123BADGSTIN');

      // Tap Save in AppBar
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Invalid 15-character GSTIN format'), findsOneWidget);
    });

    testWidgets('Modifying contact details and saving persists updates to repository', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final card = ContactCard(
        id: 'save_update_card',
        name: 'Sunil Verma',
        company: 'Verma Traders',
        jobTitle: 'Partner',
        phones: const ['9870011223'],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(createTestAppWithNavigation(
        const CardEditScreen(cardId: 'save_update_card'),
      ));
      await tester.pumpAndSettle();

      // Navigate to edit screen
      await tester.tap(find.text('OpenScreen'));
      await tester.pumpAndSettle();

      // Update name
      final nameFinder = find.widgetWithText(TextFormField, 'Contact Name *');
      await tester.enterText(nameFinder, 'Sunil Kumar Verma');

      // Update company
      final companyFinder = find.widgetWithText(TextFormField, 'Company / Business Name');
      await tester.enterText(companyFinder, 'Verma Global Logistics Pvt Ltd');

      // Tap Save in AppBar and allow async save to complete
      await tester.runAsync(() async {
        await tester.tap(find.text('Save'));
        await Future.delayed(const Duration(milliseconds: 300));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify update persisted in repository
      final updated = StorageService.instance.contactRepo.getCardById('save_update_card');
      expect(updated, isNotNull);
      expect(updated!.name, equals('Sunil Kumar Verma'));
      expect(updated.company, equals('Verma Global Logistics Pvt Ltd'));
      expect(updated.updatedAt, isNotNull);
    });
  });

  group('Safe Delete with Undo Tests', () {
    testWidgets('Deleting card provides Undo SnackBar that restores deleted card', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final card = ContactCard(
        id: 'undo_test_card',
        name: 'Pooja Agarwal',
        company: 'Agarwal Sweets',
        phones: const ['9833445566'],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      // Launch with navigation parent
      await tester.pumpWidget(createTestAppWithNavigation(
        const CardDetailScreen(cardId: 'undo_test_card'),
      ));
      await tester.pumpAndSettle();

      // Tap OpenScreen button to navigate into CardDetailScreen
      await tester.tap(find.text('OpenScreen'));
      await tester.pumpAndSettle();

      // Tap Delete icon in AppBar
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Tap Confirm in AlertDialog
      await tester.tap(find.text('Confirm'));
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await tester.pumpAndSettle();

      // Card is deleted from database
      expect(StorageService.instance.contactRepo.getCardById('undo_test_card'), isNull);

      // Undo action appears in SnackBar
      expect(find.text('Undo'), findsOneWidget);

      // Tap Undo in SnackBar
      await tester.tap(find.text('Undo'));
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
      await tester.pumpAndSettle();

      // Card is restored in database
      final restored = StorageService.instance.contactRepo.getCardById('undo_test_card');
      expect(restored, isNotNull);
      expect(restored!.name, equals('Pooja Agarwal'));
      expect(restored.company, equals('Agarwal Sweets'));
    });
  });
}
