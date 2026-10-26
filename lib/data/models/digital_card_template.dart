import 'package:flutter/material.dart';

/// Digital Visiting Card Template Metadata Model (Bound to Stitch Project 7571062141855216909)
class DigitalCardTemplate {
  final String id;
  final int number;
  final String nameEn;
  final String nameHi;
  final List<String> targetCategoryIds;
  final String styleFamily;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;
  final Color subtitleColor;
  final Color cardBorderColor;
  final bool hasDarkBackground;

  const DigitalCardTemplate({
    required this.id,
    required this.number,
    required this.nameEn,
    required this.nameHi,
    required this.targetCategoryIds,
    required this.styleFamily,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
    required this.subtitleColor,
    required this.cardBorderColor,
    this.hasDarkBackground = false,
  });

  bool matchesCategory(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return true;
    return targetCategoryIds.contains(categoryId);
  }
}
