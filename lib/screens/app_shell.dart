import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_scope.dart';
import '../components/bottom_nav.dart';
import '../components/university_tile.dart';
import '../data/data_universitas.dart';
import '../theme/app_colors.dart';
import 'compare_screen.dart';
import 'detail_screens.dart';
import 'profile_screens.dart';

enum _HomeFilterType { all, favorites, recommended }

enum _HomeViewMode { list, grid }

class _HomeFilterData {
  const _HomeFilterData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badgeText,
  });

  final _HomeFilterType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badgeText;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const List<String> _titles = [
    'Beranda',
    'Cari Universitas',
    'Favorit',
    'Compare',
    'Profil',
  ];

  final Set<int> _favoriteIds = <int>{};
  final List<String> _specialities = demoUniversities
      .where((u) => u.speciality.isNotEmpty)
      .map((u) => u.speciality)
      .toSet()
      .toList()
    ..sort();
  final List<String> _sortOptions = const [
    'A-Z',
    'Z-A',
    'Favorit dulu',
    'Spesialis unggulan',
  ];
  late final TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedSpeciality = 'Semua';
  String _sortOption = 'A-Z';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_handleSearchChange);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('favorite_ids');
    if (stored != null) {
      _favoriteIds
        ..clear()
        ..addAll(stored.map(int.parse));
    } else {
      _favoriteIds.addAll(
        demoUniversities.where((uni) => uni.isFavorite).map((uni) => uni.id),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_ids',
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChange)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChange() {
    setState(() => _searchQuery = _searchController.text.trim());
  }

  void _handleTabSelect(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  Future<void> _navigateToUniversityDetail({
    required University university,
    required bool isFavorite,
  }) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => UniversityDetailScreen(
          university: university,
          isFavorite: isFavorite,
          onToggleFavorite: () => _toggleFavorite(university),
        ),
      ),
    );

    // Jika user menekan tombol "Buka tab Compare", arahkan ke tab Compare
    if (result == 'navigate_to_compare') {
      _handleTabSelect(3);
    }
  }

  void _toggleFavorite(University university) {
    setState(() {
      if (_favoriteIds.contains(university.id)) {
        _favoriteIds.remove(university.id);
      } else {
        _favoriteIds.add(university.id);
      }
    });
    _persistFavorites();
  }

  List<University> _applySearchAndFilter() {
    final lowerQuery = _searchQuery.toLowerCase();
    List<University> results = demoUniversities.where((uni) {
      final matchesQuery = lowerQuery.isEmpty ||
          uni.name.toLowerCase().contains(lowerQuery) ||
          uni.location.toLowerCase().contains(lowerQuery);
      final matchesSpeciality = _selectedSpeciality == 'Semua' ||
          uni.speciality.toLowerCase() ==
              _selectedSpeciality.toLowerCase();
      return matchesQuery && matchesSpeciality;
    }).toList();

    switch (_sortOption) {
      case 'Z-A':
        results.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Favorit dulu':
        results.sort((a, b) {
          final aFav = _favoriteIds.contains(a.id) ? 1 : 0;
          final bFav = _favoriteIds.contains(b.id) ? 1 : 0;
          if (aFav != bFav) return bFav.compareTo(aFav);
          return a.name.compareTo(b.name);
        });
        break;
      case 'Spesialis unggulan':
        results.sort((a, b) {
          final aHas = a.speciality.isNotEmpty ? 1 : 0;
          final bHas = b.speciality.isNotEmpty ? 1 : 0;
          if (aHas != bHas) return bHas.compareTo(aHas);
          return a.name.compareTo(b.name);
        });
        break;
      case 'A-Z':
      default:
        results.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final specialityFilters = ['Semua', ..._specialities];
    final tabs = <Widget>[
      HomeTab(
        universities: demoUniversities,
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
      ),
      SearchTab(
        universities: _applySearchAndFilter(),
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        controller: _searchController,
        query: _searchQuery,
        specialities: specialityFilters,
        selectedSpeciality: _selectedSpeciality,
        onSpecialitySelected: (value) {
          setState(() => _selectedSpeciality = value);
        },
        sortOptions: _sortOptions,
        selectedSort: _sortOption,
        onSortChanged: (value) {
          setState(() => _sortOption = value);
        },
      ),
      FavoritesTab(
        favorites: demoUniversities
            .where((uni) => _favoriteIds.contains(uni.id))
            .toList(),
        onToggleFavorite: _toggleFavorite,
      ),
      CompareTab(universities: demoUniversities),
      ProfileScreen(
        onLogout: widget.onLogout,
        userName: auth.userName,
        userEmail: auth.userEmail,
        userPassword: auth.userPassword,
        favoriteCount: _favoriteIds.length,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: _GlassTopBar(
              title: _titles[_currentIndex],
              subtitle: null,
              badgeText: '${_favoriteIds.length} Favorit',
              useBlur: _currentIndex != 3, // no blur on Compare tab
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.gradient(context),
          ),
        ),
        child: IndexedStack(index: _currentIndex, children: tabs),
      ),
      bottomNavigationBar: BottomNavScreen(
        currentIndex: _currentIndex,
        onTap: _handleTabSelect,
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.universities,
    required this.favoriteIds,
    required this.onToggleFavorite,
  });

  final List<University> universities;
  final Set<int> favoriteIds;
  final ValueChanged<University> onToggleFavorite;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final PageController _pageController;
  int _selectedFilterIndex = 0;
  _HomeViewMode _viewMode = _HomeViewMode.list;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<University> _applyFilter(
    _HomeFilterType type,
    List<University> universities,
    Set<int> favoriteIds,
  ) {
    switch (type) {
      case _HomeFilterType.favorites:
        return universities.where((u) => favoriteIds.contains(u.id)).toList();
      case _HomeFilterType.recommended:
        final recommendedIds =
            universities.take(4).map((u) => u.id).toSet();
        return universities.where((u) => recommendedIds.contains(u.id)).toList();
      case _HomeFilterType.all:
        return universities;
    }
  }

  @override
  Widget build(BuildContext context) {
    final universities = widget.universities;
    final isDark = AppColors.isDark(context);
    final favorites =
        universities.where((u) => widget.favoriteIds.contains(u.id)).toList();
    final recommendedList = universities.take(4).toList();
    final recommendedIds = recommendedList.map((u) => u.id).toSet();
    final fallbackImage =
        universities.isNotEmpty ? universities.first.imageUrl : '';

    final filters = [
      _HomeFilterData(
        type: _HomeFilterType.all,
        title: 'Semua Kampus',
        subtitle: 'Jelajahi daftar kampus pilihan di Sumatera Selatan.',
        imageUrl: fallbackImage,
        badgeText: '${universities.length} kampus',
      ),
      _HomeFilterData(
        type: _HomeFilterType.favorites,
        title: 'Kampus Favorit',
        subtitle: 'Cepat temukan kampus yang sudah kamu simpan.',
        imageUrl: favorites.isNotEmpty
            ? favorites.first.imageUrl
            : fallbackImage,
        badgeText: '${favorites.length} favorit',
      ),
      _HomeFilterData(
        type: _HomeFilterType.recommended,
        title: 'Rekomendasi',
        subtitle: 'Pilihan kampus unggulan untuk kamu pertimbangkan.',
        imageUrl: recommendedList.isNotEmpty
            ? recommendedList.first.imageUrl
            : fallbackImage,
        badgeText: '${recommendedIds.length} kampus',
      ),
    ];

    final activeFilter = filters[_selectedFilterIndex];
    final results = _applyFilter(
      activeFilter.type,
      universities,
      widget.favoriteIds,
    );

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: _HomeCarousel(
                controller: _pageController,
                filters: filters,
                activeIndex: _selectedFilterIndex,
                onPageChanged: (index) {
                  setState(() => _selectedFilterIndex = index);
                },
                onIndicatorTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                  );
                  setState(() => _selectedFilterIndex = index);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _HomeHeader(
                title: 'Daftar Universitas',
                subtitle:
                    'Lihat ringkasan hunian pilihan sebelum membuka detailnya.',
                isGrid: _viewMode == _HomeViewMode.grid,
                onListTap: () {
                  setState(() => _viewMode = _HomeViewMode.list);
                },
                onGridTap: () {
                  setState(() => _viewMode = _HomeViewMode.grid);
                },
              ),
            ),
          ),
          if (results.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: _EmptyState(
                  title: 'Belum ada kampus',
                  subtitle: 'Coba pilih filter lain untuk melihat daftar.',
                ),
              ),
            )
          else if (_viewMode == _HomeViewMode.list)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final university = results[index];
                  final isFavorite =
                      widget.favoriteIds.contains(university.id);
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: index == results.length - 1 ? 24 : 16,
                    ),
                    child: UniversityTile(
                      university: university,
                      isFavorite: isFavorite,
                      onToggleFavorite: () => widget.onToggleFavorite(university),
                      showFavoriteButton: false,
                      showPreviewDetails: false,
                      useDarkTheme: isDark,
                      onTap: () => context
                          .findAncestorStateOfType<_AppShellState>()
                          ?._navigateToUniversityDetail(
                            university: university,
                            isFavorite: isFavorite,
                          ),
                    ),
                  );
                },
                childCount: results.length,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final university = results[index];
                    final isFavorite =
                        widget.favoriteIds.contains(university.id);
                    return _UniversityGridCard(
                      university: university,
                      isFavorite: isFavorite,
                      onTap: () => context
                          .findAncestorStateOfType<_AppShellState>()
                          ?._navigateToUniversityDetail(
                            university: university,
                            isFavorite: isFavorite,
                          ),
                    );
                  },
                  childCount: results.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({
    super.key,
    required this.universities,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.controller,
    required this.query,
    required this.specialities,
    required this.selectedSpeciality,
    required this.onSpecialitySelected,
    required this.sortOptions,
    required this.selectedSort,
    required this.onSortChanged,
  });

  final List<University> universities;
  final Set<int> favoriteIds;
  final ValueChanged<University> onToggleFavorite;
  final TextEditingController controller;
  final String query;
  final List<String> specialities;
  final String selectedSpeciality;
  final ValueChanged<String> onSpecialitySelected;
  final List<String> sortOptions;
  final String selectedSort;
  final ValueChanged<String> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = AppColors.isDark(context);
    final textPrimary = AppColors.textPrimary(context);
    final textMuted = AppColors.textMuted(context);
    final surface = AppColors.surface(context);
    final surfaceElevated = AppColors.surfaceElevated(context);
    final border = AppColors.border(context);
    final lowerQuery = query.toLowerCase();
    final results = universities;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              style: TextStyle(color: textPrimary),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: SvgPicture.string(
                    _searchIcon,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      textMuted,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                hintText: 'Cari Universitas...',
                hintStyle: TextStyle(color: textMuted),
                filled: true,
                fillColor: surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.brand, width: 1.2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: specialities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final item = specialities[index];
                      final isSelected = item == selectedSpeciality;
                      return ChoiceChip(
                      label: Text(item),
                      selected: isSelected,
                      selectedColor: AppColors.brand,
                      backgroundColor: surfaceElevated,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : border,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textMuted,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                        onSelected: (_) => onSpecialitySelected(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Urutkan:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedSort,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: surface,
                      style: TextStyle(color: textPrimary),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textPrimary,
                      ),
                      items: sortOptions
                          .map(
                            (option) => DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) onSortChanged(val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (lowerQuery.isNotEmpty || selectedSpeciality != 'Semua')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Menampilkan ${results.length} hasil',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textMuted,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
                ? const _EmptyState(
                    title: 'Tidak ada hasil',
                    subtitle:
                        'Coba gunakan kata kunci lain untuk menemukan hunian.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final university = results[index];
                      final isFavorite = favoriteIds.contains(university.id);
                      return UniversityTile(
                        university: university,
                        isFavorite: isFavorite,
                        onToggleFavorite: () => onToggleFavorite(university),
                        showFavoriteButton: false,
                        showPreviewDetails: false,
                        useDarkTheme: isDark,
                        onTap: () => context.findAncestorStateOfType<_AppShellState>()
                            ?._navigateToUniversityDetail(
                              university: university,
                              isFavorite: isFavorite,
                            ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final List<University> favorites;
  final ValueChanged<University> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    if (favorites.isEmpty) {
      return const SafeArea(
        child: _EmptyState(
          title: 'Belum ada favorit',
          subtitle: 'Tambahkan hunian dari tab Beranda atau Cari.',
        ),
      );
    }

    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        itemCount: favorites.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _SectionHeader(
              title: 'Universitas Favorit',
              subtitle: 'Simpan daftar hunian yang ingin kamu pantau.',
            );
          }

          final university = favorites[index - 1];
          return UniversityTile(
            university: university,
            isFavorite: true,
            onToggleFavorite: () => onToggleFavorite(university),
            showPreviewDetails: false,
            useDarkTheme: isDark,
            onTap: () => context.findAncestorStateOfType<_AppShellState>()
                ?._navigateToUniversityDetail(
                  university: university,
                  isFavorite: true,
                ),
          );
        },
      ),
    );
  }
}

class CompareTab extends StatelessWidget {
  const CompareTab({super.key, required this.universities});

  final List<University> universities;

  @override
  Widget build(BuildContext context) {
    return CompareScreen(universities: universities, showAppBar: false);
  }
}

class _HomeCarousel extends StatelessWidget {
  const _HomeCarousel({
    required this.controller,
    required this.filters,
    required this.activeIndex,
    required this.onPageChanged,
    required this.onIndicatorTap,
  });

  final PageController controller;
  final List<_HomeFilterData> filters;
  final int activeIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onIndicatorTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: controller,
            itemCount: filters.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final filter = filters[index];
              return _FilterCard(
                filter: filter,
                isActive: index == activeIndex,
                onTap: () => onIndicatorTap(index),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            filters.length,
            (index) => GestureDetector(
              onTap: () => onIndicatorTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == activeIndex ? 18 : 8,
                height: 6,
                decoration: BoxDecoration(
                  color: index == activeIndex
                      ? AppColors.brand
                      : AppColors.textMuted(context).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.filter,
    required this.isActive,
    required this.onTap,
  });

  final _HomeFilterData filter;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: isActive ? 1 : 0.96,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.border(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (filter.imageUrl.isNotEmpty)
                    Image.asset(
                      filter.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceElevated(context),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.school_outlined,
                          color: AppColors.textMuted(context),
                          size: 36,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: AppColors.surfaceElevated(context),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.school_outlined,
                        color: AppColors.textMuted(context),
                        size: 36,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brand.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter.badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filter.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          filter.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.title,
    required this.subtitle,
    required this.isGrid,
    required this.onListTap,
    required this.onGridTap,
  });

  final String title;
  final String subtitle;
  final bool isGrid;
  final VoidCallback onListTap;
  final VoidCallback onGridTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted(context),
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Row(
            children: [
              _ViewToggleButton(
                icon: Icons.view_agenda_outlined,
                isSelected: !isGrid,
                onTap: onListTap,
              ),
              _ViewToggleButton(
                icon: Icons.grid_view_rounded,
                isSelected: isGrid,
                onTap: onGridTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brand.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color:
              isSelected ? AppColors.brand : AppColors.textMuted(context),
        ),
      ),
    );
  }
}

class _UniversityGridCard extends StatelessWidget {
  const _UniversityGridCard({
    required this.university,
    required this.isFavorite,
    required this.onTap,
  });

  final University university;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated(context),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset(
                        university.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surface(context),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.school_outlined,
                            color: AppColors.textMuted(context),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isFavorite)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 14,
                          color: AppColors.brand,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      university.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textMuted(context),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassTopBar extends StatelessWidget {
  const _GlassTopBar({
    required this.title,
    this.subtitle,
    required this.badgeText,
    this.useBlur = true,
  });

  final String title;
  final String? subtitle;
  final String badgeText;
  final bool useBlur;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary(context),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted(context),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 48,
              color: AppColors.textMuted(context),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

const String _searchIcon =
    '''<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="9" cy="8" r="6" stroke="#B6B6B6" stroke-width="1"/>
  <path d="M13.5 12.5L20 19" stroke="#B6B6B6" stroke-width="1" stroke-linecap="round"/>
</svg>''';
