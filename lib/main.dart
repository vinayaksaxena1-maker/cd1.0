import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/locale_controller.dart';
import 'core/services/notification_service.dart';
import 'core/services/firebase_service.dart';
import 'data/local/storage_service.dart';
import 'data/models/contact_card.dart';
import 'data/models/meeting_reminder.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.initAll();
  await NotificationService.instance.init();
  await FirebaseService.instance.init();

  if (StorageService.instance.contactRepo.getAllCards().isEmpty) {
    final now = DateTime.now();
    final demoCard = ContactCard(
      id: 'demo_card_1',
      name: 'Rajesh Sharma',
      jobTitle: 'Managing Director',
      company: 'Apex Logistics & Transport',
      categoryId: 'transport',
      phones: ['+91 98765 43210'],
      email: 'rajesh@apexlogistics.in',
      website: 'www.apexlogistics.in',
      address: 'Plot 42, Transport Nagar, Jaipur, Rajasthan',
      gstin: '08AAAAA0000A1Z5',
      tags: ['Logistics', 'VIP Client'],
      notes: 'Key partner for North India freight corridors',
      createdAt: now,
      updatedAt: now,
    );
    await StorageService.instance.contactRepo.saveCard(demoCard);

    // Also link the meeting if exists or seed a linked meeting
    if (StorageService.instance.reminderRepo.getAllReminders().isEmpty) {
      final demoMeeting = MeetingReminder(
        id: 'meeting_demo_1',
        title: 'Q4 Contract Review',
        agenda: 'Review transport routes and renew annual contract',
        dateTime: now.add(const Duration(hours: 3)),
        contactCardId: 'demo_card_1',
        notificationId: 1001,
        createdAt: now,
      );
      await StorageService.instance.reminderRepo.saveReminder(demoMeeting);
      await NotificationService.instance.scheduleMeetingNotification(
        demoMeeting,
        contact: demoCard,
      );
    }
  }

  runApp(const CardSaathiApp());
}

class CardSaathiApp extends StatelessWidget {
  const CardSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'CardSaathi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: localeController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
