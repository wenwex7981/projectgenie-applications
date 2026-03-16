import 'package:flutter/material.dart';
import '../../features/profile/agency_profile_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/rating_stars.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/models/models.dart';
import '../cart/cart_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;
  final String heroTag;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    this.heroTag = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    boxShadow: [
                      BoxShadow(color: AppColors.shadow, blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.favorite_border_rounded, size: 20),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                    boxShadow: [
                      BoxShadow(color: AppColors.shadow, blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.share_outlined, size: 20),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: heroTag.isNotEmpty ? heroTag : 'service_${service.title}',
                child: service.imageUrl != null && service.imageUrl!.isNotEmpty
                    ? Image.network(
                        service.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.accent.withOpacity(0.15),
                                AppColors.secondary.withOpacity(0.15),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.description_outlined,
                              size: 80,
                              color: AppColors.accent.withOpacity(0.3),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.accent.withOpacity(0.15),
                              AppColors.secondary.withOpacity(0.15),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.description_outlined,
                            size: 80,
                            color: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                      ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      service.category,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    service.title,
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 12),

                  // Rating & Reviews
                  Row(
                    children: [
                      RatingStars(rating: service.rating, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${service.rating}',
                        style: AppTypography.subheadingMedium,
                      ),
                      Text(
                        ' (${service.reviewCount} reviews)',
                        style: AppTypography.bodySmall,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.deliveryDays,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${service.price}',
                        style: AppTypography.priceLarge,
                      ),
                      if (service.originalPrice.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Text(
                          '₹${service.originalPrice}',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textTertiary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'SAVE',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppConstants.spacingXXL),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Description
                  Text('Description', style: AppTypography.headingSmall),
                  const SizedBox(height: 12),
                  Text(
                    service.description,
                    style: AppTypography.bodyMedium.copyWith(height: 1.7),
                  ),

                  if (service.features.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spacingXXL),
                    Text('What\'s Included', style: AppTypography.headingSmall),
                    const SizedBox(height: 12),
                    ...service.features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                feature,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppConstants.spacingXXL),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Vendor Preview
                  Text('About the Vendor', style: AppTypography.headingSmall),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.accent.withOpacity(0.1),
                          child: Text(
                            service.vendorName.substring(0, 2).toUpperCase(),
                            style: AppTypography.subheadingLarge.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    service.vendorName,
                                    style: AppTypography.subheadingLarge,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 16,
                                    color: AppColors.accent,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${service.reviewCount} orders completed',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // Helper to parse color safely
                            int? parseColor(dynamic c) {
                              if (c is int) return c;
                              return null;
                            }
                            
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AgencyProfileScreen(agency: {
                              'name': service.vendorName,
                              'image': service.vendorAvatar.isNotEmpty ? service.vendorAvatar : 'https://via.placeholder.com/400',
                              'logo': service.vendorName.isNotEmpty ? service.vendorName.substring(0, 1).toUpperCase() : 'A',
                              'tagline': 'Premium Project Provider',
                              'projects': 100,
                              'rating': 4.8,
                              'reviews': service.reviewCount,
                              'location': 'Online',
                              'responseTime': '< 1 hour',
                              'color': 0xFF2563EB,
                            })));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: AppColors.accent),
                          ),
                          child: Text(
                            'View Profile',
                            style: AppTypography.buttonSmall.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Reviews
                  if (service.reviews.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spacingXXL),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: AppConstants.spacingXXL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reviews', style: AppTypography.headingSmall),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...service.reviews.map(
                      (review) => _ReviewCard(review: review),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Chat Button
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.accent,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              // Book Now Button
              Expanded(
                child: CustomButton(
                  label: '${service.category == 'Internships' ? 'Apply Now' : 'Book Now'}  •  ₹${service.price}',
                  size: CustomButtonSize.large,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartScreen(service: service),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.accent.withOpacity(0.1),
                  child: Text(
                    review.userName.substring(0, 1),
                    style: AppTypography.subheadingMedium.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: AppTypography.subheadingMedium,
                      ),
                      Text(review.date, style: AppTypography.caption),
                    ],
                  ),
                ),
                RatingStars(rating: review.rating, size: 14),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              review.comment,
              style: AppTypography.bodyMedium.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
