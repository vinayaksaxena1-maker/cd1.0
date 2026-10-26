import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/user_profile.dart';
import '../../../l10n/app_localizations.dart';

/// Screen allowing users to edit their personal business identity and digital card details
class UserProfileEditScreen extends StatefulWidget {
  const UserProfileEditScreen({super.key});

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _designationController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;

  String? _logoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = StorageService.instance.userProfileRepo.getProfile();
    final fbUser = FirebaseService.instance.currentUser;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _designationController = TextEditingController(text: profile?.designation ?? '');
    _companyController = TextEditingController(text: profile?.company ?? '');
    _phoneController = TextEditingController(
      text: profile?.phone.isNotEmpty == true ? profile!.phone : (fbUser?.phoneNumber ?? ''),
    );
    _emailController = TextEditingController(text: profile?.email ?? '');
    _websiteController = TextEditingController(text: profile?.website ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _logoPath = profile?.logoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _logoPath = picked.path);
      }
    } catch (_) {}
  }

  Future<void> _saveProfile(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    final updated = UserProfile(
      name: _nameController.text.trim(),
      designation: _designationController.text.trim(),
      company: _companyController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
      address: _addressController.text.trim(),
      logoPath: _logoPath,
    );

    await StorageService.instance.userProfileRepo.saveProfile(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdated),
          backgroundColor: AppColors.forestGreen,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Widget _buildAvatarSection(AppLocalizations l10n) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: AppColors.surfaceSage,
            backgroundImage: _logoPath != null && File(_logoPath!).existsSync()
                ? FileImage(File(_logoPath!)) as ImageProvider
                : null,
            child: _logoPath == null || !File(_logoPath!).existsSync()
                ? const Icon(Icons.business_center_rounded, size: 40, color: AppColors.forestGreen)
                : null,
          ),
          InkWell(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.forestGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile, style: AppTypography.headlineMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.forestGreen),
            onPressed: () => _saveProfile(l10n),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAvatarSection(l10n),
            const SizedBox(height: 24),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${l10n.nameRequired} *',
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? l10n.nameRequired : null,
            ),
            const SizedBox(height: 16),

            // Designation & Company
            TextFormField(
              controller: _designationController,
              decoration: const InputDecoration(
                labelText: 'Designation / Role',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company / Business Name',
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Contact details
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.phoneRequired,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.sendEmail,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: l10n.website,
                prefixIcon: const Icon(Icons.language_outlined),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Business Address / City',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 28),

            ElevatedButton.icon(
              onPressed: () => _saveProfile(l10n),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.save_rounded),
              label: Text(l10n.saveChanges, style: AppTypography.titleMedium(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
