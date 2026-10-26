import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CardGuideOverlay extends StatefulWidget {
  final String statusText;
  final bool isFrontSide;

  const CardGuideOverlay({
    super.key,
    this.statusText = 'Align visiting card in frame',
    this.isFrontSide = true,
  });

  @override
  State<CardGuideOverlay> createState() => _CardGuideOverlayState();
}

class _CardGuideOverlayState extends State<CardGuideOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _laserAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth * 0.88).clamp(280.0, 360.0);
        final cardHeight = cardWidth * (2.0 / 3.0); // 3:2 visiting card aspect ratio

        return Stack(
          alignment: Alignment.center,
          children: [
            // Darkened viewfinder vignette overlay
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.65),
                BlendMode.srcOut,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Frame with Saffron Corner Brackets
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                children: [
                  // Subtle card inner border
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.canvasIvory.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),

                  // 4 Saffron Corner Brackets (Stitch spec)
                  // Top-Left
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.saffron, width: 4),
                          left: BorderSide(color: AppColors.saffron, width: 4),
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
                      ),
                    ),
                  ),
                  // Top-Right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.saffron, width: 4),
                          right: BorderSide(color: AppColors.saffron, width: 4),
                        ),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
                      ),
                    ),
                  ),
                  // Bottom-Left
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.saffron, width: 4),
                          left: BorderSide(color: AppColors.saffron, width: 4),
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
                      ),
                    ),
                  ),
                  // Bottom-Right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.saffron, width: 4),
                          right: BorderSide(color: AppColors.saffron, width: 4),
                        ),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                      ),
                    ),
                  ),

                  // Animated Saffron Laser Scan Line
                  AnimatedBuilder(
                    animation: _laserAnimation,
                    builder: (context, _) {
                      return Positioned(
                        top: cardHeight * _laserAnimation.value,
                        left: 12,
                        right: 12,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.saffron.withValues(alpha: 0.9),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.saffron.withValues(alpha: 0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Subtle Ghost Card Guide Template
                  Center(
                    child: Opacity(
                      opacity: 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isFrontSide ? Icons.badge_outlined : Icons.qr_code_2,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.isFrontSide ? 'FRONT SIDE' : 'BACK SIDE',
                            style: AppTypography.labelSmall(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Status Directive Pill
            Positioned(
              top: constraints.maxHeight * 0.16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.saffron,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.statusText,
                      style: AppTypography.labelMedium(color: AppColors.forestGreen),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
