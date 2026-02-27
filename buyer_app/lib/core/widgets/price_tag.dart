import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PriceTag extends StatelessWidget {
  final String price;
  final String? originalPrice;
  final PriceTagSize size;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.size = PriceTagSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₹$price',
          style: _getPriceStyle(),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 6),
          Text(
            '₹$originalPrice',
            style: _getOriginalPriceStyle(),
          ),
        ],
      ],
    );
  }

  TextStyle _getPriceStyle() {
    switch (size) {
      case PriceTagSize.small:
        return AppTypography.priceSmall;
      case PriceTagSize.medium:
        return AppTypography.priceMedium;
      case PriceTagSize.large:
        return AppTypography.priceLarge;
    }
  }

  TextStyle _getOriginalPriceStyle() {
    final fontSize = size == PriceTagSize.large ? 16.0 : (size == PriceTagSize.medium ? 14.0 : 12.0);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textTertiary,
      decoration: TextDecoration.lineThrough,
      decorationColor: AppColors.textTertiary,
    );
  }
}

enum PriceTagSize { small, medium, large }
