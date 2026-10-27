import 'package:flutter/material.dart';
import '../../../core/services/cloud_sync_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../l10n/app_localizations.dart';

/// Google Play Section 4.4 Mandatory 1-Click Complete Data Erasure Dialog
class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onDeleted;

  const DeleteAccountDialog({super.key, required this.onDeleted});

  static Future<void> show(BuildContext context, {required VoidCallback onDeleted}) {
    return showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(onDeleted: onDeleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.deleteConfirmTitle, style: AppTypography.titleMedium(color: AppColors.error)),
      content: Text(l10n.deleteConfirmMessage, style: AppTypography.bodyMedium()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: AppTypography.labelLarge(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            minimumSize: const Size(100, 44),
          ),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();

            // 1. Wipe local Hive storage
            await StorageService.instance.contactRepo.clearAllCards();
            await StorageService.instance.reminderRepo.clearAllReminders();
            await StorageService.instance.userProfileRepo.clearProfile();

            // 2. Wipe cloud Firestore data
            await CloudSyncService.instance.wipeUserData();

            // 3. Sign out Firebase session
            await FirebaseService.instance.signOut();

            onDeleted();
            messenger.showSnackBar(
              SnackBar(
                backgroundColor: AppColors.error,
                content: Text(l10n.dataErasedSuccess),
              ),
            );
          },
          child: Text(l10n.confirm, style: AppTypography.labelLarge(color: Colors.white)),
        ),
      ],
    );
  }
}
