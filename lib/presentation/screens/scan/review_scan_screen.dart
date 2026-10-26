import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/category.dart';
import '../../../data/models/contact_card.dart';
import '../../../data/models/extracted_card_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/services/voice_memo_service.dart';
import '../../widgets/reminders/add_edit_reminder_sheet.dart';
import '../../widgets/voice_memo/voice_memo_widget.dart';

class ReviewScanScreen extends StatefulWidget {
  final ExtractedCardData? initialData;
  final VoiceMemoService? voiceMemoService;

  const ReviewScanScreen({
    super.key,
    this.initialData,
    this.voiceMemoService,
  });

  @override
  State<ReviewScanScreen> createState() => _ReviewScanScreenState();
}

class _ReviewScanScreenState extends State<ReviewScanScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _addressController;
  late final TextEditingController _gstinController;
  late final TextEditingController _notesController;

  String _selectedCategoryId = 'retail';
  List<Category> _availableCategories = [];
  String? _voiceMemoPath;
  final List<String> _tags = [];

  ContactCard? _detectedDuplicate;
  bool _isSaving = false;

  final List<String> _suggestedTags = [
    '#MetAtExhibition',
    '#WholesaleDeal',
    '#SendCatalog',
    '#FollowUp',
    '#VIPClient',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData ?? const ExtractedCardData();

    _nameController = TextEditingController(text: data.name);
    _companyController = TextEditingController(text: data.company);
    _jobTitleController = TextEditingController(text: data.jobTitle);
    _phoneController = TextEditingController(
      text: data.phones.isNotEmpty ? data.phones.first : '',
    );
    _emailController = TextEditingController(text: data.email);
    _websiteController = TextEditingController(text: data.website);
    _addressController = TextEditingController(text: data.address);
    _gstinController = TextEditingController(text: data.gstin);
    _notesController = TextEditingController();

    _loadCategories(data.suggestedCategoryId);

    final initialName = _nameController.text.trim();
    final initialPhone = _phoneController.text.trim();
    _lastCheckedName = initialName;
    _lastCheckedPhone = initialPhone;
    if (initialName.length >= 3 || initialPhone.length >= 5) {
      _detectedDuplicate = StorageService.instance.contactRepo.findDuplicate(
        name: initialName,
        phones: initialPhone.isNotEmpty ? [initialPhone] : [],
      );
    }

    _nameController.addListener(_checkForDuplicates);
    _phoneController.addListener(_checkForDuplicates);
  }

  String _lastCheckedName = '';
  String _lastCheckedPhone = '';

  @override
  void dispose() {
    _nameController.removeListener(_checkForDuplicates);
    _phoneController.removeListener(_checkForDuplicates);
    _nameController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadCategories(String? suggestedId) {
    _availableCategories = StorageService.instance.categoryRepo.getAllCategories();
    if (_availableCategories.isEmpty) {
      _availableCategories = Category.defaultCategories;
    }

    if (suggestedId != null &&
        _availableCategories.any((c) => c.id == suggestedId)) {
      _selectedCategoryId = suggestedId;
    } else if (_availableCategories.isNotEmpty) {
      _selectedCategoryId = _availableCategories.first.id;
    }
  }

  void _checkForDuplicates() {
    if (!mounted) return;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name == _lastCheckedName && phone == _lastCheckedPhone) {
      return;
    }
    _lastCheckedName = name;
    _lastCheckedPhone = phone;

    if (name.length < 3 && phone.length < 5) {
      if (_detectedDuplicate != null) {
        setState(() => _detectedDuplicate = null);
      }
      return;
    }

    final dup = StorageService.instance.contactRepo.findDuplicate(
      name: name,
      phones: phone.isNotEmpty ? [phone] : [],
    );

    if (dup?.id != _detectedDuplicate?.id) {
      setState(() => _detectedDuplicate = dup);
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_tags.contains(tag)) {
        _tags.remove(tag);
      } else {
        _tags.add(tag);
      }
    });
  }

  Future<void> _handleSave({bool overwriteExisting = false}) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for this contact'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final phone = _phoneController.text.trim();
      final phonesList = phone.isNotEmpty ? [phone] : <String>[];

      final cardId = (overwriteExisting && _detectedDuplicate != null)
          ? _detectedDuplicate!.id
          : const Uuid().v4();

      final card = ContactCard(
        id: cardId,
        name: name,
        company: _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        phones: phonesList,
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),
        address: _addressController.text.trim(),
        gstin: _gstinController.text.trim(),
        categoryId: _selectedCategoryId,
        voiceMemoPath: _voiceMemoPath,
        notes: _notesController.text.trim(),
        tags: _tags,
        photoFrontPath: widget.initialData?.photoFrontPath,
        photoBackPath: widget.initialData?.photoBackPath,
        createdAt: (overwriteExisting && _detectedDuplicate != null)
            ? _detectedDuplicate!.createdAt
            : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Hive
      await StorageService.instance.contactRepo.saveCard(card);
      // Increment category count
      await StorageService.instance.categoryRepo.updateCardCount(_selectedCategoryId, 1);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final savedCardId = card.id;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              overwriteExisting ? 'Contact updated successfully!' : 'Contact saved successfully!',
            ),
            backgroundColor: AppColors.forestGreen,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: l10n.scheduleNow,
              textColor: AppColors.saffron,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddEditReminderSheet(initialContactId: savedCardId),
                );
              },
            ),
          ),
        );
        // Navigate back to cards list
        if (GoRouter.maybeOf(context) != null) {
          context.go('/cards');
        } else {
          Navigator.of(context).maybePop();
        }
      }
    } catch (e) {
      debugPrint('Error saving contact card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving card: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = widget.initialData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reviewTitle, style: AppTypography.titleMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              if (GoRouter.maybeOf(context) != null) {
                context.go('/');
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Status Attention Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.saffronContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.saffron.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lightbulb, color: AppColors.tertiary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart OCR extracted details',
                          style: AppTypography.labelLarge(color: AppColors.tertiary),
                        ),
                        Text(
                          'Review and confirm information before saving',
                          style: AppTypography.bodySmall(color: AppColors.tertiary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Smart Duplicate Alert Banner (if duplicate found)
            if (_detectedDuplicate != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Possible Duplicate Detected!',
                            style: AppTypography.titleMedium(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'A contact matching this name or phone already exists: "${_detectedDuplicate!.name}" (${_detectedDuplicate!.company.isNotEmpty ? _detectedDuplicate!.company : 'No company'}).',
                      style: AppTypography.bodySmall(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _isSaving ? null : () => _handleSave(overwriteExisting: true),
                            child: const Text('Update Existing'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.forestGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _isSaving ? null : () => _handleSave(overwriteExisting: false),
                            child: const Text('Save as New'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 3. Captured Card Photo Thumbnails
            if (data?.photoFrontPath != null || data?.photoBackPath != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.photo_camera_outlined, size: 18, color: AppColors.forestGreen),
                              const SizedBox(width: 6),
                              Text('Captured Business Card', style: AppTypography.labelLarge()),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              if (GoRouter.maybeOf(context) != null) {
                                context.pop();
                              } else {
                                Navigator.of(context).maybePop();
                              }
                            },
                            child: Text(l10n.retakePhoto, style: AppTypography.labelSmall(color: AppColors.forestGreen)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (data?.photoFrontPath != null)
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(data!.photoFrontPath!),
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (data?.photoFrontPath != null && data?.photoBackPath != null)
                            const SizedBox(width: 10),
                          if (data?.photoBackPath != null)
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(data!.photoBackPath!),
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 4. Extracted Editable Fields Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Extracted Details', style: AppTypography.titleMedium()),
                    const SizedBox(height: 16),

                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.fullName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Company Name
                    TextFormField(
                      controller: _companyController,
                      decoration: InputDecoration(
                        labelText: l10n.company,
                        prefixIcon: const Icon(Icons.business_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Job Title / Role
                    TextFormField(
                      controller: _jobTitleController,
                      decoration: InputDecoration(
                        labelText: l10n.jobTitle,
                        prefixIcon: const Icon(Icons.work_outline),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Email Address
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Website URL
                    TextFormField(
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Website',
                        prefixIcon: Icon(Icons.language_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // GSTIN / Tax ID
                    TextFormField(
                      controller: _gstinController,
                      decoration: InputDecoration(
                        labelText: l10n.gstin,
                        prefixIcon: const Icon(Icons.receipt_long_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Business Address
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: l10n.address,
                        prefixIcon: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Selector Dropdown
                    Text(l10n.category, style: AppTypography.labelLarge()),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedCategoryId,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category_outlined),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _availableCategories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Text(
                            '${cat.nameEn} (${cat.nameHi})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategoryId = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Voice Memo Attachment Widget
            VoiceMemoWidget(
              service: widget.voiceMemoService,
              initialMemoPath: _voiceMemoPath,
              onMemoChanged: (path) => setState(() => _voiceMemoPath = path),
            ),
            const SizedBox(height: 16),

            // 6. Interaction Notes & Quick Tags
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.notes, style: AppTypography.titleMedium()),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Where you met, context of meeting, or promise made...',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Quick Tags', style: AppTypography.labelMedium()),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _suggestedTags.map((tag) {
                        final isSelected = _tags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          selectedColor: AppColors.surfaceSage,
                          checkmarkColor: AppColors.forestGreen,
                          labelStyle: AppTypography.labelSmall(
                            color: isSelected ? AppColors.forestGreen : AppColors.textSecondary,
                          ),
                          onSelected: (_) => _toggleTag(tag),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 7. Primary Action Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.forestGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isSaving ? null : () => _handleSave(overwriteExisting: false),
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                _isSaving ? 'Saving...' : l10n.saveCard,
                style: AppTypography.labelLarge(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
