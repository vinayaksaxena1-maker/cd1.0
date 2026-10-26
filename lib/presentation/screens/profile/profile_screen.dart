import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/services/cloud_sync_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/local/storage_service.dart';
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
            onPressed: () async {
              Navigator.of(ctx).pop();
              // Wipe local storage
              await StorageService.instance.contactRepo.clearAllCards();
              await StorageService.instance.reminderRepo.clearAllReminders();
              // Wipe cloud storage
              await CloudSyncService.instance.wipeUserData();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.error,
                    content: Text('${l10n.deleteAccountData} - ${l10n.success}'),
                  ),
                );
              }
            },
            child: Text(l10n.confirm, style: AppTypography.labelLarge(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context, AppLocalizations l10n) {
    final syncService = CloudSyncService.instance;
    final fbService = FirebaseService.instance;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderSubtle.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceSage,
                  child: Icon(Icons.cloud_sync_rounded, color: AppColors.forestGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Google Firebase Cloud Backup',
                        style: AppTypography.titleMedium(),
                      ),
                      ValueListenableBuilder<SyncStatus>(
                        valueListenable: syncService.status,
                        builder: (context, status, _) {
                          String statusText;
                          Color statusColor;

                          switch (status) {
                            case SyncStatus.syncing:
                              statusText = l10n.syncStatusSyncing;
                              statusColor = Colors.orange;
                              break;
                            case SyncStatus.synced:
                              statusText = l10n.syncStatusSynced;
                              statusColor = AppColors.forestGreen;
                              break;
                            case SyncStatus.error:
                              statusText = l10n.syncStatusError;
                              statusColor = AppColors.error;
                              break;
                            case SyncStatus.offline:
                            case SyncStatus.idle:
                              statusText = fbService.isAvailable
                                  ? 'Cloud Backup Active'
                                  : l10n.syncStatusOffline;
                              statusColor = AppColors.textSecondary;
                              break;
                          }

                          return Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusText,
                                style: AppTypography.bodySmall(color: statusColor),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<SyncStatus>(
                  valueListenable: syncService.status,
                  builder: (context, status, _) {
                    final isSyncing = status == SyncStatus.syncing;
                    return ElevatedButton(
                      onPressed: isSyncing
                          ? null
                          : () async {
                              final success = await syncService.syncAll(force: true);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success ? l10n.syncStatusSynced : l10n.syncStatusError,
                                    ),
                                    backgroundColor: success ? AppColors.forestGreen : AppColors.error,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forestGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: const Size(80, 36),
                      ),
                      child: isSyncing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(l10n.syncNow, style: AppTypography.labelLarge(color: Colors.white)),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<DateTime?>(
              valueListenable: syncService.lastSyncedAt,
              builder: (context, lastSync, _) {
                final text = lastSync != null
                    ? 'Last synced: ${lastSync.hour.toString().padLeft(2, '0')}:${lastSync.minute.toString().padLeft(2, '0')}'
                    : 'Auto-syncs local cards & reminders with Firebase Cloud';
                return Text(text, style: AppTypography.bodySmall(color: AppColors.textSecondary));
              },
            ),
          ],
        ),
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

          // Google Firebase Cloud Sync Card
          _buildSyncCard(context, l10n),
          const SizedBox(height: 12),

          // Bilingual Language Selector
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: AppColors.forestGreen),
              title: Text(l10n.languageToggle, style: AppTypography.titleMedium()),
              subtitle: Text(
                localeController.isHindi ? 'वर्तमान: हिन्दी' : 'Current: English',
                style: AppTypography.bodySmall(),
              ),
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
