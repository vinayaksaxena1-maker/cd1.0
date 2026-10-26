import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<String> default20Categories = [
    'Retail',
    'Food & Beverage',
    'Healthcare',
    'Education',
    'IT & Software',
    'Finance & Banking',
    'Real Estate',
    'Manufacturing',
    'Wholesale & Trade',
    'Transport & Logistics',
    'Agriculture',
    'Legal & Advisory',
    'Professional Services',
    'Marketing & Media',
    'Hospitality & Tourism',
    'Beauty & Wellness',
    'Home Services',
    'Automotive',
    'Govt & NGO',
    'Other Commercial',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCategories, style: AppTypography.headlineMedium()),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: default20Categories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final cat = default20Categories[index];
          return Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSage,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${index + 1}', style: AppTypography.labelLarge(color: AppColors.forestGreen)),
              ),
              title: Text(cat, style: AppTypography.titleMedium()),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.canvasIvory,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text('0 Cards', style: AppTypography.labelSmall(color: AppColors.textSecondary)),
              ),
            ),
          );
        },
      ),
    );
  }
}
