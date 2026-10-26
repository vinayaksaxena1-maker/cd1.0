import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/contact_card.dart';
import '../../../data/models/meeting_reminder.dart';
import '../../../l10n/app_localizations.dart';
import 'reminder_date_badge_helper.dart';

/// Stitch Design System Meeting Reminder Card Widget
class MeetingReminderCard extends StatelessWidget {
  final MeetingReminder reminder;
  final VoidCallback onToggleCompleted;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MeetingReminderCard({
    super.key,
    required this.reminder,
    required this.onToggleCompleted,
    required this.onEdit,
    required this.onDelete,
  });

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Widget _buildLinkedContact(ContactCard contact) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.forestGreen,
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              contact.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (contact.phones.isNotEmpty) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: () => _makeCall(contact.phones.first),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.phone_rounded, size: 16, color: AppColors.forestGreen),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contact = reminder.contactCardId != null
        ? StorageService.instance.contactRepo.getCardById(reminder.contactCardId!)
        : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: reminder.isCompleted
              ? AppColors.borderSubtle
              : reminder.dateTime.isBefore(DateTime.now())
                  ? AppColors.error.withValues(alpha: 0.4)
                  : AppColors.borderSubtle,
          width: 1,
        ),
      ),
      color: reminder.isCompleted
          ? AppColors.surfaceSage.withValues(alpha: 0.3)
          : AppColors.surfaceCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completion Checkbox
            Checkbox(
              value: reminder.isCompleted,
              onChanged: (_) => onToggleCompleted(),
              activeColor: AppColors.forestGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),

            // Main Details (Tappable for Edit)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onEdit,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            reminder.title,
                            style: AppTypography.titleMedium().copyWith(
                              decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
                              color: reminder.isCompleted
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        ReminderDateBadgeHelper.buildStatusBadge(context, reminder, l10n),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Date & Time
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: reminder.isCompleted
                              ? AppColors.textSecondary
                              : AppColors.forestGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ReminderDateBadgeHelper.formatDateTime(context, reminder.dateTime),
                          style: AppTypography.bodySmall().copyWith(
                            color: reminder.isCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Agenda Note (if available)
                    if (reminder.agenda.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        reminder.agenda,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall().copyWith(
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],

                    // Linked Contact
                    if (contact != null) _buildLinkedContact(contact),
                  ],
                ),
              ),
            ),

            // Popup Actions Menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.secondary),
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 18, color: AppColors.textPrimary),
                      const SizedBox(width: 10),
                      Text(l10n.editMeeting),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                      const SizedBox(width: 10),
                      Text(l10n.deleteMeeting, style: const TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
