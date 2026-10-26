import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/category.dart';
import '../../../data/models/contact_card.dart';
import '../../../l10n/app_localizations.dart';

class CardEditScreen extends StatefulWidget {
  final String cardId;

  const CardEditScreen({super.key, required this.cardId});

  @override
  State<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isDirty = false;
  ContactCard? _originalCard;

  late final TextEditingController _nameController;
  late final TextEditingController _companyController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _primaryPhoneController;
  late final TextEditingController _secondaryPhoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _gstinController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  String _selectedCategoryId = 'other';
  List<Category> _availableCategories = [];
  final List<String> _tags = [];
  String? _voiceMemoPath;

  static final RegExp _gstinRegex = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _companyController = TextEditingController();
    _jobTitleController = TextEditingController();
    _primaryPhoneController = TextEditingController();
    _secondaryPhoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _gstinController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();

    _loadCardData();
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  Future<void> _loadCardData() async {
    final storage = StorageService.instance;
    final card = storage.contactRepo.getCardById(widget.cardId);
    var categories = storage.categoryRepo.getAllCategories();
    if (categories.isEmpty) {
      await storage.categoryRepo.seedDefaultCategories();
      categories = storage.categoryRepo.getAllCategories();
    }

    if (card != null) {
      _originalCard = card;
      _nameController.text = card.name;
      _companyController.text = card.company;
      _jobTitleController.text = card.jobTitle;
      _primaryPhoneController.text = card.phones.isNotEmpty ? card.phones[0] : '';
      _secondaryPhoneController.text = card.phones.length > 1 ? card.phones[1] : '';
      _emailController.text = card.email;
      _websiteController.text = card.website;
      _gstinController.text = card.gstin;
      _addressController.text = card.address;
      _notesController.text = card.notes;

      _selectedCategoryId = card.categoryId;
      _tags.addAll(card.tags);
      _voiceMemoPath = card.voiceMemoPath;
    }

    if (mounted) {
      setState(() {
        _availableCategories = categories;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _primaryPhoneController.dispose();
    _secondaryPhoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _gstinController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_originalCard == null) return;

    setState(() => _isSaving = true);

    final phones = <String>[];
    final p1 = _primaryPhoneController.text.trim();
    if (p1.isNotEmpty) phones.add(p1);
    final p2 = _secondaryPhoneController.text.trim();
    if (p2.isNotEmpty) phones.add(p2);

    final updatedCard = _originalCard!.copyWith(
      name: _nameController.text.trim(),
      company: _companyController.text.trim(),
      jobTitle: _jobTitleController.text.trim(),
      phones: phones,
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
      gstin: _gstinController.text.trim().toUpperCase(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      categoryId: _selectedCategoryId,
      tags: _tags,
      voiceMemoPath: _voiceMemoPath,
      updatedAt: DateTime.now(),
    );

    await StorageService.instance.contactRepo.saveCard(updatedCard);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cardUpdated),
          backgroundColor: AppColors.forestGreen,
        ),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;
    final l10n = AppLocalizations.of(context)!;

    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.discardChangesConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.discard, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  void _showAddTagDialog() {
    final tagCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addTag),
        content: TextField(
          controller: tagCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. #Supplier or #VIPClient'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              var text = tagCtrl.text.trim();
              if (text.isNotEmpty) {
                if (!text.startsWith('#')) text = '#$text';
                if (!_tags.contains(text)) {
                  setState(() {
                    _tags.add(text);
                    _markDirty();
                  });
                }
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.addCategory),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.forestGreen)),
      );
    }

    if (_originalCard == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editCard)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card_off_outlined, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(l10n.cardNotFound, style: AppTypography.titleMedium()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.canvasIvory,
        appBar: AppBar(
          title: Text(l10n.editCard, style: AppTypography.headlineMedium()),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.forestGreen,
                ),
                onPressed: _isSaving ? null : _saveChanges,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.forestGreen),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  l10n.save,
                  style: AppTypography.labelLarge(color: AppColors.forestGreen),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          onChanged: _markDirty,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Photo Thumbnail Preview (if present)
              if (_originalCard!.photoFrontPath != null &&
                  File(_originalCard!.photoFrontPath!).existsSync())
                _buildPhotoThumbnailCard(),

              // Primary Contact Section
              _buildSectionCard(
                title: 'Primary Information',
                icon: Icons.person_outline_rounded,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Contact Name *',
                      prefixIcon: const Icon(Icons.person, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company / Business Name',
                      prefixIcon: Icon(Icons.business_rounded, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _jobTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Job Title / Designation',
                      prefixIcon: Icon(Icons.badge_outlined, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Phones Section
              _buildSectionCard(
                title: 'Contact Numbers',
                icon: Icons.phone_outlined,
                children: [
                  TextFormField(
                    controller: _primaryPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.phoneRequired : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _secondaryPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.secondaryPhone,
                      prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Online & Tax Details Section
              _buildSectionCard(
                title: 'Digital & Credentials',
                icon: Icons.language_rounded,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                    validator: (v) {
                      if (v != null && v.trim().isNotEmpty && !_emailRegex.hasMatch(v.trim())) {
                        return l10n.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _websiteController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: l10n.website,
                      prefixIcon: const Icon(Icons.link_rounded, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _gstinController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: '15-character GSTIN',
                      prefixIcon: const Icon(Icons.verified_user_outlined, color: AppColors.forestGreen),
                      hintText: 'e.g. 24AAAAA0000A1Z5',
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                    validator: (v) {
                      if (v != null && v.trim().isNotEmpty && !_gstinRegex.hasMatch(v.trim().toUpperCase())) {
                        return l10n.invalidGstin;
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Classification & Commercial Tagging
              _buildSectionCard(
                title: 'Trade & Classification',
                icon: Icons.category_outlined,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Commercial Category',
                      prefixIcon: Icon(Icons.store_mall_directory_rounded, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                    items: _availableCategories.map((cat) {
                      final name = isHindi ? cat.nameHi : cat.nameEn;
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategoryId = val;
                          _markDirty();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Business Address',
                      prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.notes,
                      prefixIcon: const Icon(Icons.note_alt_outlined, color: AppColors.forestGreen),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tags Chip Section
              _buildSectionCard(
                title: l10n.tags,
                icon: Icons.tag_rounded,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._tags.map(
                        (tag) => Chip(
                          label: Text(tag, style: AppTypography.labelSmall(color: AppColors.forestGreen)),
                          backgroundColor: AppColors.surfaceSage,
                          deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.forestGreen),
                          onDeleted: () {
                            setState(() {
                              _tags.remove(tag);
                              _markDirty();
                            });
                          },
                        ),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16, color: AppColors.forestGreen),
                        label: Text(l10n.addTag, style: AppTypography.labelSmall(color: AppColors.forestGreen)),
                        backgroundColor: AppColors.surfaceCard,
                        side: const BorderSide(color: AppColors.forestGreen),
                        onPressed: _showAddTagDialog,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Attached Voice Note Status (if present)
              if (_voiceMemoPath != null && File(_voiceMemoPath!).existsSync())
                Card(
                  color: AppColors.surfaceCard,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSage,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.mic, color: AppColors.forestGreen),
                    ),
                    title: Text(l10n.audioMemo, style: AppTypography.titleMedium()),
                    subtitle: Text('10-second offline audio memo attached', style: AppTypography.bodySmall()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      tooltip: l10n.deleteMemo,
                      onPressed: () {
                        setState(() {
                          _voiceMemoPath = null;
                          _markDirty();
                        });
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Bottom Save Changes Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _isSaving ? null : _saveChanges,
                icon: const Icon(Icons.save_rounded),
                label: Text(l10n.saveChanges, style: AppTypography.labelLarge(color: Colors.white)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.forestGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.titleMedium(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnailCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(_originalCard!.photoFrontPath!),
              width: 80,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Physical Visiting Card Photo', style: AppTypography.titleMedium()),
                Text('Captured from Camera/Gallery', style: AppTypography.labelSmall(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
