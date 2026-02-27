import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'Major Projects',
      'subtitle': 'Final year BTech/MTech projects with complete documentation',
      'icon': Icons.rocket_launch_rounded,
      'count': '450+',
      'color': 0xFF2563EB,
      'image': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400&q=80',
      'tags': ['CNN', 'RNN', 'ML', 'DL', 'Cloud', 'IoT'],
    },
    {
      'title': 'Mini Projects',
      'subtitle': 'Quick semester projects, lab work & assignments',
      'icon': Icons.lightbulb_rounded,
      'count': '800+',
      'color': 0xFF14B8A6,
      'image': 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&q=80',
      'tags': ['Python', 'Java', 'Web', 'App'],
    },
    {
      'title': 'Research Papers',
      'subtitle': 'IEEE, Springer, Scopus formatted papers with plagiarism report',
      'icon': Icons.article_rounded,
      'count': '320+',
      'color': 0xFF7C3AED,
      'image': 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400&q=80',
      'tags': ['IEEE', 'Springer', 'Scopus', 'SCI'],
    },
    {
      'title': 'Internship Projects',
      'subtitle': 'Industry-ready internship projects with certificates',
      'icon': Icons.work_rounded,
      'count': '200+',
      'color': 0xFFF59E0B,
      'image': 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=400&q=80',
      'tags': ['AICTE', 'NPTEL', 'Infosys', 'TCS'],
    },
    {
      'title': 'PPT Presentations',
      'subtitle': 'Professional PowerPoint presentations for project reviews',
      'icon': Icons.slideshow_rounded,
      'count': '500+',
      'color': 0xFFEC4899,
      'image': 'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400&q=80',
      'tags': ['Review 1', 'Review 2', 'Final'],
    },
    {
      'title': 'Project Reports',
      'subtitle': 'Full project documentation, synopsis, abstract included',
      'icon': Icons.description_rounded,
      'count': '350+',
      'color': 0xFF0EA5E9,
      'image': 'https://images.unsplash.com/photo-1568667256549-094345857637?w=400&q=80',
      'tags': ['Report', 'Abstract', 'Synopsis'],
    },
    {
      'title': 'Thesis & Dissertation',
      'subtitle': 'M.Tech/PhD research thesis with literature survey',
      'icon': Icons.school_rounded,
      'count': '120+',
      'color': 0xFF10B981,
      'image': 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&q=80',
      'tags': ['MTech', 'PhD', 'Research'],
    },
    {
      'title': 'Workshops & Courses',
      'subtitle': 'Hands-on workshops with certification',
      'icon': Icons.cast_for_education_rounded,
      'count': '90+',
      'color': 0xFFEF4444,
      'image': 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400&q=80',
      'tags': ['AI/ML', 'Cloud', 'DevOps'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: AppTypography.headingLarge),
                    const SizedBox(height: 4),
                    Text('Browse by project type', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    // Search
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
                          const SizedBox(width: 10),
                          Text('Search categories...', style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCategoryCard(_categories[index], index),
                  childCount: _categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat, int index) {
    final color = Color(cat['color'] as int);
    final tags = cat['tags'] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Image header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  cat['image'] as String,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 120,
                    color: color.withOpacity(0.1),
                    child: Center(child: Icon(cat['icon'] as IconData, size: 40, color: color)),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                ),
                // Count badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                    child: Text(cat['count'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
                // Title on image
                Positioned(
                  bottom: 12,
                  left: 14,
                  child: Row(
                    children: [
                      Icon(cat['icon'] as IconData, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(cat['title'] as String, style: AppTypography.headingSmall.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat['subtitle'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Text(tag, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('Browse All', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.arrow_forward_rounded, color: color, size: 18),
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
