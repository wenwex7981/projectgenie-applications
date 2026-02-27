import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/models/models.dart';
import 'package:buyer_app/features/projects/controllers/projects_controller.dart';

class ResearchPaperScreen extends ConsumerWidget {
  const ResearchPaperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider('Research Paper'));

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
                        _buildPublicationTypes(),
                        const SizedBox(height: 24),
                        Text('OUR SERVICES', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
                        const SizedBox(height: 16),
                        ...services.map((service) => _ResearchServiceCard(service: service)),
                        const SizedBox(height: 24),
                        _buildTrustBadges(),
                        const SizedBox(height: 24),
                        _buildFAQSection(),
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
            decoration: BoxDecoration(color: AppColors.categoryResearchPaper.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.science_rounded, size: 20, color: AppColors.categoryResearchPaper),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Research Papers', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              Text('IEEE • Springer • Scopus', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
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
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.categoryResearchPaper.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
            child: Text('📚 RESEARCH', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(height: 12),
          Text('Get Your Paper\nPublished', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
          const SizedBox(height: 8),
          Text('Expert research assistance for conferences & journals', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBadge('500+', 'Papers Published'),
              const SizedBox(width: 12),
              _buildStatBadge('50+', 'Journals Covered'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildPublicationTypes() {
    final types = [
      {'icon': Icons.article_rounded, 'name': 'IEEE', 'color': const Color(0xFF1A56DB)},
      {'icon': Icons.menu_book_rounded, 'name': 'Springer', 'color': const Color(0xFF059669)},
      {'icon': Icons.library_books_rounded, 'name': 'Scopus', 'color': const Color(0xFFF59E0B)},
      {'icon': Icons.school_rounded, 'name': 'Elsevier', 'color': const Color(0xFF7C3AED)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PUBLICATION HOUSES', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 14),
        Row(
          children: types.map((type) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (type['color'] as Color).withOpacity(0.2)),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: (type['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(type['icon'] as IconData, size: 20, color: type['color'] as Color),
                  ),
                  const SizedBox(height: 8),
                  Text(type['name'] as String, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildTrustBadges() {
    final badges = [
      {'icon': Icons.plagiarism_rounded, 'title': '100% Plagiarism Free', 'desc': 'Turnitin verified'},
      {'icon': Icons.verified_rounded, 'title': 'Publication Guarantee', 'desc': 'Or full refund'},
      {'icon': Icons.support_agent_rounded, 'title': '24/7 Support', 'desc': 'Expert assistance'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHY CHOOSE US', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 14),
        ...badges.map((badge) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.categoryResearchPaper.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(badge['icon'] as IconData, size: 22, color: AppColors.categoryResearchPaper),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(badge['title'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(badge['desc'] as String, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {'q': 'How long does it take to publish?', 'a': 'Typically 2-4 weeks for conference papers and 4-8 weeks for journals.'},
      {'q': 'Is the paper plagiarism-free?', 'a': 'Yes, every paper comes with a Turnitin plagiarism report under 5%.'},
      {'q': 'Can I choose the journal/conference?', 'a': 'Absolutely! We help you select the best venue based on your topic and requirements.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FREQUENTLY ASKED', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 14),
        ...faqs.map((faq) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: Text(faq['q']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            children: [Text(faq['a']!, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5))],
          ),
        )),
      ],
    );
  }
}

class _ResearchServiceCard extends StatelessWidget {
  final ServiceModel service;
  const _ResearchServiceCard({required this.service});

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
            children: [
              Expanded(
                child: Text(service.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ),
              Text('₹${service.price}', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.categoryResearchPaper)),
            ],
          ),
          const SizedBox(height: 4),
          Text(service.vendorName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
          const SizedBox(height: 10),
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
                  color: AppColors.categoryResearchPaper.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: AppColors.categoryResearchPaper),
                    const SizedBox(width: 4),
                    Text(f, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.categoryResearchPaper)),
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
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary),
                  Text(' ${service.deliveryDays} days', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.categoryResearchPaper,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Get Started', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
