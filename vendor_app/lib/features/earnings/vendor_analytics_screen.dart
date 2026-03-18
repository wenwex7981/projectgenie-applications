import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class VendorAnalyticsScreen extends StatefulWidget {
  final String vendorId;
  const VendorAnalyticsScreen({super.key, required this.vendorId});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  // Mock data for analytics
  final List<double> _weeklyEarnings = [12000, 15000, 9500, 22000, 18000, 25000, 19000];
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        title: Text('Analytics', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: VC.text)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: VC.text),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(),
            const SizedBox(height: 24),
            Text('Weekly Earnings Trend', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: VC.text)),
            const SizedBox(height: 16),
            _buildChart(),
            const SizedBox(height: 24),
            Text('Top Performing Listings', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: VC.text)),
            const SizedBox(height: 16),
            _buildTopPerformers(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        _infoCard('Profile Views', '1,248', '+12%', Icons.visibility_rounded, VC.accent),
        const SizedBox(width: 12),
        _infoCard('Sales Conversion', '4.2%', '+0.5%', Icons.shopping_cart_rounded, VC.success),
      ],
    );
  }

  Widget _infoCard(String title, String value, String change, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VC.border),
          boxShadow: VC.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.inter(fontSize: 12, color: VC.textSec)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: VC.text)),
                const SizedBox(width: 8),
                Text(change, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: VC.success)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final maxEarning = _weeklyEarnings.reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VC.border),
        boxShadow: VC.softShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final val = _weeklyEarnings[index];
          final pct = val / maxEarning;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${(val/1000).toStringAsFixed(1)}k', style: GoogleFonts.inter(fontSize: 9, color: VC.textTer)),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 28,
                height: 120 * pct,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [VC.success, VC.success.withValues(alpha: 0.6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 8),
              Text(_days[index], style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: VC.textSec)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopPerformers() {
    final items = [
      {'title': 'E-Commerce MERN Stack', 'category': 'Project', 'sales': 45, 'revenue': '₹2.4L'},
      {'title': 'Breast Cancer CNN', 'category': 'Service', 'sales': 32, 'revenue': '₹1.5L'},
    ];

    return Column(
      children: items.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VC.border),
          boxShadow: VC.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: VC.purpleBg, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.star_rounded, color: VC.purple, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['title']!.toString(), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: VC.text)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(4)),
                        child: Text(e['category']!.toString(), style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w600, color: VC.textSec)),
                      ),
                      const SizedBox(width: 8),
                      Text('${e['sales']} Sales', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
                    ],
                  ),
                ],
              ),
            ),
            Text(e['revenue']!.toString(), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: VC.success)),
          ],
        ),
      )).toList(),
    );
  }
}
