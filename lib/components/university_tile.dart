import 'package:flutter/material.dart';

import '../data/data_universitas.dart';
import '../theme/app_colors.dart';

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
    this.useDarkTheme = false,
  });

  final University university;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool showPreviewDetails;
  final bool useDarkTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = useDarkTheme || AppColors.isDark(context);
    final backgroundColor =
        isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.lightBorder;
    final titleColor =
        isDark ? AppColors.darkText : AppColors.lightText;
    final subtitleColor =
        isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final mutedIconColor =
        isDark ? const Color(0xFF93A4C3) : const Color(0xFFB6B6B6);
    final placeholderColor =
        isDark ? const Color(0xFF1F2A44) : const Color(0xFFF0F0F0);
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
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
                    color: placeholderColor,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.school_outlined,
                      color: mutedIconColor,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (showPreviewDetails)
                      Text(
                        university.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: subtitleColor,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        'lihat detail lengkap',
                        style: TextStyle(
                          fontSize: 13,
                          color: subtitleColor,
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
                          color: AppColors.brand,
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
                            ? AppColors.brand
                            : mutedIconColor,
                        ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onTap,
                iconSize: 22,
                splashRadius: 20,
                icon: Icon(Icons.chevron_right, color: mutedIconColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
