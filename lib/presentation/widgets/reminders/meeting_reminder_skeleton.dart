import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Skeleton loader widget for MeetingReminderCard (5-State Resilience)
class MeetingReminderSkeleton extends StatelessWidget {
  const MeetingReminderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      color: AppColors.surfaceCard,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox placeholder
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),

            // Content lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status badge line
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.borderSubtle.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.borderSubtle.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date time line
                  Container(
                    width: 160,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.borderSubtle.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Agenda line
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.borderSubtle.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Contact chip line
                  Container(
                    width: 140,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.borderSubtle.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
