import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/meeting_reminder.dart';
import '../../../l10n/app_localizations.dart';

/// Formatting and status badge helper for Meeting Reminder widgets
class ReminderDateBadgeHelper {
  static String formatDateTime(BuildContext context, DateTime dt) {
    final now = DateTime.now();
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final timeStr = DateFormat('hh:mm a').format(dt);

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return '${isHi ? "आज" : "Today"}, $timeStr';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (dt.year == tomorrow.year && dt.month == tomorrow.month && dt.day == tomorrow.day) {
      return '${isHi ? "कल" : "Tomorrow"}, $timeStr';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year && dt.month == yesterday.month && dt.day == yesterday.day) {
      return '${isHi ? "कल (बीता हुआ)" : "Yesterday"}, $timeStr';
    }
    return '${DateFormat('dd MMM yyyy').format(dt)}, $timeStr';
  }

  static Widget buildStatusBadge(BuildContext context, MeetingReminder reminder, AppLocalizations l10n) {
    final now = DateTime.now();
    final isHi = Localizations.localeOf(context).languageCode == 'hi';

    if (reminder.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surfaceSage,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
            const SizedBox(width: 4),
            Text(
              l10n.completedTab,
              style: AppTypography.labelSmall().copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (reminder.dateTime.isBefore(now)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.error),
            const SizedBox(width: 4),
            Text(
              l10n.overdueTab,
              style: AppTypography.labelSmall().copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    final isToday = reminder.dateTime.year == now.year &&
        reminder.dateTime.month == now.month &&
        reminder.dateTime.day == now.day;

    if (isToday) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.saffronContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_rounded, size: 12, color: AppColors.saffron),
            const SizedBox(width: 4),
            Text(
              isHi ? 'आज' : 'Today',
              style: AppTypography.labelSmall().copyWith(
                color: AppColors.tertiary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.upcomingTab,
        style: AppTypography.labelSmall().copyWith(
          color: AppColors.forestGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
