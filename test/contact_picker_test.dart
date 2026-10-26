import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:cardsaathi/core/services/contact_picker_service.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/category.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/cards/cards_screen.dart';

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

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_picker_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    await StorageService.instance.categoryRepo.init();
    await StorageService.instance.contactRepo.init();
    await StorageService.instance.reminderRepo.init();
    await StorageService.instance.userProfileRepo.init();
  });

  setUp(() async {
    final box = Hive.box<Category>(HiveRegistrar.categoriesBox);
    await box.clear();
    await StorageService.instance.categoryRepo.seedDefaultCategories();
  });

  group('PickedContact Model Tests', () {
    test('Parses name, cleans phone formatting, and extracts email correctly', () {
      final map = {
        'name': '  Ramesh Patel  ',
        'phone': '+91 98220-11223',
        'email': '  ramesh@pateltraders.com  ',
      };

      final picked = PickedContact.fromMap(map);
      expect(picked.name, equals('Ramesh Patel'));
      expect(picked.phone, equals('+919822011223'));
      expect(picked.email, equals('ramesh@pateltraders.com'));

      final card = picked.toContactCard(id: 'ramesh_id', categoryId: 'retail_kirana');
      expect(card.id, equals('ramesh_id'));
      expect(card.name, equals('Ramesh Patel'));
      expect(card.phones, equals(['+919822011223']));
      expect(card.email, equals('ramesh@pateltraders.com'));
      expect(card.categoryId, equals('retail_kirana'));
      expect(card.notes, contains('Imported from phone contacts'));
    });

    test('Gracefully handles empty strings and null email', () {
      final map = {
        'name': '',
        'phone': '(022) 2345 6789',
        'email': '',
      };

      final picked = PickedContact.fromMap(map);
      expect(picked.name, equals(''));
      expect(picked.phone, equals('02223456789'));
      expect(picked.email, isNull);

      final card = picked.toContactCard(id: 'blank_id');
      expect(card.name, equals(''));
      expect(card.phones, equals(['02223456789']));
      expect(card.email, equals(''));
      expect(card.categoryId, equals('other'));
    });
  });

  group('ContactPickerService Platform Channel Tests', () {
    test('pickContact returns PickedContact when user selects contact', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.cardsaathi/contact_picker'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'pickContact') {
            return {
              'name': 'Ananya Sen',
              'phone': '9811223344',
              'email': 'ananya@design.in',
            };
          }
          return null;
        },
      );

      final result = await ContactPickerService.instance.pickContact();
      expect(result, isNotNull);
      expect(result!.name, equals('Ananya Sen'));
      expect(result.phone, equals('9811223344'));
      expect(result.email, equals('ananya@design.in'));
    });

    test('pickContact returns null when user cancels selection', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.cardsaathi/contact_picker'),
        (MethodCall methodCall) async => null,
      );

      final result = await ContactPickerService.instance.pickContact();
      expect(result, isNull);
    });

    test('pickContact handles PlatformException safely and returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.cardsaathi/contact_picker'),
        (MethodCall methodCall) async {
          throw PlatformException(code: 'CANCELED', message: 'Activity canceled');
        },
      );

      final result = await ContactPickerService.instance.pickContact();
      expect(result, isNull);
    });
  });

  group('CardsScreen Contact Picker UI Tests', () {
    testWidgets('Renders Import from Phone Contacts in empty state and triggers picker', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      var channelCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.cardsaathi/contact_picker'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'pickContact') {
            channelCalled = true;
            return {
              'name': 'Vikram Malhotra',
              'phone': '9876543210',
              'email': 'vikram@malhotra.com',
            };
          }
          return null;
        },
      );

      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pumpAndSettle();

      // Verify empty state shows "Import from Phone Contacts"
      expect(find.text('Import from Phone Contacts'), findsWidgets);

      // Tap the Import from Phone Contacts button in empty state
      final importBtn = find.widgetWithText(OutlinedButton, 'Import from Phone Contacts');
      expect(importBtn, findsOneWidget);

      await tester.tap(importBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(channelCalled, isTrue);

      // Verify card was created and saved in repository
      final allCards = StorageService.instance.contactRepo.getAllCards();
      expect(allCards.length, equals(1));
      expect(allCards.first.name, equals('Vikram Malhotra'));
      expect(allCards.first.phones, equals(['9876543210']));
      expect(allCards.first.email, equals('vikram@malhotra.com'));
    });

    testWidgets('Tapping FAB opens Bottom Sheet with Scan and Import options', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(const CardsScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Tap FAB (+)
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Bottom sheet appears with both choices
      expect(find.text('Scan physical visiting card with camera or gallery'), findsOneWidget);
      expect(find.text('Pick directly from your phone address book'), findsOneWidget);
    });
  });
}
