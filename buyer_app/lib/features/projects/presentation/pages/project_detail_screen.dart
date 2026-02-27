import 'package:flutter/material.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/models/models.dart';
import '../../../../core/widgets/feature_placeholder.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Image Hero
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.network(
                    project.imageUrl.isNotEmpty ? project.imageUrl : 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.code, size: 64)),
                  ),
                ),
                
                // Content Card
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                project.title,
                                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.1),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: AppColors.primary, size: 16),
                                  const SizedBox(width: 4),
                                  Text(project.rating.toStringAsFixed(1), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildTag(project.branch),
                            const SizedBox(width: 8),
                            _buildTag(project.domain, isPrimary: true),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildAvatarGroup(),
                                const SizedBox(width: 12),
                                Text("${project.enrollees} Students enrolled", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        Text("Project Abstract", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 12),
                        Text(
                          project.description,
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                        ),
                        TextButton(
                          onPressed: () => FeaturePlaceholder.show(context, 'Project Abstract'),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text("Read More", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                        
                        const SizedBox(height: 32),
                        Text("Tech Stack", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: project.techStack.map((tech) => _buildTechItem(_getTechIcon(tech), tech)).toList(),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.inventory_2_rounded, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Text("Bundle Includes", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildBundleItem(Icons.code_rounded, "Source Code", "Complete frontend and backend code"),
                              _buildBundleItem(Icons.description_rounded, "Project Report", "Detailed 50+ page PDF documentation"),
                              _buildBundleItem(Icons.slideshow_rounded, "Presentation (PPT)", "Ready-to-use viva presentation slides"),
                              _buildBundleItem(Icons.videocam_rounded, "Setup Guide Video", "Step-by-step installation instructions"),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reviews (${project.enrollees})", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            TextButton(onPressed: () => FeaturePlaceholder.show(context, 'Reviews'), child: Text("See All", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildReviewItem(),
                        
                        const SizedBox(height: 120), // Bottom space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
          
          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: const Border(top: BorderSide(color: Color(0x1A4169E1))),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("TOTAL PRICE", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 1.0)),
                      Text(project.price, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => FeaturePlaceholder.show(context, 'Shopping Cart'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => FeaturePlaceholder.show(context, 'Buy Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("Buy Now", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTechIcon(String tech) {
    tech = tech.toLowerCase();
    if (tech.contains('python')) return Icons.code_rounded;
    if (tech.contains('tensor')) return Icons.memory_rounded;
    if (tech.contains('flask')) return Icons.hub_rounded;
    if (tech.contains('sql')) return Icons.dns_rounded;
    if (tech.contains('react')) return Icons.web_rounded;
    if (tech.contains('node')) return Icons.terminal_rounded;
    return Icons.settings_input_component_rounded;
  }

  Widget _buildTag(String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary.withOpacity(0.1) : Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: isPrimary ? AppColors.primary : AppColors.textSecondary),
      ),
    );
  }

  Widget _buildAvatarGroup() {
    return SizedBox(
      width: 80,
      height: 32,
      child: Stack(
        children: List.generate(
          4,
          (index) => Positioned(
            left: index * 16.0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: index == 3 ? Colors.blueGrey[100] : Colors.blue[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: index == 3 
                ? const Center(child: Text("+120", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)))
                : const Icon(Icons.person, size: 20, color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechItem(IconData icon, String label) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey[100]!),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBundleItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundColor: Colors.blue[100], child: const Icon(Icons.person, size: 20)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Aditi Sharma", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                      Text("B.Tech CS Student", style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              Row(children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 14))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "\"The documentation was incredibly detailed. I was able to set up the entire project in less than 30 minutes.\"",
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
