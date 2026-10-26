import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/local/storage_service.dart';
import '../../../../l10n/app_localizations.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _nameHiController = TextEditingController();

  static const List<Map<String, dynamic>> _availableIcons = [
    {'icon': Icons.store_mall_directory_rounded, 'code': 0xe602, 'label': 'Store'},
    {'icon': Icons.local_shipping_rounded, 'code': 0xe3a8, 'label': 'Logistics'},
    {'icon': Icons.restaurant_rounded, 'code': 0xe532, 'label': 'Food'},
    {'icon': Icons.hardware_rounded, 'code': 0xe2f1, 'label': 'Hardware'},
    {'icon': Icons.local_pharmacy_rounded, 'code': 0xe3a6, 'label': 'Medical'},
    {'icon': Icons.account_balance_rounded, 'code': 0xe003, 'label': 'Finance'},
    {'icon': Icons.work_rounded, 'code': 0xe6f2, 'label': 'Services'},
    {'icon': Icons.palette_rounded, 'code': 0xe466, 'label': 'Creative'},
  ];

  int _selectedIconCode = _availableIcons[0]['code'] as int;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameHiController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final nameEn = _nameEnController.text.trim();
    final nameHi = _nameHiController.text.trim().isNotEmpty ? _nameHiController.text.trim() : nameEn;
    final slug = 'custom_${DateTime.now().millisecondsSinceEpoch}';

    try {
      await StorageService.instance.categoryRepo.addCustomCategory(
        id: slug,
        nameEn: nameEn,
        nameHi: nameHi,
        iconCode: _selectedIconCode,
      );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save category: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.canvasIvory,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceSage,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add_business_rounded, color: AppColors.forestGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.addCategory,
              style: AppTypography.headlineSmall(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // English Name
              Text(
                l10n.categoryNameEn,
                style: AppTypography.labelMedium(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameEnController,
                decoration: InputDecoration(
                  hintText: 'e.g. Electrical & Electronics',
                  hintStyle: AppTypography.bodySmall(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.label_outline_rounded, color: AppColors.forestGreen),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n.categoryNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Hindi Name
              Text(
                l10n.categoryNameHi,
                style: AppTypography.labelMedium(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameHiController,
                decoration: InputDecoration(
                  hintText: 'उदा. इलेक्ट्रिकल एवं इलेक्ट्रॉनिक्स',
                  hintStyle: AppTypography.bodySmall(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.translate_rounded, color: AppColors.forestGreen),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                ),
              ),
              const SizedBox(height: 16),

              // Select Icon Grid
              Text(
                l10n.selectIcon,
                style: AppTypography.labelMedium(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((item) {
                  final code = item['code'] as int;
                  final icon = item['icon'] as IconData;
                  final isSelected = _selectedIconCode == code;

                  return InkWell(
                    onTap: () => setState(() => _selectedIconCode = code),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.forestGreen : AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.forestGreen : AppColors.borderSubtle,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        size: 22,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: AppTypography.labelLarge(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forestGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _isSaving ? null : _saveCategory,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  l10n.save,
                  style: AppTypography.labelLarge(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
