import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_scope.dart';
import '../components/bottom_nav.dart';
import '../components/university_tile.dart';
import '../data/data_universitas.dart';
import 'compare_screen.dart';
import 'detail_screens.dart';
import 'profile_screens.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: BottomNavScreen(
        currentIndex: _currentIndex,
        onTap: _handleTabSelect,
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        itemCount: universities.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _SectionHeader(
              title: 'Daftar Universitas',
              subtitle:
                  'Lihat ringkasan hunian pilihan sebelum membuka detailnya.',
            );
          }

          final university = universities[index - 1];
          final isFavorite = favoriteIds.contains(university.id);
          return UniversityTile(
            university: university,
            isFavorite: isFavorite,
            onToggleFavorite: () => onToggleFavorite(university),
            showFavoriteButton: false,
            showPreviewDetails: false,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UniversityDetailScreen(
                  university: university,
                  isFavorite: isFavorite,
                  onToggleFavorite: () => onToggleFavorite(university),
                ),
              ),
            ),
          );
        },
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
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: SvgPicture.string(
                    _searchIcon,
                    width: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF959595),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                hintText: 'Cari Universitas...',
                hintStyle: const TextStyle(color: Color(0xFF9F9F9F)),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
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
                        selectedColor:
                            const Color(0xFFFF7643).withValues(alpha: 0.16),
                        backgroundColor: const Color(0xFFF3F3F3),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFFFF7643)
                              : const Color(0xFF5A5A5A),
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
                    const Text(
                      'Urutkan:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedSort,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                  color: const Color(0xFF959595),
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
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UniversityDetailScreen(
                              university: university,
                              isFavorite: isFavorite,
                              onToggleFavorite: () =>
                                  onToggleFavorite(university),
                            ),
                          ),
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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UniversityDetailScreen(
                  university: university,
                  isFavorite: true,
                  onToggleFavorite: () => onToggleFavorite(university),
                ),
              ),
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
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8A8A8A),
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
            const Icon(
              Icons.school_outlined,
              size: 48,
              color: Color(0xFFBEBEBE),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C2C2C),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF8A8A8A),
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
