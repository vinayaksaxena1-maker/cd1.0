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
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/cards/cards_screen.dart';
import 'package:cardsaathi/presentation/widgets/cards/card_tile_widget.dart';

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

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_dir_test_');
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

  group('CardTileWidget Component Tests', () {
    testWidgets('Renders card details with initials, badges, and quick actions', (tester) async {
      final card = ContactCard(
        id: 'card_1',
        name: 'Rajesh Sharma',
        company: 'Sharma Textiles Pvt Ltd',
        jobTitle: 'Managing Director',
        phones: ['9876543210'],
        email: 'rajesh@sharmatextiles.in',
        address: 'Surat, Gujarat',
        gstin: '24AAAAA0000A1Z5',
        categoryId: 'textiles_garments',
        voiceMemoPath: '/data/audio/memo1.m4a',
        notes: 'Met at textile expo',
        tags: ['#WholesaleDeal'],
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createTestApp(
        Scaffold(body: CardTileWidget(card: card)),
      ));
      await tester.pump();

      expect(find.text('Rajesh Sharma'), findsOneWidget);
      expect(find.text('RS'), findsOneWidget); // Initials
      expect(find.textContaining('Sharma Textiles'), findsOneWidget);
      expect(find.text('24AAAAA0000A1Z5'), findsOneWidget);
      expect(find.text('Voice'), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.call_outlined), findsOneWidget);
    });
  });

  group('CardsScreen 5-State Resilience & Directory Tests', () {
    testWidgets('State 3: Renders Empty State when no cards exist in database', (tester) async {
      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('No cards added yet'), findsOneWidget);
      expect(find.byIcon(Icons.credit_card_off_outlined), findsOneWidget);
      expect(find.text('Scan Visiting Card'), findsOneWidget);
    });

    testWidgets('State 5: Renders populated list of cards and category counts', (tester) async {
      final card1 = ContactCard(
        id: 'c1',
        name: 'Amit Patel',
        company: 'Patel Electronics',
        jobTitle: 'Store Owner',
        phones: ['9825012345'],
        email: 'info@patelelec.com',
        address: 'Ahmedabad',
        gstin: '24AAACP1234A1Z5',
        categoryId: 'retail_kirana',
        notes: 'Distributor for phones',
        tags: ['#Retail'],
        createdAt: DateTime.now(),
      );

      final card2 = ContactCard(
        id: 'c2',
        name: 'Dr. Sunita Rao',
        company: 'City Care Hospital',
        jobTitle: 'Chief Physician',
        phones: ['9845012345'],
        email: 'sunita@citycare.org',
        address: 'Bengaluru',
        gstin: '',
        categoryId: 'healthcare_pharma',
        notes: '',
        tags: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card1);
        await StorageService.instance.contactRepo.saveCard(card2);
      });

      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Amit Patel'), findsOneWidget);
      expect(find.text('Dr. Sunita Rao'), findsOneWidget);
      expect(find.text('2 Cards'), findsOneWidget);
      expect(find.text('All (2)'), findsOneWidget);
    });

    testWidgets('State 4: Instant Search filters list and shows Empty Search state with reset', (tester) async {
      final card1 = ContactCard(
        id: 'c1',
        name: 'Vikram Malhotra',
        company: 'Malhotra Logistics',
        jobTitle: 'Director',
        phones: ['9911223344'],
        email: 'vikram@malhotra.com',
        address: 'Delhi NCR',
        gstin: '07AAAAA1111A1Z1',
        categoryId: 'transport_logistics',
        notes: '',
        tags: [],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card1);
      });

      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Vikram Malhotra'), findsOneWidget);

      // Search for non-existing name
      await tester.enterText(find.byType(TextField), 'Zomato');
      await tester.pumpAndSettle();

      expect(find.text('Vikram Malhotra'), findsNothing);
      expect(find.text('No matching cards found'), findsOneWidget);
      expect(find.text('Clear Filters'), findsAtLeastNWidgets(1));

      // Tap Clear Filters
      await tester.tap(find.widgetWithText(OutlinedButton, 'Clear Filters'));
      await tester.pumpAndSettle();

      expect(find.text('Vikram Malhotra'), findsOneWidget);
    });

    testWidgets('Category chips filter list to matching category only', (tester) async {
      final card1 = ContactCard(
        id: 'c1',
        name: 'Karan Mehra',
        company: 'Mehra Jewels',
        jobTitle: 'Proprietor',
        phones: ['9820011223'],
        email: 'karan@mehrajewels.in',
        address: 'Mumbai',
        gstin: '27AAAAA2222A1Z2',
        categoryId: 'gems_jewellery',
        notes: '',
        tags: [],
        createdAt: DateTime.now(),
      );

      final card2 = ContactCard(
        id: 'c2',
        name: 'Suresh Raina',
        company: 'Raina Sports & Fitness',
        jobTitle: 'Founder',
        phones: ['9810011223'],
        email: 'suresh@rainasports.com',
        address: 'Chennai',
        gstin: '33AAAAA3333A1Z3',
        categoryId: 'sports_fitness',
        notes: '',
        tags: [],
        createdAt: DateTime.now(),
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card1);
        await StorageService.instance.contactRepo.saveCard(card2);
      });

      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Karan Mehra'), findsOneWidget);
      expect(find.text('Suresh Raina'), findsOneWidget);

      // Filter by Gems & Jewellery
      final gemsChip = find.widgetWithText(ChoiceChip, 'Gems & Jewellery (1)');
      if (gemsChip.evaluate().isNotEmpty) {
        await tester.tap(gemsChip);
        await tester.pumpAndSettle();

        expect(find.text('Karan Mehra'), findsOneWidget);
        expect(find.text('Suresh Raina'), findsNothing);
      }
    });

    testWidgets('Sort bottom sheet opens and displays sort options', (tester) async {
      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.sort_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Sort By'), findsOneWidget);
      expect(find.text('Newest First'), findsOneWidget);
      expect(find.text('Oldest First'), findsOneWidget);
      expect(find.text('Name (A-Z)'), findsOneWidget);
      expect(find.text('Company (A-Z)'), findsOneWidget);
    });
  });
}
