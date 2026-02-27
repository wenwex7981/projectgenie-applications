import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/models/models.dart';
import 'package:buyer_app/features/projects/controllers/projects_controller.dart';

class GeneralProjectsScreen extends ConsumerWidget {
  const GeneralProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider('Projects'));

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
                        // Filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['All', 'Python', 'Flutter', 'React', 'MERN', 'Django'].map((filter) {
                              final isSelected = filter == 'All';
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.categoryProjects : Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: isSelected ? AppColors.categoryProjects : AppColors.border),
                                  boxShadow: isSelected ? [BoxShadow(color: AppColors.categoryProjects.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 3))] : null,
                                ),
                                child: Text(filter, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textSecondary)),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('${services.length} Projects Available', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        ...services.map((service) => _ProjectServiceCard(service: service)),
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
            decoration: BoxDecoration(color: AppColors.categoryProjects.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.rocket_launch_rounded, size: 20, color: AppColors.categoryProjects),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mini & Major Projects', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              Text('Ready-to-Deploy Solutions', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
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
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
            child: Text('🚀 PROJECTS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Text('Build. Deploy.\nImpress.', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
          const SizedBox(height: 8),
          Text('Production-ready projects with source code & docs', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _ProjectServiceCard extends StatelessWidget {
  final ServiceModel service;
  const _ProjectServiceCard({required this.service});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.code_rounded, size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(service.vendorName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              Text('₹${service.price}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(service.description, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.star_rounded, '${service.rating}', AppColors.starFilled),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.rate_review_outlined, '${service.reviewCount}', AppColors.textTertiary),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.schedule_rounded, service.deliveryDays == 'Instant' ? 'Instant' : '${service.deliveryDays}d', AppColors.success),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: Text('Buy', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
