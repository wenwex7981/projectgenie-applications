import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/service_card.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/services/api_service.dart';
import 'service_detail_screen.dart';

class ServiceListingScreen extends StatefulWidget {
  final String category;
  final bool isFeatured;
  final bool isTrending;

  const ServiceListingScreen({
    super.key,
    required this.category,
    this.isFeatured = false,
    this.isTrending = false,
  });

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  String _selectedSort = 'Relevance';
  bool _isLoading = true;
  List<ServiceModel> _services = [];
  
  final List<String> _sortOptions = [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
    'Newest',
  ];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      List<ServiceModel> fetchedServices;
      if (widget.isFeatured) {
        fetchedServices = await ApiService.getFeaturedServices();
      } else if (widget.isTrending) {
        fetchedServices = await ApiService.getTrendingServices();
      } else {
        fetchedServices = await ApiService.getServices(category: widget.category);
      }
      
      if (mounted) {
        setState(() {
          _services = fetchedServices;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading services: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.category, style: AppTypography.headingMedium),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Filter & Sort Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Filter Button
                _FilterChip(
                  icon: Icons.tune_rounded,
                  label: 'Filters',
                  onTap: () {
                    _showFilterSheet(context);
                  },
                ),
                const SizedBox(width: 12),
                // Sort Button
                _FilterChip(
                  icon: Icons.sort_rounded,
                  label: _selectedSort,
                  onTap: () {
                    _showSortSheet(context);
                  },
                ),
                const Spacer(),
                Text(
                  '${_services.length} results',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),

          // Service List
          Expanded(
            child: _services.isEmpty 
              ? Center(child: Text('No services found in this category', style: AppTypography.bodyMedium))
              : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.spacingLG,
                  ),
                  child: ServiceCard(
                    service: service,
                    heroTag: 'listing_${service.id}',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailScreen(
                            service: service,
                            heroTag: 'listing_${service.id}',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(AppConstants.spacingXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXXL),
                  Text('Filters', style: AppTypography.headingMedium),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Price Range
                  Text('Price Range', style: AppTypography.subheadingLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _PriceChip(label: '₹0 - ₹999', isSelected: true),
                      const SizedBox(width: 8),
                      _PriceChip(label: '₹1K - ₹3K'),
                      const SizedBox(width: 8),
                      _PriceChip(label: '₹3K - ₹5K'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _PriceChip(label: '₹5K - ₹10K'),
                      const SizedBox(width: 8),
                      _PriceChip(label: '₹10K+'),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Delivery Time
                  Text('Delivery Time', style: AppTypography.subheadingLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _PriceChip(label: '1-2 days'),
                      const SizedBox(width: 8),
                      _PriceChip(label: '3-5 days', isSelected: true),
                      const SizedBox(width: 8),
                      _PriceChip(label: '1 week+'),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXXL),

                  // Rating
                  Text('Minimum Rating', style: AppTypography.subheadingLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _PriceChip(label: '4.5+ ⭐'),
                      const SizedBox(width: 8),
                      _PriceChip(label: '4.0+ ⭐'),
                      const SizedBox(width: 8),
                      _PriceChip(label: '3.5+ ⭐'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingXXL),
              Text('Sort By', style: AppTypography.headingMedium),
              const SizedBox(height: AppConstants.spacingLG),
              ...List.generate(_sortOptions.length, (index) {
                final option = _sortOptions[index];
                return ListTile(
                  onTap: () {
                    setState(() => _selectedSort = option);
                    Navigator.pop(context);
                  },
                  title: Text(
                    option,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: _selectedSort == option
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: _selectedSort == option
                          ? AppColors.accent
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: _selectedSort == option
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.accent)
                      : null,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              const SizedBox(height: AppConstants.spacingLG),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _PriceChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
        border: Border.all(
          color: isSelected ? AppColors.accent : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.accent : AppColors.textSecondary,
        ),
      ),
    );
  }
}
