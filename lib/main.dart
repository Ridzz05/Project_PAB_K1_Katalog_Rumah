import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth/auth.dart';
import 'components/bottom_nav.dart';
import 'data/data_universitas.dart';
import 'screens/compare_screen.dart';
import 'screens/detail_screens.dart';
import 'screens/profile_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _authController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniFinder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF7643),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F1F1F),
            centerTitle: false,
            titleSpacing: 20,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: auth.isAuthenticated
          ? AppShell(key: const ValueKey('app-shell'), onLogout: auth.logout)
          : SignInScreen(
              key: const ValueKey('sign-in'),
              onSubmit: auth.login,
              isLoading: auth.isLoading,
              onRegister: auth.register,
              errorMessage: auth.errorMessage,
            ),
    );
  }
}

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope.of() called with no AuthScope in context');
    return scope!.notifier!;
  }
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
  late final TextEditingController _searchController;
  String _searchQuery = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _favoriteIds.addAll(
      demoUniversities.where((uni) => uni.isFavorite).map((uni) => uni.id),
    );
    _searchController = TextEditingController();
    _searchController.addListener(_handleSearchChange);
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
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final tabs = <Widget>[
      HomeTab(
        universities: demoUniversities,
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
      ),
      SearchTab(
        universities: demoUniversities,
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        controller: _searchController,
        query: _searchQuery,
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
  });

  final List<University> universities;
  final Set<int> favoriteIds;
  final ValueChanged<University> onToggleFavorite;
  final TextEditingController controller;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowerQuery = query.toLowerCase();
    final results = lowerQuery.isEmpty
        ? universities
        : universities
              .where(
                (uni) =>
                    uni.name.toLowerCase().contains(lowerQuery) ||
                    uni.location.toLowerCase().contains(lowerQuery),
              )
              .toList();

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
                    searchIcon,
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
          if (lowerQuery.isNotEmpty)
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

// TODO: MENAMBAHKAN Grid View Dengan Button Toggle Pada UniversityTile Untuk MengGanti View Dari GridView Ke ListView dan Sebaliknya
// ListView
class UniversityTile extends StatelessWidget {
  const UniversityTile({
    super.key,
    required this.university,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onTap,
    this.showFavoriteButton = true,
    this.showPreviewDetails = true,
  });

  final University university;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool showPreviewDetails;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9E9E9)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  university.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: const Color(0xFFF0F0F0),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.school_outlined,
                      color: Color(0xFFB6B6B6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (showPreviewDetails)
                      Text(
                        university.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A7A7A),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        'lihat detail lengkap',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A7A7A),
                          height: 1.4,
                        ),
                      ),
                    if (showPreviewDetails &&
                        university.speciality.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        university.speciality,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF7643),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFavoriteButton)
                    IconButton(
                      onPressed: onToggleFavorite,
                      iconSize: 22,
                      splashRadius: 20,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? const Color(0xFFFF7643)
                            : const Color(0xFFB6B6B6),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onTap,
                iconSize: 22,
                splashRadius: 20,
                icon: const Icon(Icons.chevron_right, color: Color(0xFFB6B6B6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String searchIcon =
    '''<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="9" cy="8" r="6" stroke="#B6B6B6" stroke-width="1"/>
  <path d="M13.5 12.5L20 19" stroke="#B6B6B6" stroke-width="1" stroke-linecap="round"/>
</svg>''';
