import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? filledColor;
  final Color? emptyColor;
  final bool showValue;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.filledColor,
    this.emptyColor,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(
              Icons.star_rounded,
              size: size,
              color: filledColor ?? AppColors.starFilled,
            );
          } else if (index < rating) {
            return Icon(
              Icons.star_half_rounded,
              size: size,
              color: filledColor ?? AppColors.starFilled,
            );
          } else {
            return Icon(
              Icons.star_outline_rounded,
              size: size,
              color: emptyColor ?? AppColors.starEmpty,
            );
          }
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.75,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
