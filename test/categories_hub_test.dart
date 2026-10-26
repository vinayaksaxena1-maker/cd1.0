import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/category.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/categories/categories_screen.dart';
import 'package:cardsaathi/presentation/screens/categories/widgets/category_card_tile.dart';
import 'package:cardsaathi/presentation/screens/categories/widgets/category_drilldown_sheet.dart';

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

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_cat_test_');
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

  group('Categories Hub & Commercial Tagging Engine Tests', () {
    testWidgets('Renders 20 default commercial categories and header overview', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(const CategoriesScreen()));
      await tester.pumpAndSettle();

      // Check AppBar title
      expect(find.text('Categories'), findsOneWidget);

      // Check Commercial Categories overview card
      expect(find.text('Commercial Categories'), findsOneWidget);
      expect(find.text('20 Total'), findsOneWidget);
      expect(find.text('20 Commercial'), findsOneWidget);

      // Check presence of category card tiles
      expect(find.byType(CategoryCardTile), findsWidgets);
      expect(find.text('Agriculture'), findsOneWidget);
      expect(find.text('Food & Beverage'), findsOneWidget);
    });

    testWidgets('Displays accurate live card counts for categories', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();
      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(
          ContactCard(
            id: 'card_1',
            name: 'Ramesh Patel',
            company: 'Patel Agro Farms',
            categoryId: 'agriculture',
            phones: const ['9876543210'],
            createdAt: now,
          ),
        );
        await StorageService.instance.contactRepo.saveCard(
          ContactCard(
            id: 'card_2',
            name: 'Suresh Shah',
            company: 'Shah Agro Supplies',
            categoryId: 'agriculture',
            phones: const ['9876543211'],
            createdAt: now,
          ),
        );
        await StorageService.instance.contactRepo.saveCard(
          ContactCard(
            id: 'card_3',
            name: 'Dr. Anita Joshi',
            company: 'City Academy',
            categoryId: 'education',
            phones: const ['9876543212'],
            createdAt: now,
          ),
        );
      });

      await tester.pumpWidget(createTestApp(const CategoriesScreen()));
      await tester.pumpAndSettle();

      // Header shows 3 Cards
      expect(find.text('3 Cards'), findsOneWidget);

      // Agriculture shows 2 Cards
      expect(find.text('2 Cards'), findsOneWidget);
      // Education shows 1 Card
      expect(find.text('1 Card'), findsOneWidget);
    });

    testWidgets('Tapping category tile opens CategoryDrillDownSheet with contacts', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();
      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(
          ContactCard(
            id: 'card_agri_1',
            name: 'Ramesh Patel',
            company: 'Patel Agro Farms',
            jobTitle: 'Director',
            categoryId: 'agriculture',
            phones: const ['9876543210'],
            createdAt: now,
          ),
        );
      });

      await tester.pumpWidget(createTestApp(const CategoriesScreen()));
      await tester.pumpAndSettle();

      // Tap on Agriculture tile
      await tester.tap(find.text('Agriculture'));
      await tester.pumpAndSettle();

      // Category Drill-Down bottom sheet opens
      expect(find.byType(CategoryDrillDownSheet), findsOneWidget);
      expect(find.text('Ramesh Patel'), findsOneWidget);
      expect(find.text('Director • Patel Agro Farms'), findsOneWidget);
      expect(find.text('View in Directory'), findsOneWidget);
    });

    testWidgets('Empty category shows clean empty state in drill-down sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(const CategoriesScreen()));
      await tester.pumpAndSettle();

      // Tap on Automotive (0 cards)
      await tester.tap(find.text('Automotive'));
      await tester.pumpAndSettle();

      expect(find.byType(CategoryDrillDownSheet), findsOneWidget);
      expect(find.text('No cards in this category yet'), findsOneWidget);
    });

    testWidgets('Default commercial categories delete protection cannot be bypassed', (tester) async {
      await tester.runAsync(() async {
        final catRepo = StorageService.instance.categoryRepo;
        final result = await catRepo.deleteCategory('retail');
        expect(result, isFalse);

        final retail = catRepo.getCategoryById('retail');
        expect(retail, isNotNull);
        expect(retail!.isCustom, isFalse);
      });
    });

    testWidgets('Custom category creation and safe deletion reassigns cards to other', (tester) async {
      await tester.runAsync(() async {
        final catRepo = StorageService.instance.categoryRepo;
        final contactRepo = StorageService.instance.contactRepo;

        // Add custom category
        await catRepo.addCustomCategory(
          id: 'custom_stationery',
          nameEn: 'Stationery & Printing',
          nameHi: 'स्टेशनरी एवं प्रिंटिंग',
          iconCode: 0xe602,
        );

        // Verify category added
        final customCat = catRepo.getCategoryById('custom_stationery');
        expect(customCat, isNotNull);
        expect(customCat!.isCustom, isTrue);

        // Assign a card to this custom category
        await contactRepo.saveCard(
          ContactCard(
            id: 'card_stat_1',
            name: 'Vikas Sharma',
            company: 'Sharma Printers',
            categoryId: 'custom_stationery',
            phones: const ['9876543299'],
            createdAt: DateTime.now(),
          ),
        );

        // Verify card has custom categoryId
        var card = contactRepo.getCardById('card_stat_1');
        expect(card!.categoryId, equals('custom_stationery'));

        // Safely delete custom category passing contactRepo
        final deleted = await catRepo.deleteCategory('custom_stationery', contactRepo: contactRepo);
        expect(deleted, isTrue);

        // Category is deleted from repository
        expect(catRepo.getCategoryById('custom_stationery'), isNull);

        // SAFE DELETION INVARIANT: Card must NOT be lost, reassigned to 'other'
        card = contactRepo.getCardById('card_stat_1');
        expect(card, isNotNull);
        expect(card!.categoryId, equals('other'));
      });
    });

    testWidgets('Hindi locale renders Devanagari category names correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(const CategoriesScreen(), locale: const Locale('hi')));
      await tester.pumpAndSettle();

      expect(find.text('श्रेणियां'), findsOneWidget);
      expect(find.text('व्यावसायिक श्रेणियां'), findsOneWidget);
      expect(find.text('कृषि एवं संबद्ध'), findsOneWidget);
      expect(find.text('खाद्य एवं पेय'), findsOneWidget);
    });
  });
}
