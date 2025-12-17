import 'package:flutter/material.dart';

const _brandColor = Color(0xFFFF7643);
const _mutedText = Color(0xFF6B6B6B);

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
  final PageController _pageController = PageController();
  final List<_Slide> _slides = const [
    _Slide(
      title: 'Selamat Datang',
      subtitle: 'Universitas pilihan Sumatera Selatan dalam satu aplikasi.',
      asset: 'images/unifind.jpg',
    ),
    _Slide(
      title: 'Jelajahi Kampus',
      subtitle: 'Lihat ringkasan kampus, program studi, dan fasilitasnya.',
      asset: 'images/univ_preview/mdp.png',
    ),
    _Slide(
      title: 'Bandingkan & Simpan',
      subtitle: 'Bandingkan 2 kampus sekaligus lalu simpan favoritmu.',
      asset: 'images/univ_preview/unsri.png',
    ),
  ];

  int _currentPage = 0;

  void _handlePrimaryAction() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onStart();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  color: _brandColor.withOpacity(0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _brandColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'UniFinder',
                      style: TextStyle(
                        color: _brandColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _slides.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              slide.subtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _mutedText,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Expanded(
                              child: Container(
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
                                  child: Image.asset(
                                    slide.asset,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
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
                              ),
                            ),
                          ],
                        );
                      },
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
                          color:
                              isActive ? _brandColor : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handlePrimaryAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(52),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Mulai sekarang'
                            : 'Lanjut',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onLogin,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _brandColor,
                            side: const BorderSide(
                              color: _brandColor,
                              width: 1.4,
                            ),
                            minimumSize: const Size.fromHeight(50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
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
  });

  final String title;
  final String subtitle;
  final String asset;
}
