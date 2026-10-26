import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navReminders, style: AppTypography.headlineMedium()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.saffronContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.event_available, size: 48, color: AppColors.saffron),
              ),
              const SizedBox(height: 20),
              Text(l10n.noMeetingsToday, style: AppTypography.titleMedium(), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                l10n.upcomingMeetings,
                style: AppTypography.bodyMedium(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
