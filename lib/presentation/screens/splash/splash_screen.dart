import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Full-screen branded Splash Screen displaying Concept 3 (Smart AI Scan & Hologram)
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
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();

    // Auto-navigate to home dashboard after 2 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 2100), () {
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
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: GestureDetector(
        onTap: _goToHome, // Allow instant skip on tap
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Splash Background Image with Smooth Fade
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
                          Text(
                            'Aapka Digital Business Companion',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.onPrimaryContainer,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Subtle Skip Hint at Bottom
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 24,
                left: 0,
                right: 0,
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Tap anywhere to continue',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.6),
                        letterSpacing: 0.8,
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
}
