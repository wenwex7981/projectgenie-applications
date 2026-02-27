import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PlacementTrainingScreen extends StatelessWidget {
  const PlacementTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainHeader(),
                  const SizedBox(height: 24),
                  _buildSection('Module Overview', 'Comprehensive training for top-tier enterprise placements. Includes mock interviews and technical assessments.'),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Key Modules'),
                  const SizedBox(height: 16),
                  _buildModuleItem(Icons.code_rounded, 'Data Structures & Algorithms', '120+ Problems covered'),
                  _buildModuleItem(Icons.psychology_rounded, 'System Design', 'Scale, Latency & Databases'),
                  _buildModuleItem(Icons.record_voice_over_rounded, 'Soft Skills', 'Communication & Confidence'),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildActionArea(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Opacity(
          opacity: 0.3,
          child: Image.network(
            "https://lh3.googleusercontent.com/aida-public/AB6AXuBtbUTgMpnAATNu5-zv4Q9jHQFn4fpOWeNbxSXWz1eLeC0gegN96RWKzMWUNEj6J1RwXXJemoNqznSogPD9YbhqMDjTmL-5NlB-_WiAnINkqsoxjWYeI1wbwqTWuyfdOhobqI9XzhnBokscC4LPNotATP4W0yx5-MIXAo1MjinXbmu6lf6qjqyA9FSydRkCgl2NfwqgX8HwzmZyimq8IIKoDOTyqYJXbMl2vTocgt6bXrH8C899E1zVxkoPnc1okb8F5GaEigKduu0",
            fit: BoxFit.cover,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMainHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFEAB308).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('INTERVIEW PREP', style: TextStyle(color: Color(0xFF854D0E), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        const SizedBox(height: 12),
        const Text('Enterprise Placement Training', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), height: 1.2)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text('12 Weeks Program', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(width: 16),
            const Icon(Icons.group_outlined, size: 16, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text('Batch of 50', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        Text(body, style: TextStyle(color: Colors.grey[700], fontSize: 15, height: 1.6)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)));
  }

  Widget _buildModuleItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill_rounded, color: AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Center(
          child: Text('ENROLL NOW - ₹9,999', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
