import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class CameraDisclosureDialog extends StatelessWidget {
  final VoidCallback onAgree;
  final VoidCallback onUseGallery;

  const CameraDisclosureDialog({
    super.key,
    required this.onAgree,
    required this.onUseGallery,
  });

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onAgree,
    required VoidCallback onUseGallery,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CameraDisclosureDialog(
        onAgree: onAgree,
        onUseGallery: onUseGallery,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.canvasIvory,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceSage,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield_outlined, color: AppColors.forestGreen, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.cameraDisclosureTitle,
              style: AppTypography.titleMedium(color: AppColors.forestGreen),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cameraDisclosure,
            style: AppTypography.bodyMedium(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSage.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, size: 18, color: AppColors.forestGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.offlinePrivacyNotice,
                    style: AppTypography.labelSmall(color: AppColors.forestGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onUseGallery();
          },
          child: Text(
            l10n.useGalleryOnly,
            style: AppTypography.labelMedium(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forestGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            onAgree();
          },
          child: Text(
            l10n.agreeAndEnable,
            style: AppTypography.labelMedium(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
