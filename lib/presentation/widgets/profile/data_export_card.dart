import 'package:flutter/material.dart';
import '../../../core/services/data_export_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../l10n/app_localizations.dart';

/// Card component offering 1-click JSON offline backup and multi-vCard export
class DataExportCard extends StatelessWidget {
  const DataExportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalCards = StorageService.instance.contactRepo.getAllCards().length;

    return Card(
      color: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.archive_outlined, color: AppColors.forestGreen, size: 22),
                const SizedBox(width: 8),
                Text(l10n.backupAndExport, style: AppTypography.titleMedium()),
              ],
            ),
            const SizedBox(height: 12),

            // Offline Full JSON Backup Tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSage,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.file_download_outlined, color: AppColors.forestGreen, size: 20),
              ),
              title: Text(l10n.exportJsonBackup, style: AppTypography.titleMedium(color: AppColors.textPrimary)),
              subtitle: Text(l10n.exportJsonSubtitle, style: AppTypography.bodySmall()),
              trailing: const Icon(Icons.share_outlined, size: 20, color: AppColors.textSecondary),
              onTap: () async {
                final success = await DataExportService.instance.exportAllDataAsJson();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? l10n.success : l10n.error),
                    backgroundColor: success ? AppColors.forestGreen : AppColors.error,
                  ),
                );
              },
            ),
            const Divider(height: 16),

            // Multi-Contact vCard (.vcf) Export Tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSage,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.contacts_outlined, color: AppColors.forestGreen, size: 20),
              ),
              title: Text(l10n.exportVcfContacts, style: AppTypography.titleMedium(color: AppColors.textPrimary)),
              subtitle: Text(
                '$totalCards Cards · ${l10n.exportVcfSubtitle}',
                style: AppTypography.bodySmall(),
              ),
              trailing: const Icon(Icons.share_outlined, size: 20, color: AppColors.textSecondary),
              onTap: () async {
                if (totalCards == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.noMatchingCards),
                      backgroundColor: AppColors.textSecondary,
                    ),
                  );
                  return;
                }
                final success = await DataExportService.instance.exportAllContactsAsVCard();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? l10n.success : l10n.error),
                    backgroundColor: success ? AppColors.forestGreen : AppColors.error,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
