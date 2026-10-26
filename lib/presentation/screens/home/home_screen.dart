import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: AppTypography.headlineMedium(color: AppColors.forestGreen),
        ),
        actions: [
          // Bilingual Language Toggle Pill
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ActionChip(
              avatar: const Icon(Icons.language, size: 16, color: AppColors.forestGreen),
              label: Text(
                localeController.isHindi ? 'हिन्दी' : 'EN',
                style: AppTypography.labelSmall(color: AppColors.forestGreen),
              ),
              backgroundColor: AppColors.surfaceSage,
              side: const BorderSide(color: AppColors.borderSubtle),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
              onPressed: () => localeController.toggleLocale(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stitch Hero Scan Action Card
            Card(
              color: AppColors.forestGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appTagline,
                      style: AppTypography.bodyMedium(color: AppColors.surfaceSage),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.canvasIvory,
                        foregroundColor: AppColors.forestGreen,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => context.push('/scan'),
                      icon: const Icon(Icons.camera_alt_rounded, color: AppColors.forestGreen),
                      label: Text(
                        l10n.scanCardButton,
                        style: AppTypography.labelLarge(color: AppColors.forestGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSage,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.credit_card, color: AppColors.forestGreen, size: 20),
                          ),
                          const SizedBox(height: 12),
                          Text('0', style: AppTypography.headlineMedium()),
                          Text(l10n.navCards, style: AppTypography.bodySmall()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0, width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.saffronContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.event, color: AppColors.saffron, size: 20),
                          ),
                          const SizedBox(height: 12),
                          Text('0', style: AppTypography.headlineMedium()),
                          Text(l10n.navReminders, style: AppTypography.bodySmall()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Cards Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.recentCards, style: AppTypography.titleMedium()),
                TextButton(
                  onPressed: () => context.go('/cards'),
                  child: Text(l10n.viewAll, style: AppTypography.labelSmall(color: AppColors.forestGreen)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Empty Data State
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                child: Column(
                  children: [
                    const Icon(Icons.contact_mail_outlined, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text(l10n.noCardsYet, style: AppTypography.bodyMedium()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
