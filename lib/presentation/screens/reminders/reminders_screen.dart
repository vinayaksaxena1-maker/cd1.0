import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/meeting_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/reminders/add_edit_reminder_sheet.dart';
import '../../widgets/reminders/meeting_reminder_card.dart';
import '../../widgets/reminders/meeting_reminder_skeleton.dart';

/// Reminders & Meeting Scheduler Hub Screen (3 Tabs & 5-State Resilience)
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isLoading = true;
  bool _showCompleted = false;

  List<MeetingReminder> _todayList = [];
  List<MeetingReminder> _upcomingList = [];
  List<MeetingReminder> _overdueList = [];
  List<MeetingReminder> _completedList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReminders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadReminders() {
    final repo = StorageService.instance.reminderRepo;
    setState(() {
      _todayList = repo.getTodayReminders();
      _upcomingList = repo.getUpcomingReminders();
      _overdueList = repo.getOverdueReminders();
      _completedList = repo.getCompletedReminders();
      _isLoading = false;
    });
  }

  Future<void> _toggleCompleted(MeetingReminder reminder) async {
    await StorageService.instance.reminderRepo.toggleCompleted(reminder.id);
    _loadReminders();
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
      await StorageService.instance.reminderRepo.deleteReminder(reminder.id);
      _loadReminders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.meetingDeleted),
            backgroundColor: AppColors.forestGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _openAddEditSheet({MeetingReminder? reminder}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditReminderSheet(
        reminder: reminder,
        onSaved: (_) => _loadReminders(),
      ),
    );
  }

  Widget _buildTabItem(String label, int count, {Color? badgeColor}) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.forestGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = AppColors.forestGreen,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.titleMedium().copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTypography.bodyMedium().copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderList(List<MeetingReminder> items, {required Widget emptyState}) {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (_, _) => const MeetingReminderSkeleton(),
      );
    }

    if (items.isEmpty && (!_showCompleted || _completedList.isEmpty)) {
      return emptyState;
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        if (items.isEmpty) emptyState,
        ...items.map(
          (rem) => MeetingReminderCard(
            key: ValueKey(rem.id),
            reminder: rem,
            onToggleCompleted: () => _toggleCompleted(rem),
            onEdit: () => _openAddEditSheet(reminder: rem),
            onDelete: () => _confirmDelete(rem),
          ),
        ),
        if (_showCompleted && _completedList.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                  '${AppLocalizations.of(context)!.completedTab} (${_completedList.length})',
                  style: AppTypography.labelLarge().copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Expanded(child: Divider(indent: 12, color: AppColors.borderSubtle)),
              ],
            ),
          ),
          ..._completedList.map(
            (rem) => MeetingReminderCard(
              key: ValueKey(rem.id),
              reminder: rem,
              onToggleCompleted: () => _toggleCompleted(rem),
              onEdit: () => _openAddEditSheet(reminder: rem),
              onDelete: () => _confirmDelete(rem),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.canvasIvory,
      appBar: AppBar(
        title: Text(l10n.navReminders, style: AppTypography.headlineMedium()),
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: _showCompleted ? AppColors.forestGreen : AppColors.secondary,
            ),
            tooltip: l10n.completedTab,
            onPressed: () => setState(() => _showCompleted = !_showCompleted),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.forestGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.forestGreen,
          indicatorWeight: 3,
          labelStyle: AppTypography.labelMedium().copyWith(fontWeight: FontWeight.bold),
          tabs: [
            _buildTabItem(l10n.todayTab, _todayList.length, badgeColor: AppColors.saffron),
            _buildTabItem(l10n.upcomingTab, _upcomingList.length, badgeColor: AppColors.forestGreen),
            _buildTabItem(l10n.overdueTab, _overdueList.length, badgeColor: AppColors.error),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Today Tab
          _buildReminderList(
            _todayList,
            emptyState: _buildEmptyState(
              icon: Icons.event_available_rounded,
              title: l10n.noMeetingsToday,
              subtitle: 'No meetings scheduled for today.',
              iconColor: AppColors.saffron,
            ),
          ),

          // Upcoming Tab
          _buildReminderList(
            _upcomingList,
            emptyState: _buildEmptyState(
              icon: Icons.upcoming_rounded,
              title: l10n.noMeetingsScheduled,
              subtitle: 'Your calendar is free. Tap + to schedule.',
              iconColor: AppColors.forestGreen,
            ),
          ),

          // Overdue Tab
          _buildReminderList(
            _overdueList,
            emptyState: _buildEmptyState(
              icon: Icons.task_alt_rounded,
              title: 'All Caught Up!',
              subtitle: 'No overdue follow-up meetings.',
              iconColor: AppColors.success,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditSheet(),
        backgroundColor: AppColors.forestGreen,
        foregroundColor: Colors.white,
        tooltip: l10n.addMeeting,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
