import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/contact_card.dart';
import '../../../data/models/meeting_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../reminders/add_edit_reminder_sheet.dart';
import '../reminders/meeting_reminder_card.dart';

/// Modular Contact-Linked Meetings & Follow-up Section Widget
class CardMeetingsSection extends StatefulWidget {
  final String cardId;
  final ContactCard? card;
  final VoidCallback? onMeetingsUpdated;

  const CardMeetingsSection({
    super.key,
    required this.cardId,
    this.card,
    this.onMeetingsUpdated,
  });

  @override
  State<CardMeetingsSection> createState() => _CardMeetingsSectionState();
}

class _CardMeetingsSectionState extends State<CardMeetingsSection> {
  List<MeetingReminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  @override
  void didUpdateWidget(covariant CardMeetingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cardId != widget.cardId) {
      _loadMeetings();
    }
  }

  void _loadMeetings() {
    final list = StorageService.instance.reminderRepo.getRemindersForContact(widget.cardId);
    setState(() {
      _reminders = list;
      _isLoading = false;
    });
    if (widget.onMeetingsUpdated != null) {
      widget.onMeetingsUpdated!();
    }
  }

  void _openScheduleSheet({MeetingReminder? reminder}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditReminderSheet(
        reminder: reminder,
        initialContactId: widget.cardId,
        onSaved: (_) => _loadMeetings(),
      ),
    );
  }

  Future<void> _toggleCompleted(MeetingReminder reminder) async {
    await StorageService.instance.reminderRepo.toggleCompleted(reminder.id);
    if (!reminder.isCompleted) {
      await NotificationService.instance.cancelMeetingNotification(reminder.notificationId);
    } else {
      await NotificationService.instance.scheduleMeetingNotification(reminder, contact: widget.card);
    }
    _loadMeetings();
  }

  Future<void> _confirmDelete(MeetingReminder reminder) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteMeeting, style: AppTypography.titleMedium()),
        content: Text(l10n.deleteMeetingConfirm, style: AppTypography.bodyMedium()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text(l10n.deleteMeeting),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await NotificationService.instance.cancelMeetingNotification(reminder.notificationId);
      await StorageService.instance.reminderRepo.deleteReminder(reminder.id);
      _loadMeetings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.forestGreen),
                const SizedBox(width: 8),
                Text(
                  l10n.linkedMeetings,
                  style: AppTypography.titleMedium().copyWith(fontWeight: FontWeight.bold),
                ),
                if (_reminders.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSage,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_reminders.length}',
                      style: AppTypography.labelSmall().copyWith(
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.forestGreen),
              tooltip: l10n.scheduleFollowup,
              onPressed: () => _openScheduleSheet(),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Content: Empty State or Reminders List
        if (_reminders.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Column(
              children: [
                const Icon(Icons.event_available_outlined, size: 36, color: AppColors.secondary),
                const SizedBox(height: 8),
                Text(
                  l10n.noLinkedMeetings,
                  style: AppTypography.bodySmall().copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _openScheduleSheet(),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.scheduleFollowup),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.forestGreen,
                    side: const BorderSide(color: AppColors.forestGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reminders.length,
            itemBuilder: (ctx, index) {
              final reminder = _reminders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MeetingReminderCard(
                  key: ValueKey(reminder.id),
                  reminder: reminder,
                  onToggleCompleted: () => _toggleCompleted(reminder),
                  onEdit: () => _openScheduleSheet(reminder: reminder),
                  onDelete: () => _confirmDelete(reminder),
                ),
              );
            },
          ),
      ],
    );
  }
}
