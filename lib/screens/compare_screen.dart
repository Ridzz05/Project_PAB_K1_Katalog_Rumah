import 'package:flutter/material.dart';

import '../data/data_universitas.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({
    super.key,
    required this.universities,
    this.showAppBar = true,
  });

  final List<University> universities;
  final bool showAppBar;

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  late University _left;
  late University _right;

  @override
  void initState() {
    super.initState();
    final all = widget.universities;
    _left = all.isNotEmpty ? all.first : _placeholder();
    _right = all.length > 1 ? all[1] : _placeholder();
  }

  University _placeholder() => const University(
    id: -1,
    name: 'Pilih Universitas',
    location: '',
    imageUrl: 'images/univ_preview/mdp.png',
  );

  void _setSelection({required bool isLeft, required University value}) {
    if (value.id == _left.id && value.id == _right.id) return;
    if (isLeft && value.id == _right.id || !isLeft && value.id == _left.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Universitas sudah dipakai di kolom lain.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      if (isLeft) {
        _left = value;
      } else {
        _right = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Selector(
                  label: 'Pilihan kiri',
                  value: _left,
                  options: widget.universities,
                  onChanged: (u) => _setSelection(isLeft: true, value: u),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Selector(
                  label: 'Pilihan kanan',
                  value: _right,
                  options: widget.universities,
                  onChanged: (u) => _setSelection(isLeft: false, value: u),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _HeroCard(university: _left)),
              const SizedBox(width: 16),
              Expanded(child: _HeroCard(university: _right)),
            ],
          ),
          const SizedBox(height: 24),
          _SpecMatrix(universities: [_left, _right]),
        ],
      ),
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bandingkan')),
        body: content,
      );
    }
    return SafeArea(
      child: content,
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final University value;
  final List<University> options;
  final ValueChanged<University> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<University>(
      initialValue: options.firstWhere(
        (u) => u.id == value.id,
        orElse: () => options.first,
      ),
      items: options
          .map(
            (u) => DropdownMenuItem(
              value: u,
              child: Text(
                u.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
      dropdownColor: const Color(0xFF0F172A),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFF111A2E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.32)),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      elevation: 5,
      shadowColor: const Color(0x22000000),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(
                  university.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF0F0F0),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.school_outlined,
                      size: 48,
                      color: Color(0xFFB6B6B6),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              university.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1F1F),
              ),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpecMatrix extends StatelessWidget {
  const _SpecMatrix({required this.universities});

  final List<University> universities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <_SpecRow>[
      _SpecRow('Lokasi', (u) => u.location),
      _SpecRow(
        'Fokus / Keunggulan',
        (u) => u.speciality.isEmpty ? '-' : u.speciality,
      ),
      _SpecRow('Fakultas', (u) => _formatList(u.faculties)),
      _SpecRow('Program Studi', (u) => _formatList(u.programs)),
      _SpecRow('Fasilitas', (u) => _formatList(u.facilities)),
      _SpecRow('Deskripsi', (u) => u.description.isEmpty ? '-' : u.description),
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
                      child: Text(
                        uni.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F1F1F),
                        ),
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

String _formatList(List<String> values) {
  if (values.isEmpty) return '-';
  if (values.length <= 3) return values.join(', ');
  final preview = values.take(3).join(', ');
  final remaining = values.length - 3;
  return '$preview +$remaining lain';
}
