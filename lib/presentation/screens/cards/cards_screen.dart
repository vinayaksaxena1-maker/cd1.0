import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCards, style: AppTypography.headlineMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined, color: AppColors.forestGreen),
            tooltip: l10n.navCategories,
            onPressed: () => context.push('/categories'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Search Input
            TextField(
              decoration: InputDecoration(
                hintText: '${l10n.navCards}...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                fillColor: AppColors.surfaceCard,
              ),
            ),
            const SizedBox(height: 32),
            // Empty State
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.credit_card_off_outlined, size: 56, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(l10n.noCardsYet, style: AppTypography.titleMedium()),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 50),
                      ),
                      onPressed: () => context.push('/scan'),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(l10n.scanCardButton),
                    ),
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
