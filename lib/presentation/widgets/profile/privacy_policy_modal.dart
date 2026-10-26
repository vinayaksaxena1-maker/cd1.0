import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Modal bottom sheet presenting Google Play 2026 Compliant Privacy Policy
class PrivacyPolicyModal extends StatelessWidget {
  const PrivacyPolicyModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PrivacyPolicyModal(),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surfaceSage,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.forestGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium(color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView(
            controller: scrollController,
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.privacyPolicy, style: AppTypography.headlineMedium()),
                        Text('Google Play 2026 Developer Compliance', style: AppTypography.bodySmall()),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              _buildSection(
                '1. On-Device AI & ML Kit Processing',
                'CardSaathi executes OCR (Optical Character Recognition) entirely on your device using Google ML Kit. Your visiting card scans and extracted company/contact information are never transmitted to third-party AI training servers.',
                Icons.memory_rounded,
              ),

              _buildSection(
                '2. Offline-First Data Sovereignty',
                'All contact cards, categories, meeting reminders, and audio memos are persisted securely in local encrypted Hive boxes on your device. You can use 100% of the app without any internet connection.',
                Icons.storage_rounded,
              ),

              _buildSection(
                '3. Voice Memo Microphone Disclosures',
                'Microphone access is requested strictly when you choose to record an optional 10-second context memo. Audio files (.m4a) reside exclusively in your app-isolated directory and are never broadcast or uploaded without authorization.',
                Icons.mic_none_rounded,
              ),

              _buildSection(
                '4. Privacy-Preserving Contact Import',
                'We do not harvest or read your device address book. Importing contacts utilizes Android\'s system contact picker (Intent.ACTION_PICK), allowing you to pick one contact at a time without granting broad READ_CONTACTS permissions.',
                Icons.person_search_rounded,
              ),

              _buildSection(
                '5. Optional Cloud Backup & Guest Mode',
                'Cloud sync via Google Firebase Firestore is completely optional. Guest users enjoy full functionality offline. When signed in, data is transmitted over TLS/SSL encryption and restricted to your authenticated UID.',
                Icons.cloud_sync_rounded,
              ),

              _buildSection(
                '6. Section 4.4 1-Click Permanent Data Erasure',
                'In full compliance with Google Play Section 4.4, you may delete your entire account, all visiting cards, meetings, profile data, and cloud Firestore records permanently at any time via the "Delete Account & Data" action in Settings.',
                Icons.delete_forever_rounded,
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  'CardSaathi v1.0.0 · Made for Indian MSMEs & Traders',
                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
