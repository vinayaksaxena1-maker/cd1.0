import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class DigitalCardScreen extends StatelessWidget {
  const DigitalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Card (vCard)', style: AppTypography.headlineMedium()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Stitch Digital Card Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.forestGreen,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forestGreen.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.saffron,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('CardSaathi Pro', style: AppTypography.labelSmall(color: Colors.white)),
                      ),
                      const Icon(Icons.nfc, color: Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Vinayak Saxena', style: AppTypography.headlineLarge(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Founder & Software Architect', style: AppTypography.bodyMedium(color: AppColors.surfaceSage)),
                  const Divider(color: Colors.white24, height: 32),
                  Text('contact@cardsaathi.app | +91 98765 43210', style: AppTypography.bodySmall(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 1-Tap Share Actions
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.whatsAppGreeting)),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(l10n.shareOnWhatsApp),
            ),
          ],
        ),
      ),
    );
  }
}
