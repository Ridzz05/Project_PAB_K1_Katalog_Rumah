import 'package:flutter/material.dart';
import '../data/data_universitas.dart';
import '../main.dart';

class UniversityDetailScreen extends StatefulWidget {
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
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  late bool _isFavorite;
  bool _showSuccessAlert = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _handleToggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _showSuccessAlert = true;
    });
    widget.onToggleFavorite();
    
    // Hide alert after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSuccessAlert = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final otherUniversities = demoUniversities
        .where((uni) => uni.id != widget.university.id)
        .take(3)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
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
                      Image.asset(
                        widget.university.imageUrl,
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
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: _handleToggleFavorite,
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
                        widget.university.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: Color(0xFF7A7A7A),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.university.location,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF7A7A7A),
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (widget.university.speciality.isNotEmpty) ...[
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
                            widget.university.speciality,
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
                        widget.university.description.isNotEmpty
                            ? widget.university.description
                            : 'Tidak ada deskripsi tersedia untuk universitas ini.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF4A4A4A),
                          height: 1.6,
                        ),
                      ),
                      if (widget.university.faculties.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Fakultas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.university.faculties.map(
                          (faculty) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.school,
                                  size: 18,
                                  color: Color(0xFF757575),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    faculty,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (widget.university.programs.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Program Studi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.university.programs.map(
                          (program) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.book,
                                  size: 18,
                                  color: Color(0xFF757575),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    program,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (widget.university.facilities.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Text(
                          'Fasilitas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.university.facilities.map(
                            (facility) => Chip(
                              label: Text(
                                facility,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: const Color(0xFFF5F6F9),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _handleToggleFavorite,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFavorite
                                ? const Color(0xFFFF7643)
                                : Colors.white,
                            foregroundColor: _isFavorite
                                ? Colors.white
                                : const Color(0xFFFF7643),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: _isFavorite
                                    ? Colors.transparent
                                    : const Color(0xFFFF7643),
                                width: 2,
                              ),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 22,
                          ),
                          label: Text(
                            _isFavorite
                                ? 'Hapus dari Favorit'
                                : 'Tambah ke Favorit',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Universitas Lainnya',
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
                                    onToggleFavorite: widget.onToggleFavorite,
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
          // Success Alert Animation at Bottom
          if (_showSuccessAlert)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _SuccessAlert(
                message: _isFavorite
                    ? 'Berhasil ditambahkan ke favorit!'
                    : 'Dihapus dari favorit',
                isFavorite: _isFavorite,
              ),
            ),
        ],
      ),
    );
  }
}

class _SuccessAlert extends StatefulWidget {
  const _SuccessAlert({
    required this.message,
    required this.isFavorite,
  });

  final String message;
  final bool isFavorite;

  @override
  State<_SuccessAlert> createState() => _SuccessAlertState();
}

class _SuccessAlertState extends State<_SuccessAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isFavorite
                        ? const Color(0x1AFF7643)
                        : const Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.isFavorite
                        ? const Color(0xFFFF7643)
                        : const Color(0xFF9E9E9E),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F1F1F),
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

