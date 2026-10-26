import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';
import 'package:cardsaathi/data/local/hive_registrar.dart';
import 'package:cardsaathi/data/local/storage_service.dart';
import 'package:cardsaathi/data/models/contact_card.dart';
import 'package:cardsaathi/data/templates/stitch_template_registry.dart';
import 'package:cardsaathi/l10n/app_localizations.dart';
import 'package:cardsaathi/presentation/screens/digital_card/digital_card_screen.dart';
import 'package:cardsaathi/presentation/widgets/digital_card/digital_card_canvas.dart';
import 'package:cardsaathi/presentation/widgets/digital_card/vcard_qr_modal.dart';

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

    tempDir = Directory.systemTemp.createTempSync('cardsaathi_m5_test_');
    Hive.init(tempDir.path);
    HiveRegistrar.registerAdapters();
    await StorageService.instance.contactRepo.init();
    await StorageService.instance.categoryRepo.init();
    await StorageService.instance.reminderRepo.init();
  });

  tearDownAll(() async {
    await Hive.close();
    try {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  group('Stitch 20-Template Registry & Recommendation Engine Tests', () {
    test('Registry contains exactly 20 distinct templates bound to Stitch', () {
      final templates = StitchTemplateRegistry.allTemplates;
      expect(templates.length, equals(20));

      final ids = templates.map((t) => t.id).toSet();
      expect(ids.length, equals(20), reason: 'Every template must have a unique ID');

      final numbers = templates.map((t) => t.number).toSet();
      expect(numbers.length, equals(20), reason: 'Every template must have a unique number 1-20');
    });

    test('Category recommendation prioritizes industry-specific templates', () {
      // Retail / Kirana
      final retailTemplates = StitchTemplateRegistry.getTemplatesForCategory('retail');
      expect(retailTemplates.first.number, equals(19), reason: 'Local Business Quick Contact must lead retail');

      // Healthcare
      final healthTemplates = StitchTemplateRegistry.getTemplatesForCategory('healthcare');
      expect(healthTemplates.first.number, equals(15), reason: 'Healthcare Calm must lead healthcare');

      // Food & Hospitality
      final foodTemplates = StitchTemplateRegistry.getTemplatesForCategory('food_beverage');
      expect(foodTemplates.first.number, equals(13), reason: 'Food & Hospitality must lead food category');

      // Finance
      final financeTemplates = StitchTemplateRegistry.getTemplatesForCategory('finance');
      expect(financeTemplates.first.number, equals(14), reason: 'Finance & Consulting must lead finance');

      // Manufacturing
      final mfgTemplates = StitchTemplateRegistry.getTemplatesForCategory('manufacturing');
      expect(mfgTemplates.first.number, equals(11), reason: 'Architectural Blueprint must lead manufacturing');
    });
  });

  group('DigitalCardCanvas Component Tests', () {
    final testCard = ContactCard(
      id: 'canvas_test_card',
      name: 'Sunil Verma',
      company: 'Verma Iron & Steel',
      jobTitle: 'Partner',
      categoryId: 'manufacturing',
      phones: ['+91 98111 22334'],
      email: 'sunil@vermasteel.com',
      website: 'www.vermasteel.com',
      address: 'Loha Mandi, Agra, UP',
      gstin: '09AAAFV1234A1Z5',
      createdAt: DateTime.now(),
    );

    testWidgets('Renders template 19 Local Business canvas without overflow', (tester) async {
      final template = StitchTemplateRegistry.getTemplateById('template_19');
      final repaintKey = GlobalKey();

      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: SizedBox(
                width: 340,
                child: DigitalCardCanvas(
                  repaintBoundaryKey: repaintKey,
                  card: testCard,
                  template: template,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sunil Verma'), findsOneWidget);
      expect(find.text('Verma Iron & Steel'), findsOneWidget);
      expect(find.text('Partner'), findsOneWidget);
      expect(find.text('+91 98111 22334'), findsOneWidget);
      expect(find.text('GSTIN: 09AAAFV1234A1Z5'), findsOneWidget);
      expect(find.text('#19'), findsOneWidget);
    });

    testWidgets('Renders template 11 Architectural Blueprint dark canvas', (tester) async {
      final template = StitchTemplateRegistry.getTemplateById('template_11');
      final repaintKey = GlobalKey();

      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: Center(
              child: SizedBox(
                width: 340,
                child: DigitalCardCanvas(
                  repaintBoundaryKey: repaintKey,
                  card: testCard,
                  template: template,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sunil Verma'), findsOneWidget);
      expect(find.text('#11'), findsOneWidget);
      expect(find.text('CARTSAATHI // BLUEPRINT SPEC'), findsOneWidget);
    });
  });

  group('VCardQrModal Tests', () {
    final testCard = ContactCard(
      id: 'qr_test_card',
      name: 'Amitabh Sen',
      company: 'Sen Pharma',
      phones: ['9876543210'],
      email: 'amitabh@senpharma.in',
      createdAt: DateTime.now(),
    );

    testWidgets('Renders offline QR code image and copy button', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => VCardQrModal.show(context, testCard),
              child: const Text('Show QR'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show QR'));
      await tester.pumpAndSettle();

      expect(find.text('Offline Contact QR Code'), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('Amitabh Sen'), findsOneWidget);
      expect(find.text('Copy vCard'), findsOneWidget);
    });
  });

  group('DigitalCardScreen Screen & Interactive Tests', () {
    testWidgets('Renders 20 template carousel and WhatsApp share button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final now = DateTime.now();
      final card = ContactCard(
        id: 'screen_test_card',
        name: 'Deepak Chawla',
        company: 'Chawla Textiles',
        categoryId: 'retail',
        phones: ['9812345678'],
        createdAt: now,
      );

      await tester.runAsync(() async {
        await StorageService.instance.contactRepo.saveCard(card);
      });

      await tester.pumpWidget(
        createTestApp(
          const DigitalCardScreen(initialCardId: 'screen_test_card'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Digital Card'), findsOneWidget);
      expect(find.text('Deepak Chawla'), findsWidgets);
      expect(find.text('Recommended for Your Trade'), findsOneWidget);
      expect(find.text('All Templates'), findsOneWidget);
      expect(find.text('Share on WhatsApp (4:5 Card)'), findsOneWidget);
      expect(find.text('Offline Contact QR Code'), findsOneWidget);

      // Tap on a different template in the carousel
      await tester.tap(find.text('All Templates'));
      await tester.pumpAndSettle();
      expect(find.text('20/20 Templates'), findsOneWidget);
    });
  });
}
