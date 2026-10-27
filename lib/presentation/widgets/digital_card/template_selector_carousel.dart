import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/digital_card_template.dart';

/// Horizontal carousel displaying the 20 Stitch digital card templates
class TemplateSelectorCarousel extends StatelessWidget {
  final List<DigitalCardTemplate> availableTemplates;
  final DigitalCardTemplate activeTemplate;
  final bool isHindi;
  final ValueChanged<DigitalCardTemplate> onSelected;

  const TemplateSelectorCarousel({
    super.key,
    required this.availableTemplates,
    required this.activeTemplate,
    required this.isHindi,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: availableTemplates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final t = availableTemplates[index];
          final isSelected = t.id == activeTemplate.id;

          return InkWell(
            onTap: () => onSelected(t),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 110,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfaceSage : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.forestGreen : AppColors.borderSubtle,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: t.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '#${t.number}',
                        style: AppTypography.labelSmall(
                          color: isSelected ? AppColors.forestGreen : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    isHindi ? t.nameHi : t.nameEn,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.forestGreen : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
