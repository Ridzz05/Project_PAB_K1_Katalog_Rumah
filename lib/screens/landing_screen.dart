import 'dart:ui';

import 'package:flutter/material.dart';

const _brandColor = Color(0xFFFF7643);
const _deepNavy = Color(0xFF0E0C24);
const _midnight = Color(0xFF0F1F37);
const _royalPurple = Color(0xFF1C2448);

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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _deepNavy,
                _midnight,
                _royalPurple,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -120,
                right: -60,
                child: _GlowCircle(
                  diameter: 320,
                  colors: [
                    _brandColor.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
              Positioned(
                bottom: -100,
                left: -40,
                child: _GlowCircle(
                  diameter: 260,
                  colors: [
                    const Color(0xFF5D5FEF).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.04),
                        Colors.black.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            _brandColor,
                            Color(0xFFFF9E58),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _brandColor.withValues(alpha: 0.5),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _HighlightBadges(),
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
                              final isActive =
                                  (index % _slides.length) == _currentPage;
                              return AnimatedPadding(
                                duration: const Duration(milliseconds: 240),
                                padding: EdgeInsets.only(
                                  right: 12,
                                  left: index == 0 ? 4 : 0,
                                  top: isActive ? 0 : 12,
                                  bottom: isActive ? 6 : 20,
                                ),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 240),
                                  scale: isActive ? 1 : 0.95,
                                  child: _SlideCard(slide: slide, isActive: isActive),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 30,
                            child: _NavButton(
                              icon: Icons.chevron_left_rounded,
                              onTap: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 30,
                            child: _NavButton(
                              icon: Icons.chevron_right_rounded,
                              onTap: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: isActive ? 10 : 8,
                          width: isActive ? 26 : 10,
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? LinearGradient(
                                    colors: [
                                      _slides[index].accent,
                                      Colors.white.withValues(alpha: 0.85),
                                    ],
                                  )
                                : null,
                            color: isActive ? null : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: _slides[index].accent.withValues(alpha: 0.5),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                    _GradientButton(
                      label: 'Masuk & Mulai Eksplor',
                      onTap: widget.onLogin,
                      icon: Icons.arrow_forward_rounded,
                    ),
                    const SizedBox(height: 12),
                    _OutlinedGlassButton(
                      label: 'Daftar Sekarang',
                      onTap: widget.onSignUp,
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: TextButton(
                        onPressed: widget.onStart,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.72),
                        ),
                        child: const Text('Lihat katalog tanpa login'),
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

class _HighlightBadges extends StatelessWidget {
  const _HighlightBadges();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: const [
        _GlassPill(text: 'Kurasi lokal Sumsel', icon: Icons.map_rounded),
        _GlassPill(text: 'Favorit & compare instan', icon: Icons.star_rounded),
      ],
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt_rounded,
                  color: slide.accent.withValues(alpha: 0.9), size: 16),
              const SizedBox(width: 6),
              Text(
                'Highlight',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.diameter, required this.colors});

  final double diameter;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            _brandColor,
            Color(0xFFFF9E58),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _brandColor.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_open_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, color: Colors.white),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedGlassButton extends StatelessWidget {
  const _OutlinedGlassButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.06),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_alt_1_rounded,
                      color: Colors.white.withValues(alpha: 0.9)),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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
  const _SlideCard({required this.slide, required this.isActive});

  final _Slide slide;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                slide.asset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF111423),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.school_outlined,
                    color: Color(0xFF7A85A0),
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
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _GlassBadge(slide: slide),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: slide.accent.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: slide.accent.withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
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
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slide.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.2,
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
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
      color: Colors.white.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
