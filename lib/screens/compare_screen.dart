import 'package:flutter/material.dart';

import '../data/data_universitas.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({
    super.key,
    required this.universities,
    required this.onRemove,
  });

  final List<University> universities;
  final ValueChanged<University> onRemove;

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  late List<University> _universities;

  @override
  void initState() {
    super.initState();
    _universities = List<University>.from(widget.universities);
  }

  void _handleRemove(University university) {
    setState(() {
      _universities.removeWhere((u) => u.id == university.id);
    });
    widget.onRemove(university);

    if (_universities.isEmpty && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = _universities.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text('Bandingkan (${_universities.length})')),
      body: hasSelection
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1AFF7643),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.compare_arrows,
                          color: Color(0xFFFF7643),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Lihat detail kampus secara berdampingan seperti mode banding di situs iPhone. Kamu bisa memilih hingga 3 universitas.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF3D3D3D),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _universities
                          .map(
                            (uni) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _ComparisonCard(
                                university: uni,
                                onRemove: () => _handleRemove(uni),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SpecMatrix(
                    universities: _universities,
                    onRemove: _handleRemove,
                  ),
                ],
              ),
            )
          : const _EmptyCompare(),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.university, required this.onRemove});

  final University university;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Material(
        color: Colors.white,
        elevation: 5,
        shadowColor: const Color(0x22000000),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                university.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: const Color(0xFFF0F0F0),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.school_outlined,
                    size: 40,
                    color: Color(0xFFB6B6B6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1F1F),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF7A7A7A),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          university.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A7A7A),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (university.speciality.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1AFF7643),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        university.speciality,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF7643),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        icon: Icons.account_balance,
                        label: '${university.faculties.length} fakultas',
                      ),
                      _InfoChip(
                        icon: Icons.menu_book_outlined,
                        label: '${university.programs.length} prodi',
                      ),
                      _InfoChip(
                        icon: Icons.apartment_outlined,
                        label: '${university.facilities.length} fasilitas',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onRemove,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text(
                      'Hapus dari compare',
                      style: TextStyle(fontSize: 13),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      labelPadding: const EdgeInsets.only(left: 4, right: 8),
      avatar: Icon(icon, size: 16, color: const Color(0xFF6D6D6D)),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF3D3D3D),
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: const Color(0xFFF5F6F9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _SpecMatrix extends StatelessWidget {
  const _SpecMatrix({required this.universities, required this.onRemove});

  final List<University> universities;
  final ValueChanged<University> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <_SpecRow>[
      _SpecRow('Lokasi', (u) => u.location),
      _SpecRow(
        'Fokus / Keunggulan',
        (u) => u.speciality.isNotEmpty ? u.speciality : '-',
      ),
      _SpecRow(
        'Jumlah Fakultas',
        (u) => u.faculties.isEmpty ? '-' : '${u.faculties.length} fakultas',
      ),
      _SpecRow('Contoh Fakultas', (u) => _formatList(u.faculties)),
      _SpecRow('Program Studi', (u) => _formatList(u.programs)),
      _SpecRow('Fasilitas', (u) => _formatList(u.facilities)),
      _SpecRow(
        'Deskripsi',
        (u) => u.description.isNotEmpty ? u.description : '-',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 32,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE9E9E9)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 140,
                    child: Text(
                      'Spesifikasi',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  ...universities.map(
                    (uni) => Container(
                      width: 200,
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              uni.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => onRemove(uni),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFF8A8A8A),
                            ),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Material(
              color: Colors.white,
              elevation: 3,
              shadowColor: const Color(0x11000000),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: rows
                    .map(
                      (row) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: rows.last == row
                                  ? Colors.transparent
                                  : const Color(0xFFE9E9E9),
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140,
                              child: Text(
                                row.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3D3D3D),
                                ),
                              ),
                            ),
                            ...universities.map(
                              (uni) => Container(
                                width: 200,
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  row.valueBuilder(uni),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF4A4A4A),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecRow {
  const _SpecRow(this.title, this.valueBuilder);

  final String title;
  final String Function(University) valueBuilder;
}

class _EmptyCompare extends StatelessWidget {
  const _EmptyCompare();

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
              Icons.compare_arrows,
              size: 56,
              color: Color(0xFFBEBEBE),
            ),
            const SizedBox(height: 14),
            Text(
              'Belum ada universitas untuk dibandingkan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1F1F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih tombol compare di kartu universitas untuk mulai membandingkan.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF7A7A7A),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatList(List<String> values) {
  if (values.isEmpty) return '-';
  if (values.length <= 3) return values.join(', ');
  final preview = values.take(3).join(', ');
  final remaining = values.length - 3;
  return '$preview +$remaining lain';
}
