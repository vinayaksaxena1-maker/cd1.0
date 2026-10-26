import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/category.dart';
import 'category_icon_helper.dart';

class CategoryCardTile extends StatelessWidget {
  final Category category;
  final int cardCount;
  final bool isHindi;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const CategoryCardTile({
    super.key,
    required this.category,
    required this.cardCount,
    required this.isHindi,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final primaryName = isHindi ? category.nameHi : category.nameEn;
    final secondaryName = isHindi ? category.nameEn : category.nameHi;
    final hasCards = cardCount > 0;

    return Semantics(
      button: true,
      label: '$primaryName, $cardCount cards',
      child: Material(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.surfaceSage.withValues(alpha: 0.4),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasCards ? AppColors.forestGreen.withValues(alpha: 0.25) : AppColors.borderSubtle,
                width: hasCards ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Icon container + Custom/Delete badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: hasCards ? AppColors.surfaceSage : AppColors.canvasIvory,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasCards ? AppColors.forestGreen.withValues(alpha: 0.3) : AppColors.borderSubtle,
                        ),
                      ),
                      child: Icon(
                        getCategoryIcon(category.iconCode),
                        color: hasCards ? AppColors.forestGreen : AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                    if (category.isCustom)
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        tooltip: 'Delete Category',
                        onPressed: onDelete,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSage.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.verified_rounded, size: 14, color: AppColors.forestGreen),
                      ),
                  ],
                ),

                const Spacer(),

                // Category Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      primaryName,
                      style: AppTypography.titleMedium(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      secondaryName,
                      style: AppTypography.labelSmall(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Bottom Row: Live Card Count Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: hasCards ? AppColors.forestGreen : AppColors.canvasIvory,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasCards ? AppColors.forestGreen : AppColors.borderSubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.contact_mail_rounded,
                        size: 12,
                        color: hasCards ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$cardCount ${cardCount == 1 ? "Card" : "Cards"}',
                        style: AppTypography.labelSmall(
                          color: hasCards ? Colors.white : AppColors.textSecondary,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
