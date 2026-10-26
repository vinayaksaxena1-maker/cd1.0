import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/contact_card.dart';
import '../../../data/models/meeting_reminder.dart';
import '../../../l10n/app_localizations.dart';

/// Modal Bottom Sheet to Schedule or Edit a Meeting Reminder
class AddEditReminderSheet extends StatefulWidget {
  final MeetingReminder? reminder;
  final String? initialContactId;
  final void Function(MeetingReminder reminder)? onSaved;

  const AddEditReminderSheet({
    super.key,
    this.reminder,
    this.initialContactId,
    this.onSaved,
  });

  @override
  State<AddEditReminderSheet> createState() => _AddEditReminderSheetState();
}

class _AddEditReminderSheetState extends State<AddEditReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _agendaController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String? _selectedContactId;
  List<ContactCard> _availableContacts = [];

  @override
  void initState() {
    super.initState();
    final rem = widget.reminder;
    _titleController = TextEditingController(text: rem?.title ?? '');
    _agendaController = TextEditingController(text: rem?.agenda ?? '');

    final initialDt = rem?.dateTime ?? DateTime.now().add(const Duration(hours: 1));
    _selectedDate = DateTime(initialDt.year, initialDt.month, initialDt.day);
    _selectedTime = TimeOfDay(hour: initialDt.hour, minute: initialDt.minute);
    _selectedContactId = rem?.contactCardId ?? widget.initialContactId;

    _loadContacts();
  }

  void _loadContacts() {
    _availableContacts = StorageService.instance.contactRepo.getAllCards();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _agendaController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.forestGreen,
              onPrimary: Colors.white,
              surface: AppColors.surfaceCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.forestGreen,
              onPrimary: Colors.white,
              surface: AppColors.surfaceCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final notificationId = widget.reminder?.notificationId ??
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    final reminder = MeetingReminder(
      id: widget.reminder?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      dateTime: scheduledDateTime,
      agenda: _agendaController.text.trim(),
      contactCardId: _selectedContactId,
      notificationId: notificationId,
      isCompleted: widget.reminder?.isCompleted ?? false,
      createdAt: widget.reminder?.createdAt ?? DateTime.now(),
    );

    await StorageService.instance.reminderRepo.saveReminder(reminder);

    if (widget.onSaved != null) {
      widget.onSaved!(reminder);
    }

    if (mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, reminder);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.meetingSaved),
          backgroundColor: AppColors.forestGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.reminder != null;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                isEditing ? l10n.editMeeting : l10n.addMeeting,
                style: AppTypography.headlineMedium().copyWith(color: AppColors.forestGreen),
              ),
              const SizedBox(height: 16),

              // Meeting Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.meetingTitle,
                  hintText: 'e.g. Price Negotiation / Sample Review',
                  prefixIcon: const Icon(Icons.title_rounded, color: AppColors.forestGreen),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.forestGreen, width: 2),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n.titleRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Date & Time Selectors Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_month_rounded, size: 18),
                      label: Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: AppTypography.labelMedium().copyWith(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.schedule_rounded, size: 18),
                      label: Text(
                        _selectedTime.format(context),
                        style: AppTypography.labelMedium().copyWith(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Linked Contact Dropdown
              DropdownButtonFormField<String?>(
                initialValue: _selectedContactId,
                decoration: InputDecoration(
                  labelText: l10n.linkContact,
                  prefixIcon: const Icon(Icons.person_pin_rounded, color: AppColors.forestGreen),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.forestGreen, width: 2),
                  ),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.noLinkedContact, style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  ..._availableContacts.map(
                    (c) => DropdownMenuItem<String?>(
                      value: c.id,
                      child: Text(
                        c.company.isNotEmpty ? '${c.name} (${c.company})' : c.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedContactId = val),
              ),
              const SizedBox(height: 14),

              // Agenda Field
              TextFormField(
                controller: _agendaController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.agenda,
                  alignLabelWithHint: true,
                  hintText: 'e.g. Discuss wholesale payment terms & delivery timelines',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.notes_rounded, color: AppColors.forestGreen),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.forestGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  isEditing ? l10n.saveChanges : l10n.addMeeting,
                  style: AppTypography.titleMedium().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
