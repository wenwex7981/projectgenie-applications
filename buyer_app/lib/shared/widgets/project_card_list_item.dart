import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProjectCardListItem extends StatelessWidget {
  const ProjectCardListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://img.freepik.com/free-vector/modern-code-interface-flat-design-concept_23-2148153443.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Project Meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)),
                      child: const Text('IOT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 14),
                        const SizedBox(width: 2),
                        Text('4.8', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Smart Irrigation System using NodeMCU and IoT Cloud',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'BTech • ECE / CSE',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '₹3,200',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to project detail with actual project data
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Details →', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
