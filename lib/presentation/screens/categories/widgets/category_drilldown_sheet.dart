import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/contact_card.dart';
import '../../../../l10n/app_localizations.dart';
import 'category_icon_helper.dart';

class CategoryDrillDownSheet extends StatelessWidget {
  final Category category;
  final List<ContactCard> cards;
  final bool isHindi;

  const CategoryDrillDownSheet({
    super.key,
    required this.category,
    required this.cards,
    required this.isHindi,
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'CS';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final clean = digits.length == 10 ? '91$digits' : digits;
    const greeting = 'Namaste! Connecting via CardSaathi.';
    final uri = Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent(greeting)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _getPrimaryPhone(ContactCard card) {
    return card.phones.isNotEmpty ? card.phones.first : '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final catName = isHindi ? category.nameHi : category.nameEn;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.canvasIvory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSage,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.3)),
                  ),
                  child: Icon(
                    getCategoryIcon(category.iconCode),
                    color: AppColors.forestGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catName,
                        style: AppTypography.headlineSmall(color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${cards.length} ${cards.length == 1 ? "Card" : "Cards"}',
                        style: AppTypography.labelSmall(color: AppColors.forestGreen).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),

          // Cards List or Empty State
          Flexible(
            child: cards.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSage.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.folder_open_rounded, size: 32, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noCardsInCategory,
                          style: AppTypography.titleMedium(color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan a visiting card and assign it to this category.',
                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: cards.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final phone = _getPrimaryPhone(card);
                      final hasFrontImage = card.photoFrontPath != null &&
                          File(card.photoFrontPath!).existsSync();

                      return Material(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push('/cards/${card.id}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Thumbnail / Initials Avatar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    color: AppColors.surfaceSage,
                                    child: hasFrontImage
                                        ? Image.file(
                                            File(card.photoFrontPath!),
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Text(
                                              _getInitials(card.name),
                                              style: AppTypography.labelLarge(
                                                color: AppColors.forestGreen,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Card Name & Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.name.isNotEmpty ? card.name : 'Unknown Contact',
                                        style: AppTypography.titleMedium(color: AppColors.textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (card.company.isNotEmpty || card.jobTitle.isNotEmpty)
                                        Text(
                                          [card.jobTitle, card.company]
                                              .where((s) => s.isNotEmpty)
                                              .join(' • '),
                                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (phone.isNotEmpty)
                                        Text(
                                          phone,
                                          style: AppTypography.labelSmall(color: AppColors.forestGreen),
                                        ),
                                    ],
                                  ),
                                ),

                                // WhatsApp & Call Shortcuts
                                if (phone.isNotEmpty) ...[
                                  IconButton(
                                    icon: const Icon(Icons.chat_bubble_outline_rounded,
                                        color: AppColors.forestGreen, size: 20),
                                    tooltip: l10n.tapToWhatsApp,
                                    onPressed: () => _openWhatsApp(phone),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.phone_outlined,
                                        color: AppColors.forestGreen, size: 20),
                                    tooltip: l10n.tapToCall,
                                    onPressed: () => _makeCall(phone),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Footer Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.forestGreen,
                side: const BorderSide(color: AppColors.forestGreen),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/cards?category=${category.id}');
              },
              icon: const Icon(Icons.list_alt_rounded, size: 20),
              label: Text(
                l10n.viewInDirectory,
                style: AppTypography.labelLarge(color: AppColors.forestGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
