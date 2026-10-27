import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen branded Splash Screen displaying Concept 3 (Smart AI Scan & Hologram)
/// Auto-transitions to Home Dashboard after exactly 6 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Set immersive status bar for splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();

    // Auto-navigate to home dashboard after exactly 6 seconds
    _navigationTimer = Timer(const Duration(seconds: 6), () {
      _goToHome();
    });
  }

  void _goToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _navigationTimer?.cancel();
    context.go('/');
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: GestureDetector(
        onTap: _goToHome, // Allow instant skip on tap
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Splash Background Image (Concept 3: Smart AI Scan & Hologram)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/splash/splash_screen.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback in case asset loading fails
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.saffron,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.contact_phone_rounded,
                              size: 48,
                              color: AppColors.saffron,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'CardSaathi',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Smart AI Card Companion',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onPrimaryContainer,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildLoaderComponent(),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 2. Positioned Loading Indicator under Smart AI Card Companion
              Positioned(
                bottom: bottomPadding + 80,
                left: 0,
                right: 0,
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildLoaderComponent(),
                  ),
                ),
              ),

              // 3. Made in India & Innovix Solutions Branding Footer
              Positioned(
                bottom: bottomPadding + 14,
                left: 0,
                right: 0,
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🇮🇳 ', style: TextStyle(fontSize: 12)),
                              Text(
                                AppConstants.madeInIndiaForWorld,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${AppConstants.developerName} · ${AppConstants.fullVersionString}',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onPrimaryContainer,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Theme-matching Bold CircularProgressIndicator & Transparent Loading Bar
  Widget _buildLoaderComponent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bold Circular Progress Indicator with transparent track
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            strokeCap: StrokeCap.round,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.saffron),
            backgroundColor: Colors.white.withValues(alpha: 0.18),
          ),
        ),
        const SizedBox(height: 14),

        // Transparent Bold Loading Bar
        Container(
          width: 140,
          height: 4.5,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.saffron.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.saffron),
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 10),

        // Subtitle badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Smart AI Card Companion',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onPrimaryContainer,
              letterSpacing: 0.9,
            ),
          ),
        ),
      ],
    );
  }
}
