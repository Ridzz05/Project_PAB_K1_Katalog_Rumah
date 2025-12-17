import 'package:flutter/material.dart';

import '../data/data_universitas.dart';

// TODO: MENAMBAHKAN Grid View Dengan Button Toggle Pada UniversityTile Untuk MengGanti View Dari GridView Ke ListView dan Sebaliknya
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
