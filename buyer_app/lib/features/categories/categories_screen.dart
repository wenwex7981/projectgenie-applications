import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/data/mock_data.dart';
import 'final_year_projects_screen.dart';
import 'resume_templates_screen.dart';
import 'resume_writing_screen.dart';
import 'research_paper_screen.dart';
import 'general_projects_screen.dart';
import 'hackathons_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('All Categories', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FinalYearProjectsScreen()));
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text('🚀 EXPLORE', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 12),
                  Text('Find Your Perfect\nSolution', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 8),
                  Text('500+ Projects • 100+ Services • 120+ Mentors', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white60)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Categories Grid
            Text('BROWSE BY CATEGORY', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
            const SizedBox(height: 16),

            ...AppCategories.main.map((cat) {
              return _CategoryListItem(
                category: cat,
                onTap: () => _navigateToCategory(context, cat.id),
              );
            }),

            const SizedBox(height: 28),

            // Popular Topics
            Text('POPULAR DOMAINS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppDomains.all.skip(1).map((domain) {
                final color = AppColors.getDomainColor(domain.name);
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FinalYearProjectsScreen(initialDomain: domain.shortName))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(domain.name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                        const SizedBox(width: 6),
                        Text('${domain.projectCount}', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: color.withOpacity(0.6))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
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
      case 'hackathons':
        screen = const HackathonsScreen();
        break;
      default:
        screen = const FinalYearProjectsScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _CategoryListItem extends StatelessWidget {
  final AppCategory category;
  final VoidCallback onTap;

  const _CategoryListItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: category.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(category.icon, color: category.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(category.subtitle, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text('${category.count}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: category.color)),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
