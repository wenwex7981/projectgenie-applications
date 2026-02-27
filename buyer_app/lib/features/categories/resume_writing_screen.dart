import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/models/models.dart';
import 'package:buyer_app/features/projects/controllers/projects_controller.dart';

class ResumeWritingScreen extends ConsumerWidget {
  const ResumeWritingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider('Resume Writing'));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: servicesAsync.when(
                data: (services) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroBanner(),
                        const SizedBox(height: 24),
                        // How it works
                        _buildHowItWorks(),
                        const SizedBox(height: 24),
                        Text('CHOOSE YOUR PLAN', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        ...services.map((service) => _ServicePlanCard(service: service)),
                        const SizedBox(height: 24),
                        _buildGuaranteeBanner(),
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
            decoration: BoxDecoration(color: AppColors.categoryResumeWriting.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.edit_document, size: 20, color: AppColors.categoryResumeWriting),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resume Writing', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              Text('Professional Writers', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.categoryResumeWriting.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
            child: Text('✍️ PRO SERVICE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Text('Let Experts Write\nYour Resume', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
          const SizedBox(height: 8),
          Text('5x more interview calls guaranteed', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatPill('10K+', 'Resumes Written'),
              const SizedBox(width: 12),
              _buildStatPill('95%', 'ATS Pass Rate'),
              const SizedBox(width: 12),
              _buildStatPill('4.9⭐', 'Rating'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {'icon': Icons.upload_file_rounded, 'title': 'Upload Info', 'desc': 'Share your details & old resume'},
      {'icon': Icons.edit_rounded, 'title': 'Expert Writes', 'desc': 'Pro writer crafts your resume'},
      {'icon': Icons.check_circle_rounded, 'title': 'Review & Get', 'desc': 'Get ATS-optimized resume'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HOW IT WORKS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 14),
        Row(
          children: steps.asMap().entries.map((entry) {
            final step = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: entry.key < 2 ? 8 : 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.categoryResumeWriting.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(step['icon'] as IconData, size: 22, color: AppColors.categoryResumeWriting),
                    ),
                    const SizedBox(height: 10),
                    Text(step['title'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(step['desc'] as String, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textTertiary, height: 1.3), textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuaranteeBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.verified_rounded, size: 24, color: AppColors.success),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('100% Satisfaction Guarantee', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Not happy? Get a full refund within 7 days', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicePlanCard extends StatelessWidget {
  final ServiceModel service;
  const _ServicePlanCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final isPopular = service.rating >= 4.9;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPopular ? AppColors.categoryResumeWriting.withOpacity(0.4) : AppColors.border),
        boxShadow: isPopular
            ? [BoxShadow(color: AppColors.categoryResumeWriting.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))]
            : AppColors.softShadow,
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0, right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.categoryResumeWriting,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Text('POPULAR', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(service.vendorName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${service.price}', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text('${service.deliveryDays} days', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(service.description, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 14),
                // Features
                if (service.features.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: service.features.map((f) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.categoryResumeWriting.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 14, color: AppColors.categoryResumeWriting),
                          const SizedBox(width: 4),
                          Text(f, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.categoryResumeWriting)),
                        ],
                      ),
                    )).toList(),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.starFilled),
                        Text(' ${service.rating}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                        Text(' (${service.reviewCount})', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPopular ? AppColors.categoryResumeWriting : AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Order Now', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
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
