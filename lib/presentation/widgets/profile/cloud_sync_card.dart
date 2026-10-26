import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/cloud_sync_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../l10n/app_localizations.dart';

class CloudSyncCard extends StatelessWidget {
  const CloudSyncCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
}
