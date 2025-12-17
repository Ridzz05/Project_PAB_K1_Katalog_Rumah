import 'package:flutter/material.dart';

const _brandColor = Color(0xFFFF7643);
class LandingScreen extends StatefulWidget {
  const LandingScreen({
    super.key,
    required this.onStart,
    required this.onLogin,
    required this.onSignUp,
  });

  final VoidCallback onStart;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const int _loopOffsetMultiplier = 100;
  late final PageController _pageController;
  late final int _initialPage;
  final List<_Slide> _slides = const [
    _Slide(
      title: 'Selamat Datang',
      subtitle: 'Universitas pilihan Sumatera Selatan dalam satu aplikasi.',
      asset: 'images/unifind.jpg',
      badge: 'UniFinder',
      accent: Color(0xFFFF7643),
    ),
    _Slide(
      title: 'Jelajahi Kampus',
      subtitle: 'Lihat ringkasan kampus, program studi, dan fasilitasnya.',
      asset: 'images/univ_preview/mdp.png',
      badge: 'Kurasi Lokal',
      accent: Color(0xFF0EB2A6),
    ),
    _Slide(
      title: 'Bandingkan & Simpan',
      subtitle: 'Buat shortlist, bandingkan 2 kampus, lalu tandai favoritmu.',
      asset: 'images/univ_preview/unsri.png',
      badge: 'Favorit & Compare',
      accent: Color(0xFF5D5FEF),
    ),
    _Slide(
      title: 'Mulai Tanpa Ribet',
      subtitle: 'Masuk atau daftar gratis, lalu jelajahi peluangmu sekarang.',
      asset: 'images/univ_preview/polsri.jpg',
      badge: 'Gratis Daftar',
      accent: Color(0xFFEF5DA8),
    ),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initialPage = _slides.length * _loopOffsetMultiplier;
    _currentPage = _initialPage % _slides.length;
    _pageController = PageController(
      viewportFraction: 0.9,
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: -80,
              top: -40,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1AFF7643),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: 100,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _brandColor.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'UniFinder',
                    style: TextStyle(
                      color: _brandColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index % _slides.length;
                            });
                          },
                          itemBuilder: (context, index) {
                            final slide = _slides[index % _slides.length];
                            final isActive = (index % _slides.length) == _currentPage;
                            return AnimatedPadding(
                              duration: const Duration(milliseconds: 220),
                              padding: EdgeInsets.only(
                                right: 12,
                                left: index == 0 ? 4 : 0,
                                top: isActive ? 0 : 10,
                                bottom: isActive ? 4 : 16,
                              ),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 220),
                                scale: isActive ? 1 : 0.96,
                                child: _SlideCard(slide: slide),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 20,
                          child: _NavButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 20,
                          child: _NavButton(
                            icon: Icons.chevron_right_rounded,
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 22 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? _slides[index].accent
                              : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(52),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: widget.onSignUp,
                      style: TextButton.styleFrom(
                        foregroundColor: _brandColor,
                        minimumSize: const Size.fromHeight(50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.badge,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String asset;
  final String badge;
  final Color accent;
}

class _SlideCard extends StatelessWidget {
  const _SlideCard({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                slide.asset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFF5F5F5),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.school_outlined,
                    color: Color(0xFFB6B6B6),
                    size: 48,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: slide.accent.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      slide.badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    slide.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slide.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: _brandColor,
          ),
        ),
      ),
    );
  }
}
