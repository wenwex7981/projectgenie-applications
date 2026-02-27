import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.accent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(
            color: cardColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              ),
              child: Icon(icon, color: cardColor, size: 24),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
