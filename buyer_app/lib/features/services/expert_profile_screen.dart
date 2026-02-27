import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ExpertProfileScreen extends StatelessWidget {
  final Map<String, dynamic> expert;
  const ExpertProfileScreen({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    _buildQuickStats(),
                    _buildAboutSection(),
                    _buildExpertiseSection(),
                    _buildPastProjectsSection(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
          _buildStickyActionBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Expert Profile', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
      actions: [
        IconButton(icon: const Icon(Icons.share, color: AppTheme.primaryColor), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert, color: AppTheme.primaryColor), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 4),
                  image: DecorationImage(
                    image: NetworkImage(expert['imageUrl'] ?? "https://via.placeholder.com/150"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                  child: const Icon(Icons.verified, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(expert['name'] ?? 'Alex Rivera', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          Text(expert['title'] ?? 'Senior UX Strategist', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 14, color: Color(0xFF94A3B8)),
              SizedBox(width: 4),
              Text('San Francisco, CA', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard(Icons.star, '4.9/5', 'RATING', Colors.amber),
          const SizedBox(width: 12),
          _buildStatCard(Icons.task_alt, '124', 'PROJECTS', AppTheme.primaryColor),
          const SizedBox(width: 12),
          _buildStatCard(Icons.history_edu, '8+ Yrs', 'EXP.', AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      'About',
      Icons.person,
      const Text(
        'I am a seasoned UX Strategist with over 8 years of experience in creating human-centered digital experiences. I specialize in complex SaaS platforms and mobile application ecosystems.',
        style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.6),
      ),
    );
  }

  Widget _buildExpertiseSection() {
    final skills = ['Product Design', 'User Research', 'Design Systems', 'Prototyping', 'Strategy', 'Mentorship'];
    return _buildSection(
      'Expertise',
      Icons.psychology,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: skills.map((s) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
          ),
          child: Text(s, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
        )).toList(),
      ),
    );
  }

  Widget _buildPastProjectsSection() {
    return _buildSection(
      'Past Projects',
      Icons.work,
      Column(
        children: [
          _buildProjectCard('NeoBank Global App', 'Redesigned the entire mobile banking experience for 2M+ users.', 'Fintech', 'Mobile'),
          const SizedBox(height: 16),
          _buildProjectCard('Enterprise CRM Redesign', 'Streamlined workflow efficiency for B2B sales teams by 40%.', 'SaaS', 'Enterprise'),
        ],
      ),
      showMore: true,
    );
  }

  Widget _buildProjectCard(String title, String sub, String tag1, String tag2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 160, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.vertical(top: Radius.circular(16)))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [tag1, tag2].map((tag) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                    child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget child, {bool showMore = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
              if (showMore) TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStickyActionBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 10,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, size: 20),
                    SizedBox(width: 12),
                    Text('Hire Alex', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primaryColor, size: 28),
                padding: const EdgeInsets.all(14),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
