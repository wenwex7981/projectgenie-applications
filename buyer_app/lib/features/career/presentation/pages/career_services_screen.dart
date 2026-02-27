import 'package:flutter/material.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/feature_placeholder.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/controllers/services_controller.dart';
import '../../../../core/models/models.dart';

class CareerServicesScreen extends ConsumerWidget {
  const CareerServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(careerServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: servicesAsync.when(
        data: (services) => SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, Color(0xFF1A1F3C)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(99)),
                        child: Text("CAREER SERVICES", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.0)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Accelerate Your\nCareer Path",
                        style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Get expert help with resumes, interviews, and portfolio building from industry veterans.",
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Explore Services", style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Services List
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: services.map((s) => _buildServiceCard(context, s)).toList(),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading career services: $err')),
     ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.work_outline_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text('₹${s.price}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(s.description, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text('${s.deliveryDays} days', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => FeaturePlaceholder.show(context, 'Service Purchase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text("Buy Now", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
