import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/data/mock_data.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/models/models.dart';
import 'package:buyer_app/features/projects/controllers/projects_controller.dart';
import '../categories/categories_screen.dart';
import '../categories/final_year_projects_screen.dart';
import '../categories/resume_templates_screen.dart';
import '../categories/resume_writing_screen.dart';
import '../categories/research_paper_screen.dart';
import '../categories/general_projects_screen.dart';
import '../orders/custom_project_order_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeroCarousel(),
                    const SizedBox(height: 24),
                    _buildStatsBar(),
                    const SizedBox(height: 28),
                    _buildSectionHeader(context, 'CATEGORIES', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()));
                    }),
                    const SizedBox(height: 14),
                    _buildCategoryGrid(context),
                    const SizedBox(height: 32),
                    _buildSectionHeader(context, 'FEATURED PROJECTS', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FinalYearProjectsScreen()));
                    }),
                    const SizedBox(height: 14),
                    _FeaturedProjectsList(),
                    const SizedBox(height: 32),
                    _buildPromoBanner(context),
                    const SizedBox(height: 24),
                    _buildCustomOrderCTA(context),
                    const SizedBox(height: 32),
                    _buildSectionHeader(context, 'TRENDING SERVICES', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()));
                    }),
                    const SizedBox(height: 14),
                    _TrendingServicesList(),
                    const SizedBox(height: 32),
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ProjectGenie', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.5)),
                  Text('Enterprise Solutions', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textTertiary, letterSpacing: 0.5)),
                ],
              ),
              const Spacer(),
              _buildIconBtn(Icons.search_rounded, () {}),
              const SizedBox(width: 4),
              _buildIconBtn(Icons.notifications_none_rounded, () {}, badge: 3),
              const SizedBox(width: 4),
              _buildIconBtn(Icons.shopping_bag_outlined, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap, {int badge = 0}) {
    return Stack(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, size: 20, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
          ),
        ),
        if (badge > 0)
          Positioned(
            right: 2, top: 2,
            child: Container(
              width: 16, height: 16,
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: Center(child: Text('$badge', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
            ),
          ),
      ],
    );
  }

  // ─── Hero Carousel ───────────────────────────────────────────────
  Widget _buildHeroCarousel() {
    return SizedBox(
      height: 175,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        itemCount: MockData.banners.length,
        itemBuilder: (context, index) {
          final banner = MockData.banners[index];
          final startColor = Color(int.parse(banner['gradient_start']!));
          final endColor = Color(int.parse(banner['gradient_end']!));
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [startColor, endColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: startColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(banner['tag']!, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(banner['title']!, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
                const SizedBox(height: 6),
                Text(banner['subtitle']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.85))),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Stats Bar ───────────────────────────────────────────────────
  Widget _buildStatsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(Icons.people_alt_rounded, MockData.stats['students']!, 'Students', AppColors.primary),
          _divider(),
          _buildStatItem(Icons.rocket_launch_rounded, MockData.stats['projects']!, 'Projects', AppColors.secondary),
          _divider(),
          _buildStatItem(Icons.workspace_premium_rounded, MockData.stats['mentors']!, 'Mentors', AppColors.success),
          _divider(),
          _buildStatItem(Icons.star_rounded, MockData.stats['rating']!, 'Rating', AppColors.starFilled),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: AppColors.border);

  // ─── Section Header ──────────────────────────────────────────────
  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View All', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Category Grid ───────────────────────────────────────────────
  Widget _buildCategoryGrid(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppCategories.main.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = AppCategories.main[index];
          return GestureDetector(
            onTap: () => _navigateToCategory(context, cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      cat.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String categoryId) {
    Widget screen;
    switch (categoryId) {
      case 'final_year':
        screen = const FinalYearProjectsScreen();
        break;
      case 'resume':
        screen = const ResumeTemplatesScreen();
        break;
      case 'projects':
        screen = const GeneralProjectsScreen();
        break;
      case 'resume_writing':
        screen = const ResumeWritingScreen();
        break;
      case 'research_paper':
        screen = const ResearchPaperScreen();
        break;
      default:
        screen = const CategoriesScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ─── Promo Banner ────────────────────────────────────────────────
  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(right: -30, top: -30, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.03)))),
          Positioned(left: -20, bottom: -20, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.03)))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.starFilled.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text('🎯 BUNDLE DEAL', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.starFilled, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 12),
                      Text('Final Year\nComplete Package', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                      const SizedBox(height: 8),
                      Text('Project + Report + PPT + Video', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.7))),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Text('Explore Bundles →', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.inventory_2_rounded, size: 40, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Actions ───────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.school_rounded, 'label': 'Final Year\nProjects', 'color': const Color(0xFFF59E0B), 'id': 'final_year'},
      {'icon': Icons.description_rounded, 'label': 'Resume\nTemplates', 'color': const Color(0xFF059669), 'id': 'resume'},
      {'icon': Icons.edit_document, 'label': 'Resume\nWriting', 'color': const Color(0xFF7C3AED), 'id': 'resume_writing'},
      {'icon': Icons.science_rounded, 'label': 'Research\nPapers', 'color': const Color(0xFFDC2626), 'id': 'research_paper'},
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('QUICK ACTIONS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 14),
          Row(
            children: actions.map((action) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToCategory(context, action['id'] as String),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: (action['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 22),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Custom Order CTA ─────────────────────────────────────────────
  Widget _buildCustomOrderCTA(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomProjectOrderScreen())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text('🚀 NEW', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 10),
                  Text('Order a Custom\nProject', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 6),
                  Text('Built by expert developers, tailored for you', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Get Started →', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF7C3AED))),
                  ),
                ],
              ),
            ),
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.rocket_launch_rounded, size: 36, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Featured Projects List ────────────────────────────────────────
class _FeaturedProjectsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(featuredProjectsProvider);
    
    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final project = projects[index];
              return _FeaturedProjectCard(project: project);
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 290, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final ProjectModel project;
  const _FeaturedProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final domainColor = AppColors.getDomainColor(project.domain);
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: project.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(project.imageUrl),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    )
                  : null,
              color: domainColor.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                      begin: Alignment.bottomCenter, end: Alignment.topCenter,
                    ),
                  ),
                ),
                // Domain badge
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: domainColor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [BoxShadow(color: domainColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Text(project.domain, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                  ),
                ),
                // Featured badge
                if (project.isFeatured)
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: AppColors.starFilled),
                          const SizedBox(width: 2),
                          Text('Featured', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.starFilled.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 12, color: AppColors.starFilled),
                            const SizedBox(width: 2),
                            Text('${project.rating}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Enrollees
                      Icon(Icons.people_outline_rounded, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text('${project.enrollees}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                      const Spacer(),
                      // Price
                      Text(project.price, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Trending Services List ────────────────────────────────────────
class _TrendingServicesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(trendingServicesProvider);

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final service = services[index];
              return _TrendingServiceCard(service: service);
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TrendingServiceCard extends StatelessWidget {
  final ServiceModel service;
  const _TrendingServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: service.imageUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(service.imageUrl), fit: BoxFit.cover, onError: (_, __) {})
                  : null,
              color: AppColors.primarySurface,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.bottomCenter, end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3)),
                  const SizedBox(height: 4),
                  Text(service.vendorName, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.starFilled),
                      Text(' ${service.rating}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 4),
                      Text('(${service.reviewCount})', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textTertiary)),
                      const Spacer(),
                      Text('₹${service.price}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
