import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';
import '../models/models.dart';
import 'app_network_image.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel? service;
  final String title;
  final String vendorName;
  final String price;
  final double rating;
  final int reviewCount;
  final String deliveryDays;
  final String imageUrl;
  final VoidCallback? onTap;
  final String heroTag;

  const ServiceCard({
    super.key,
    this.service,
    this.title = '',
    this.vendorName = '',
    this.price = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.deliveryDays = '',
    this.imageUrl = '',
    this.onTap,
    this.heroTag = '',
  });

  String get _title => service?.title ?? title;
  String get _vendorName => service?.vendorName ?? vendorName;
  String get _price => service?.price ?? price;
  double get _rating => service?.rating ?? rating;
  int get _reviewCount => service?.reviewCount ?? reviewCount;
  String get _deliveryDays => service?.deliveryDays ?? deliveryDays;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag.isNotEmpty ? heroTag : 'service_${_title}',
              child: Stack(
                children: [
                  AppNetworkImage(
                    imageUrl: (service?.imageUrl != null && service!.imageUrl!.isNotEmpty) ? service!.imageUrl! : getProjectImage(_title),
                    width: double.infinity,
                    height: 160,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLG)),
                  ),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLG)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title, style: AppTypography.subheadingLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(_vendorName, style: AppTypography.bodySmall),
                  const SizedBox(height: AppConstants.spacingSM),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.starFilled),
                      const SizedBox(width: 4),
                      Text(_rating.toStringAsFixed(1), style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text(' ($_reviewCount)', style: AppTypography.caption),
                      const Spacer(),
                      const Icon(Icons.download_rounded, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(_deliveryDays, style: AppTypography.caption),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingMD),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹$_price', style: AppTypography.priceMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppConstants.radiusSM)),
                        child: Text('Buy Now', style: AppTypography.buttonSmall.copyWith(color: AppColors.textOnPrimary)),
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

class ServiceCardHorizontal extends StatelessWidget {
  final String title;
  final String vendorName;
  final String price;
  final double rating;
  final String deliveryDays;
  final VoidCallback? onTap;

  const ServiceCardHorizontal({
    super.key,
    required this.title,
    required this.vendorName,
    required this.price,
    required this.rating,
    required this.deliveryDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                children: [
                   AppNetworkImage(
                      imageUrl: imageUrl.isNotEmpty ? imageUrl : getProjectImage(title),
                      width: double.infinity,
                      height: 120,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLG)),
                   ),
                   Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLG)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                      ),
                    ),
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('₹$price', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.subheadingMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(vendorName, style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.starFilled),
                      const SizedBox(width: 2),
                      Text(rating.toStringAsFixed(1), style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const Spacer(),
                      const Icon(Icons.download_rounded, size: 12, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(deliveryDays, style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w500, fontSize: 10)),
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

/// Maps project titles to relevant tech stock images
String getProjectImage(String title) {
  final t = title.toLowerCase();
  
  // Base URL for consistent reliable images (using specific IDs to avoid 404s)
  // We use high-quality Unsplash images that are known to work
  
  if (t.contains('cancer') || t.contains('disease') || t.contains('health') || t.contains('heart')) {
    return 'https://images.unsplash.com/photo-1576091160550-2187d80a18f7?auto=format&fit=crop&q=80&w=800'; // Medical/Doctor
  } else if (t.contains('traffic') || t.contains('vehicle') || t.contains('yolo')) {
    return 'https://images.unsplash.com/photo-1565514020126-db26b2b73c4d?auto=format&fit=crop&q=80&w=800'; // Traffic
  } else if (t.contains('face') || t.contains('recognition') || t.contains('vision')) {
    return 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?auto=format&fit=crop&q=80&w=800'; // AI Vision
  } else if (t.contains('news') || t.contains('nlp') || t.contains('text') || t.contains('fake')) {
    return 'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?auto=format&fit=crop&q=80&w=800'; // News/Text
  } else if (t.contains('stock') || t.contains('predict') || t.contains('price') || t.contains('finance')) {
    return 'https://images.unsplash.com/photo-1611974765270-ca12586343bb?auto=format&fit=crop&q=80&w=800'; // Stock Chart
  } else if (t.contains('cloud') || t.contains('erp') || t.contains('aws')) {
    return 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=800'; // Tech/Cloud
  } else if (t.contains('blockchain') || t.contains('voting') || t.contains('crypto')) {
    return 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&q=80&w=800'; // Blockchain
  } else if (t.contains('crop') || t.contains('agriculture') || t.contains('plant')) {
    return 'https://images.unsplash.com/photo-1625246333195-09d9d8855404?auto=format&fit=crop&q=80&w=800'; // Plants/Farming
  } else if (t.contains('weather') || t.contains('climate')) {
    return 'https://images.unsplash.com/photo-1592210454359-9043f067919b?auto=format&fit=crop&q=80&w=800'; // Weather
  } else if (t.contains('flutter') || t.contains('app') || t.contains('mobile')) {
    return 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&q=80&w=800'; // Mobile App
  } else if (t.contains('react') || t.contains('web') || t.contains('calculator')) {
    return 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?auto=format&fit=crop&q=80&w=800'; // React/Code
  } else if (t.contains('robot') || t.contains('iot') || t.contains('arduino')) {
    return 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&q=80&w=800'; // Robotics
  } else if (t.contains('security') || t.contains('cyber')) {
    return 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=800'; // Security
  } else {
    // Default fallback image (Abstract Tech)
    return 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=800';
  }
}
