import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/auth/auth_modal.dart';
import '../../widgets/profile/cloud_sync_card.dart';
import '../../widgets/profile/data_export_card.dart';
import '../../widgets/profile/delete_account_dialog.dart';
import '../../widgets/profile/privacy_policy_modal.dart';
import '../../widgets/reminders/battery_optimization_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildAccountCard(BuildContext context, AppLocalizations l10n) {
    final fbService = FirebaseService.instance;
    final isGuest = fbService.isGuest;
    final user = fbService.currentUser;

    return Card(
      color: isGuest ? AppColors.surfaceSage.withValues(alpha: 0.5) : AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isGuest ? AppColors.forestGreen.withValues(alpha: 0.3) : AppColors.borderSubtle,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isGuest ? AppColors.forestGreen.withValues(alpha: 0.15) : AppColors.forestGreen,
          child: Icon(
            isGuest ? Icons.person_outline_rounded : Icons.verified_user_rounded,
            color: isGuest ? AppColors.forestGreen : Colors.white,
          ),
        ),
        title: Text(
          isGuest ? l10n.guestUser : (user?.phoneNumber ?? 'Signed In'),
          style: AppTypography.titleMedium(),
        ),
        subtitle: Text(
          isGuest ? l10n.guestMode : 'Verified Phone Account',
          style: AppTypography.bodySmall(
            color: isGuest ? AppColors.textSecondary : AppColors.forestGreen,
          ),
        ),
        trailing: isGuest
            ? OutlinedButton(
                onPressed: () => AuthModal.show(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.forestGreen),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(60, 32),
                ),
                child: Text('Login / OTP', style: AppTypography.labelLarge(color: AppColors.forestGreen)),
              )
            : TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await fbService.signOut();
                  if (!mounted) return;
                  setState(() {});
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.guestMode)),
                  );
                },
                child: Text(l10n.signOut, style: AppTypography.labelLarge(color: AppColors.error)),
              ),
      ),
    );
  }

  Widget _buildBusinessProfileCard(BuildContext context, AppLocalizations l10n) {
    final profile = StorageService.instance.userProfileRepo.getProfile();
    final hasProfile = profile != null && profile.name.isNotEmpty;

    return Card(
      color: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.surfaceSage,
          backgroundImage: profile?.logoPath != null && File(profile!.logoPath!).existsSync()
              ? FileImage(File(profile.logoPath!)) as ImageProvider
              : null,
          child: profile?.logoPath == null || !File(profile!.logoPath!).existsSync()
              ? const Icon(Icons.badge_outlined, color: AppColors.forestGreen)
              : null,
        ),
        title: Text(
          hasProfile ? profile.name : l10n.businessProfile,
          style: AppTypography.titleMedium(),
        ),
        subtitle: Text(
          hasProfile && profile.company.isNotEmpty ? profile.company : l10n.editProfile,
          style: AppTypography.bodySmall(),
        ),
        trailing: OutlinedButton(
          onPressed: () async {
            await context.push('/profile/edit');
            if (mounted) setState(() {});
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: const Size(60, 32),
          ),
          child: Text(l10n.editCard, style: AppTypography.labelLarge(color: AppColors.forestGreen)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AppTypography.headlineMedium()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account & Guest Mode Card
          _buildAccountCard(context, l10n),
          const SizedBox(height: 12),

          // Business Profile Identity Card
          _buildBusinessProfileCard(context, l10n),
          const SizedBox(height: 12),

          // Digital Card Teaser
          Card(
            color: AppColors.surfaceSage,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: AppColors.forestGreen,
                child: Icon(Icons.qr_code, color: Colors.white),
              ),
              title: Text('My Digital Card (vCard)', style: AppTypography.titleMedium()),
              subtitle: Text('20 Stitch Templates & Offline QR', style: AppTypography.bodySmall()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.forestGreen),
              onTap: () => context.push('/digital-card'),
            ),
          ),
          const SizedBox(height: 12),

          // Categories Hub Link
          Card(
            child: ListTile(
              leading: const Icon(Icons.category_rounded, color: AppColors.forestGreen),
              title: Text(l10n.navCategories, style: AppTypography.titleMedium()),
              subtitle: const Text('20 Business Categories & Custom tags'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              onTap: () => context.push('/categories'),
            ),
          ),
          const SizedBox(height: 12),

          // Google Firebase Cloud Sync Card
          const CloudSyncCard(),
          const SizedBox(height: 12),

          // Offline Data Backup & Multi-vCard Export Card
          const DataExportCard(),
          const SizedBox(height: 12),

          // Bilingual Language Selector
          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: AppColors.forestGreen),
              title: Text(l10n.languageToggle, style: AppTypography.titleMedium()),
              subtitle: Text(
                localeController.isHindi ? 'वर्तमान: हिन्दी' : 'Current: English',
                style: AppTypography.bodySmall(),
              ),
              trailing: Switch.adaptive(
                value: localeController.isHindi,
                activeThumbColor: AppColors.forestGreen,
                onChanged: (_) => localeController.toggleLocale(),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Timely Alarms & Battery Optimization Guide
          Card(
            child: ListTile(
              leading: const Icon(Icons.battery_charging_full_rounded, color: AppColors.forestGreen),
              title: Text('Timely Alarms & Battery (MIUI/Samsung)', style: AppTypography.titleMedium()),
              subtitle: Text('Google Play compliant background reminder guide', style: AppTypography.bodySmall()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              onTap: () => BatteryOptimizationDialog.show(context),
            ),
          ),
          const SizedBox(height: 12),

          // Google Play 2026 Privacy Policy Tile
          Card(
            child: ListTile(
              leading: const Icon(Icons.policy_outlined, color: AppColors.forestGreen),
              title: Text(l10n.privacyPolicy, style: AppTypography.titleMedium()),
              subtitle: Text(l10n.privacyPolicySubtitle, style: AppTypography.bodySmall()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              onTap: () => PrivacyPolicyModal.show(context),
            ),
          ),
          const SizedBox(height: 24),

          // Google Play 2026 Mandatory Account Deletion Section (Section 4.4)
          Card(
            color: AppColors.errorContainer.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.error, width: 0.8),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
              title: Text(
                l10n.deleteAccountData,
                style: AppTypography.labelLarge(color: AppColors.error),
              ),
              subtitle: Text(
                'Google Play Policy (2026) 1-Click Data Erasure',
                style: AppTypography.bodySmall(color: AppColors.error),
              ),
              onTap: () => DeleteAccountDialog.show(
                context,
                onDeleted: () {
                  if (mounted) setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // App Info Footer
          Center(
            child: Text(
              '${l10n.appInfo} · ${l10n.appVersion}',
              style: AppTypography.bodySmall(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
