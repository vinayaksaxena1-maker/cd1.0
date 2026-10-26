import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cardsaathi/core/theme/app_colors.dart';
import 'package:cardsaathi/core/theme/app_typography.dart';
import 'package:cardsaathi/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Stitch Design System Tokens Verification', () {
    test('AppColors verify exact brand tokens', () {
      expect(AppColors.forestGreen, const Color(0xFF0D513B));
      expect(AppColors.canvasIvory, const Color(0xFFFAF7F0));
      expect(AppColors.saffron, const Color(0xFFE6A23A));
      expect(AppColors.surfaceSage, const Color(0xFFEAF1E9));
      expect(AppColors.textPrimary, const Color(0xFF17211C));
      expect(AppColors.borderSubtle, const Color(0xFFE2E8E2));
    });

    test('AppTypography provides non-null styles with appropriate sizes', () {
      final hLarge = AppTypography.headlineLarge();
      expect(hLarge.fontSize, 26);
      expect(hLarge.fontWeight, FontWeight.w600);

      final tMed = AppTypography.titleMedium();
      expect(tMed.fontSize, 16);
      expect(tMed.fontWeight, FontWeight.w700);

      final bLarge = AppTypography.bodyLarge();
      expect(bLarge.fontSize, 15);
      expect(bLarge.fontWeight, FontWeight.w500);

      final lSmall = AppTypography.labelSmall();
      expect(lSmall.fontSize, 11);
    });

    test('AppTheme creates valid Material 3 ThemeData with Stitch specs', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, true);
      expect(theme.scaffoldBackgroundColor, AppColors.canvasIvory);
      expect(theme.colorScheme.primary, AppColors.forestGreen);
      expect(theme.colorScheme.surface, AppColors.surfaceCard);

      // Card Shape
      final cardShape = theme.cardTheme.shape as RoundedRectangleBorder?;
      expect(cardShape, isNotNull);
      expect(cardShape!.borderRadius, BorderRadius.circular(16));

      // Elevated Button touch targets (56px min-height)
      final btnStyle = theme.elevatedButtonTheme.style;
      expect(btnStyle, isNotNull);
      final minSize = btnStyle!.minimumSize?.resolve({});
      expect(minSize, const Size(double.infinity, 56));
    });

    testWidgets('Widget tree mounts properly with AppTheme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Theme Test')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Action'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Theme Test'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });
  });
}
