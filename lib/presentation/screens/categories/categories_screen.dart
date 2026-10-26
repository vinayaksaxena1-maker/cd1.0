import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/category.dart';
import '../../../data/models/contact_card.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/add_category_dialog.dart';
import 'widgets/category_card_tile.dart';
import 'widgets/category_drilldown_sheet.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Category> _categories = [];
  List<ContactCard> _allCards = [];
  Map<String, int> _cardCounts = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final storage = StorageService.instance;
      var categories = storage.categoryRepo.getAllCategories();
      if (categories.isEmpty) {
        await storage.categoryRepo.seedDefaultCategories();
        categories = storage.categoryRepo.getAllCategories();
      }

      final cards = storage.contactRepo.getAllCards();
      final Map<String, int> counts = {};
      for (final card in cards) {
        counts[card.categoryId] = (counts[card.categoryId] ?? 0) + 1;
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _allCards = cards;
          _cardCounts = counts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onCategoryTapped(Category category, bool isHindi) {
    final filtered = _allCards.where((c) => c.categoryId == category.id).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryDrillDownSheet(
        category: category,
        cards: filtered,
        isHindi: isHindi,
      ),
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const AddCategoryDialog(),
    );

    if (result == true && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.categoryAdded),
          backgroundColor: AppColors.forestGreen,
        ),
      );
      _loadData();
    }
  }

  Future<void> _handleDeleteCategory(Category category) async {
    final l10n = AppLocalizations.of(context)!;

    if (!category.isCustom) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotDeleteDefaultCategory),
          backgroundColor: AppColors.textPrimary,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.canvasIvory,
        title: Text(l10n.deleteCategory, style: AppTypography.headlineSmall()),
        content: Text(
          l10n.deleteCategoryConfirm,
          style: AppTypography.bodyMedium(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel, style: AppTypography.labelLarge(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteCategory, style: AppTypography.labelLarge(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final storage = StorageService.instance;
      final deleted = await storage.categoryRepo.deleteCategory(
        category.id,
        contactRepo: storage.contactRepo,
      );

      if (deleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.categoryDeleted),
            backgroundColor: AppColors.forestGreen,
          ),
        );
        _loadData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppColors.canvasIvory,
      appBar: AppBar(
        title: Text(l10n.navCategories, style: AppTypography.headlineMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.forestGreen),
            tooltip: l10n.addCategory,
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.forestGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addCategory, style: AppTypography.labelLarge(color: Colors.white)),
        onPressed: _showAddCategoryDialog,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.forestGreen,
        child: _buildBody(l10n, isHindi),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, bool isHindi) {
    if (_isLoading) {
      return _buildSkeletonGrid();
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(
                'Failed to load categories',
                style: AppTypography.titleMedium(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.category_outlined, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text('No Categories Found', style: AppTypography.titleMedium()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await StorageService.instance.categoryRepo.seedDefaultCategories();
                  _loadData();
                },
                child: const Text('Restore Default 20 Categories'),
              ),
            ],
          ),
        ),
      );
    }

    final defaultCount = _categories.where((c) => !c.isCustom).length;
    final customCount = _categories.where((c) => c.isCustom).length;

    return CustomScrollView(
      slivers: [
        // Header Overview Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.forestGreen,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forestGreen.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.commercialCategories,
                        style: AppTypography.titleMedium(color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.saffron,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_categories.length} Total',
                          style: AppTypography.labelSmall(color: Colors.black).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.organizeByTrade,
                    style: AppTypography.bodySmall(color: AppColors.surfaceSage),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildHeaderStatBadge(
                        icon: Icons.store_rounded,
                        label: '$defaultCount Commercial',
                      ),
                      const SizedBox(width: 8),
                      if (customCount > 0)
                        _buildHeaderStatBadge(
                          icon: Icons.bookmark_add_rounded,
                          label: '$customCount Custom',
                        ),
                      const Spacer(),
                      _buildHeaderStatBadge(
                        icon: Icons.credit_card_rounded,
                        label: '${_allCards.length} Cards',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Categories 2-Column Grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = _categories[index];
                final count = _cardCounts[category.id] ?? 0;
                return CategoryCardTile(
                  category: category,
                  cardCount: count,
                  isHindi: isHindi,
                  onTap: () => _onCategoryTapped(category, isHindi),
                  onDelete: category.isCustom ? () => _handleDeleteCategory(category) : null,
                );
              },
              childCount: _categories.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderStatBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.saffron),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall(color: Colors.white).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: 8,
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceSage.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Spacer(),
            Container(
              width: 80,
              height: 14,
              color: AppColors.surfaceSage.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 6),
            Container(
              width: 50,
              height: 10,
              color: AppColors.surfaceSage.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
