import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Google Play 2026 Compliant Prominent Disclosure Dialog for Exact Alarms & Notifications
class AlarmDisclosureDialog extends StatelessWidget {
  const AlarmDisclosureDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlarmDisclosureDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surfaceCard,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.saffronContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.alarm_on_rounded, color: AppColors.saffron, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.notificationDisclosureTitle,
              style: AppTypography.titleMedium().copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(
        l10n.notificationDisclosureMessage,
        style: AppTypography.bodyMedium().copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forestGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(l10n.allowPermission),
        ),
      ],
    );
  }
}
