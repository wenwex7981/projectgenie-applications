import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';

enum CustomButtonType { primary, secondary, outlined, text }
enum CustomButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();
    final padding = _getPadding();
    final textStyle = _getTextStyle();
    final radius = borderRadius ?? AppConstants.radiusMD;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == CustomButtonType.primary
                    ? AppColors.textOnPrimary
                    : AppColors.accent,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _getIconSize()),
                const SizedBox(width: 8),
              ],
              Text(label, style: textStyle),
            ],
          );

    Widget button;

    switch (type) {
      case CustomButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnPrimary,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            elevation: 0,
          ),
          child: child,
        );
        break;

      case CustomButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent.withOpacity(0.1),
            foregroundColor: AppColors.accent,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            elevation: 0,
          ),
          child: child,
        );
        break;

      case CustomButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            side: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          child: child,
        );
        break;

      case CustomButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            padding: padding,
          ),
          child: child,
        );
        break;
    }

    return button;
  }

  double _getHeight() {
    switch (size) {
      case CustomButtonSize.small:
        return 36;
      case CustomButtonSize.medium:
        return 48;
      case CustomButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case CustomButtonSize.small:
        return AppTypography.buttonSmall;
      case CustomButtonSize.medium:
        return AppTypography.buttonMedium;
      case CustomButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomButtonSize.small:
        return 16;
      case CustomButtonSize.medium:
        return 20;
      case CustomButtonSize.large:
        return 24;
    }
  }
}
