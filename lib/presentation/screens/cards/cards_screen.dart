import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/category.dart';
import '../../../data/models/contact_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/cards/card_tile_skeleton.dart';
import '../../widgets/cards/card_tile_widget.dart';

enum CardSortOption {
  newest,
  oldest,
  nameAZ,
  companyAZ,
}

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  bool _isLoading = true;
  String? _errorMessage;
  List<ContactCard> _allCards = [];
  List<ContactCard> _filteredCards = [];
  List<Category> _categories = [];
  String? _selectedCategoryId;
  CardSortOption _sortOption = CardSortOption.newest;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = StorageService.instance.categoryRepo.getAllCategories();
      final cards = StorageService.instance.contactRepo.getAllCards();

      if (mounted) {
        setState(() {
          _categories = categories;
          _allCards = cards;
          _isLoading = false;
        });
        _applyFiltersAndSort();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _onSearchChanged() {
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    final query = _searchController.text.trim().toLowerCase();

    List<ContactCard> result = List.from(_allCards);

    // Filter by category if selected
    if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
      result = result.where((c) => c.categoryId == _selectedCategoryId).toList();
    }

    // Filter by search query
    if (query.isNotEmpty) {
      result = result.where((card) {
        final matchesName = card.name.toLowerCase().contains(query);
        final matchesCompany = card.company.toLowerCase().contains(query);
        final matchesJob = card.jobTitle.toLowerCase().contains(query);
        final matchesEmail = card.email.toLowerCase().contains(query);
        final matchesGstin = card.gstin.toLowerCase().contains(query);
        final matchesNotes = card.notes.toLowerCase().contains(query);
        final matchesPhones = card.phones.any((p) => p.contains(query));
        final matchesTags = card.tags.any((t) => t.toLowerCase().contains(query));
        return matchesName || matchesCompany || matchesJob || matchesEmail ||
            matchesGstin || matchesNotes || matchesPhones || matchesTags;
      }).toList();
    }

    // Apply Sorting
    switch (_sortOption) {
      case CardSortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case CardSortOption.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case CardSortOption.nameAZ:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case CardSortOption.companyAZ:
        result.sort((a, b) => a.company.toLowerCase().compareTo(b.company.toLowerCase()));
        break;
    }

    setState(() {
      _filteredCards = result;
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedCategoryId = null;
    });
    _applyFiltersAndSort();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCards, style: AppTypography.headlineMedium()),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined, color: AppColors.forestGreen),
            tooltip: l10n.navCategories,
            onPressed: () async {
              await context.push('/categories');
              _loadInitialData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort_outlined, color: AppColors.textPrimary),
            tooltip: l10n.sortBy,
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
        color: AppColors.forestGreen,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  hintStyle: AppTypography.bodySmall(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _applyFiltersAndSort();
                          },
                        )
                      : null,
                  fillColor: AppColors.surfaceCard,
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal Category Filter Pills
              _buildCategoryPills(l10n, isHindi),
              const SizedBox(height: 8),

              // Status / Count Bar
              if (!_isLoading && _errorMessage == null && _allCards.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_filteredCards.length} ${l10n.navCards}',
                        style: AppTypography.bodySmall(color: AppColors.textSecondary),
                      ),
                      if (_selectedCategoryId != null || _searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: _clearFilters,
                          child: Text(
                            l10n.clearFilters,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forestGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              // Main Content Area (5-State Resilience)
              Expanded(
                child: _buildMainContent(l10n),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/scan');
          _loadInitialData();
        },
        backgroundColor: AppColors.forestGreen,
        child: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryPills(AppLocalizations l10n, bool isHindi) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = _selectedCategoryId == null;
            return ChoiceChip(
              label: Text('${l10n.allCategories} (${_allCards.length})'),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedCategoryId = null);
                _applyFiltersAndSort();
              },
              selectedColor: AppColors.forestGreen,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              backgroundColor: AppColors.surfaceCard,
              side: BorderSide(
                color: isSelected ? AppColors.forestGreen : AppColors.borderSubtle,
              ),
            );
          }

          final cat = _categories[index - 1];
          final isSelected = _selectedCategoryId == cat.id;
          final catCardsCount = _allCards.where((c) => c.categoryId == cat.id).length;
          final catName = isHindi ? cat.nameHi : cat.nameEn;

          return ChoiceChip(
            label: Text('$catName ($catCardsCount)'),
            selected: isSelected,
            onSelected: (_) {
              setState(() => _selectedCategoryId = isSelected ? null : cat.id);
              _applyFiltersAndSort();
            },
            selectedColor: AppColors.forestGreen,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: AppColors.surfaceCard,
            side: BorderSide(
              color: isSelected ? AppColors.forestGreen : AppColors.borderSubtle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(AppLocalizations l10n) {
    // State 1: Loading Skeleton
    if (_isLoading) {
      return ListView.builder(
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, _) => const CardTileSkeleton(),
      );
    }

    // State 2: Error State
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 54, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: AppTypography.bodyMedium(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: Text(l10n.error),
            ),
          ],
        ),
      );
    }

    // State 3: Empty State (Total Database is empty)
    if (_allCards.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card_off_outlined, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(l10n.noCardsYet, style: AppTypography.titleMedium()),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 50),
                  backgroundColor: AppColors.forestGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await context.push('/scan');
                  _loadInitialData();
                },
                icon: const Icon(Icons.add_a_photo_outlined),
                label: Text(l10n.scanCardButton),
              ),
            ],
          ),
        ),
      );
    }

    // State 4: Empty Filter/Search State
    if (_filteredCards.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_outlined, size: 54, color: AppColors.textSecondary),
              const SizedBox(height: 14),
              Text(l10n.noMatchingCards, style: AppTypography.titleMedium()),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.clearFilters),
              ),
            ],
          ),
        ),
      );
    }

    // State 5: Populated List (Default State)
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _filteredCards.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final card = _filteredCards[index];
        return CardTileWidget(
          card: card,
          onTap: () async {
            await context.push('/cards/${card.id}');
            _loadInitialData();
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(l10n.sortBy, style: AppTypography.titleMedium()),
                ),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.sortNewest),
                  trailing: _sortOption == CardSortOption.newest ? const Icon(Icons.check, color: AppColors.forestGreen) : null,
                  onTap: () {
                    setState(() => _sortOption = CardSortOption.newest);
                    _applyFiltersAndSort();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(l10n.sortOldest),
                  trailing: _sortOption == CardSortOption.oldest ? const Icon(Icons.check, color: AppColors.forestGreen) : null,
                  onTap: () {
                    setState(() => _sortOption = CardSortOption.oldest);
                    _applyFiltersAndSort();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: Text(l10n.sortNameAZ),
                  trailing: _sortOption == CardSortOption.nameAZ ? const Icon(Icons.check, color: AppColors.forestGreen) : null,
                  onTap: () {
                    setState(() => _sortOption = CardSortOption.nameAZ);
                    _applyFiltersAndSort();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(l10n.sortCompanyAZ),
                  trailing: _sortOption == CardSortOption.companyAZ ? const Icon(Icons.check, color: AppColors.forestGreen) : null,
                  onTap: () {
                    setState(() => _sortOption = CardSortOption.companyAZ);
                    _applyFiltersAndSort();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
