import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/data/mock_data.dart';
import 'package:buyer_app/core/models/models.dart';
import 'package:buyer_app/features/projects/controllers/projects_controller.dart';

class ResumeTemplatesScreen extends ConsumerWidget {
  const ResumeTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider('Resume'));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: servicesAsync.when(
                data: (services) {
                  if (services.isEmpty) return _buildEmptyState();
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Banner
                        _buildFeaturedBanner(),
                        const SizedBox(height: 24),
                        // Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['All', 'Tech', 'Designer', 'MBA', 'Fresher'].map((filter) {
                              final isSelected = filter == 'All';
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.categoryResume : Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: isSelected ? AppColors.categoryResume : AppColors.border),
                                  boxShadow: isSelected ? [BoxShadow(color: AppColors.categoryResume.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 3))] : null,
                                ),
                                child: Text(filter, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textSecondary)),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Results
                        Text('${services.length} Templates Available', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        ...services.map((service) => _ResumeTemplateCard(service: service)),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('$err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.categoryResume.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.description_rounded, size: 20, color: AppColors.categoryResume),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resume Templates', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              Text('ATS-Optimized Templates', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.emeraldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.categoryResume.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                  child: Text('📄 TEMPLATES', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                ),
                const SizedBox(height: 12),
                Text('Land Your Dream Job', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                const SizedBox(height: 6),
                Text('ATS-friendly & recruiter-tested', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.description_rounded, size: 32, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text('No Templates Found', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ResumeTemplateCard extends StatelessWidget {
  final ServiceModel service;
  const _ResumeTemplateCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          // Preview
          Container(
            width: 72, height: 96,
            decoration: BoxDecoration(
              color: AppColors.categoryResume.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.categoryResume.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description_rounded, size: 28, color: AppColors.categoryResume),
                const SizedBox(height: 4),
                Text('PDF', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.categoryResume)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary), maxLines: 2),
                const SizedBox(height: 4),
                Text(service.vendorName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.starFilled),
                    Text(' ${service.rating}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                    Text(' (${service.reviewCount})', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textTertiary)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(6)),
                      child: Text(service.deliveryDays, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('₹${service.price}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Buy Now', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
