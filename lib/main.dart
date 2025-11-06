import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth/auth.dart';
import 'components/bottom_nav.dart';
import 'data/data_universitas.dart';
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
        title: 'Katalog Rumah',
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
            centerTitle: true,
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
    'Cari Rumah',
    'Favorit',
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
  bool _useGrid = false;

  void _toggleLayout() {
    setState(() => _useGrid = !_useGrid);
  }

  @override
  Widget build(BuildContext context) {
    final universities = widget.universities;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: _SectionHeader(
                    title: 'Daftar Rumah',
                    subtitle:
                        'Lihat ringkasan hunian pilihan sebelum membuka detailnya.',
                  ),
                ),
                const SizedBox(width: 12),
                _LayoutToggleButton(isGrid: _useGrid, onPressed: _toggleLayout),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _useGrid
                  ? _HomeGridView(
                      key: const ValueKey('home-grid'),
                      universities: universities,
                      favoriteIds: widget.favoriteIds,
                      onToggleFavorite: widget.onToggleFavorite,
                    )
                  : _HomeListView(
                      key: const ValueKey('home-list'),
                      universities: universities,
                      favoriteIds: widget.favoriteIds,
                      onToggleFavorite: widget.onToggleFavorite,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeListView extends StatelessWidget {
  const _HomeListView({
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
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: universities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final university = universities[index];
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
    );
  }
}

class _HomeGridView extends StatelessWidget {
  const _HomeGridView({
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
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: universities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final university = universities[index];
        final isFavorite = favoriteIds.contains(university.id);
        return UniversityGridCard(
          university: university,
          isFavorite: isFavorite,
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
    );
  }
}

class _LayoutToggleButton extends StatelessWidget {
  const _LayoutToggleButton({required this.isGrid, required this.onPressed});

  final bool isGrid;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = isGrid ? Icons.view_agenda_rounded : Icons.grid_view_rounded;
    final tooltip = isGrid ? 'Tampilkan daftar' : 'Tampilkan grid';

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        color: const Color(0xFF757575),
        tooltip: tooltip,
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
                hintText: 'Cari rumah...',
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
              title: 'Rumah Favorit',
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
    final theme = Theme.of(context);
    final imageProvider = _imageProviderFor(university);
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
                child: Image(
                  image: imageProvider,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
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
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (showPreviewDetails)
                      Text(
                        university.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF7A7A7A),
                        ),
                      )
                    else
                      Text(
                        'lihat detail lengkap',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF7A7A7A),
                        ),
                      ),
                    if (showPreviewDetails &&
                        university.speciality.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        university.speciality,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFFF7643),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (showFavoriteButton) ...[
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
                const SizedBox(width: 4),
              ],
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

class UniversityGridCard extends StatelessWidget {
  const UniversityGridCard({
    super.key,
    required this.university,
    required this.isFavorite,
    required this.onTap,
  });

  final University university;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageProvider = _imageProviderFor(university);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFF0F0F0),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.school_outlined,
                        color: Color(0xFFB6B6B6),
                        size: 32,
                      ),
                    ),
                  ),
                ),
                if (isFavorite)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0x59000000),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        decoration: const BoxDecoration(
                          color: Color(0x80FFFFFF),
                          border: Border(
                            top: BorderSide(
                              color: Color(0x66FFFFFF),
                              width: 0.75,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              university.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F1F1F),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'lihat detail lengkap',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF555555),
                                fontWeight: FontWeight.w500,
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
      ),
    );
  }
}

class UniversityDetailScreen extends StatelessWidget {
  const UniversityDetailScreen({
    super.key,
    required this.university,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final University university;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final otherUniversities = demoUniversities
        .where((uni) => uni.id != university.id)
        .take(3)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: _imageProviderFor(university),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(
                        Icons.school_outlined,
                        size: 100,
                        color: Color(0xFFB6B6B6),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, const Color(0x4D000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Color(0xFF7A7A7A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        university.location,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),
                    ],
                  ),
                  if (university.speciality.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1AFF7643),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        university.speciality,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF7643),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    university.description.isNotEmpty
                        ? university.description
                        : 'Tidak ada deskripsi tersedia untuk hunian ini.',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A4A4A),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Rumah Lainnya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...otherUniversities.map(
                    (otherUni) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: UniversityTile(
                        university: otherUni,
                        isFavorite: false,
                        onToggleFavorite: () {},
                        showFavoriteButton: false,
                        showPreviewDetails: false,
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => UniversityDetailScreen(
                                university: otherUni,
                                isFavorite: false,
                                onToggleFavorite: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

ImageProvider<Object> _imageProviderFor(University university) {
  if (university.isAsset) {
    return AssetImage(university.imageUrl);
  }
  return NetworkImage(university.imageUrl);
}

const String searchIcon =
    '''<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="9" cy="8" r="6" stroke="#B6B6B6" stroke-width="1"/>
  <path d="M13.5 12.5L20 19" stroke="#B6B6B6" stroke-width="1" stroke-linecap="round"/>
</svg>''';
