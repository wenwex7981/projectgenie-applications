import 'package:flutter/material.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/feature_placeholder.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/internships_controller.dart';

class InternshipsScreen extends ConsumerWidget {
  const InternshipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internshipsAsync = ref.watch(internshipsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: AppColors.background,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
                      Text(
                        "Internships",
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.person, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search role, company or skills',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip("All Domains", true),
                        _buildFilterChip("UI/UX Design", false, hasDropdown: true),
                        _buildFilterChip("Web Dev", false, hasDropdown: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Segmented Control
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        _buildSegment("All", true),
                        _buildSegment("Remote", false),
                        _buildSegment("Onsite", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Internship List
            Expanded(
              child: internshipsAsync.when(
                data: (internships) => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: internships.length,
                  itemBuilder: (context, index) {
                    return InternshipCard(internship: internships[index]);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error loading internships: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {bool hasDropdown = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
          if (hasDropdown) const SizedBox(width: 4),
          if (hasDropdown) Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildSegment(String label, bool isActive) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: isActive ? AppColors.primary : AppColors.textSecondary, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

class InternshipCard extends StatelessWidget {
  final InternshipModel internship;
  const InternshipCard({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: NetworkImage(internship.logo), fit: BoxFit.cover),
                  border: Border.all(color: AppColors.border),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(internship.role, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text(internship.company, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                child: Text("Actively Hiring", style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.green[700], letterSpacing: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 3,
            children: [
              _buildInfoItem(Icons.schedule_rounded, internship.duration),
              _buildInfoItem(Icons.payments_rounded, internship.stipend),
              _buildInfoItem(Icons.explore_rounded, internship.type),
              _buildInfoItem(Icons.location_on_rounded, internship.location),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => FeaturePlaceholder.show(context, 'Application'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Apply Now", style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bookmark_outline_rounded, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text, 
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
