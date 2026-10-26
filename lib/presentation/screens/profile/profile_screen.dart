import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteConfirmTitle, style: AppTypography.titleMedium(color: AppColors.error)),
        content: Text(l10n.deleteConfirmMessage, style: AppTypography.bodyMedium()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel, style: AppTypography.labelLarge(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(100, 44),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.error,
                  content: Text('${l10n.deleteAccountData} - ${l10n.success}'),
                ),
              );
            },
            child: Text(l10n.confirm, style: AppTypography.labelLarge(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AppTypography.headlineMedium()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Digital Card Teaser
          Card(
            color: AppColors.surfaceSage,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: AppColors.forestGreen,
                child: Icon(Icons.qr_code, color: Colors.white),
              ),
              title: Text('My Digital Card (vCard)', style: AppTypography.titleMedium()),
              subtitle: Text('NFC & QR Offline Sharing', style: AppTypography.bodySmall()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.forestGreen),
              onTap: () => context.push('/digital-card'),
            ),
          ),
          const SizedBox(height: 16),

          // Categories Hub Link
          Card(
            child: ListTile(
              leading: const Icon(Icons.category_rounded, color: AppColors.forestGreen),
              title: Text(l10n.navCategories, style: AppTypography.titleMedium()),
              subtitle: const Text('20 Business Categories & Custom tags'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              onTap: () => context.push('/categories'),
            ),
          ),
          const SizedBox(height: 12),

          // Bilingual Language Selector
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: AppColors.forestGreen),
              title: Text(l10n.languageToggle, style: AppTypography.titleMedium()),
              subtitle: Text(localeController.isHindi ? 'वर्तमान: हिन्दी' : 'Current: English', style: AppTypography.bodySmall()),
              trailing: Switch.adaptive(
                value: localeController.isHindi,
                activeThumbColor: AppColors.forestGreen,
                onChanged: (_) => localeController.toggleLocale(),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Google Play 2026 Mandatory Account Deletion Section (Section 4.4)
          Card(
            color: AppColors.errorContainer.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.error, width: 0.8),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
              title: Text(
                l10n.deleteAccountData,
                style: AppTypography.labelLarge(color: AppColors.error),
              ),
              subtitle: Text(
                'Google Play Policy (2026) 1-Click Data Erasure',
                style: AppTypography.bodySmall(color: AppColors.error),
              ),
              onTap: () => _showDeleteAccountDialog(context, l10n),
            ),
          ),
        ],
      ),
    );
  }
}
