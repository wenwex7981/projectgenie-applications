import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UniversityHubScreen extends StatelessWidget {
  const UniversityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsBanner(context),
                const SizedBox(height: 32),
                _buildSectionHeader(context, "University Hackathons", () {}),
                const SizedBox(height: 16),
                _buildHackathons(context),
                const SizedBox(height: 32),
                _buildSectionHeader(context, "Peer Projects", () {}),
                const SizedBox(height: 16),
                _buildPeerProjects(context),
                const SizedBox(height: 32),
                _buildSectionHeader(context, "Top Contributors", () {}),
                const SizedBox(height: 16),
                _buildLeaderboard(context),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      surfaceTintColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stanford University',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              Text(
                'CHAPTER MEMBER',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
            child: const Text('ELITE TIER HUB', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ),
          const SizedBox(height: 12),
          const Text('Stanford Chapter', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('1,240 active contributors this month', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Projects', '412'),
              _buildStatItem('Hackathons', '3 Active'),
              _buildStatItem('Global Rank', '#4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
        TextButton(onPressed: onViewAll, child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildHackathons(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Center(child: Icon(Icons.code_rounded, color: AppTheme.primaryColor)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                        child: const Text('REGISTRATION OPEN', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Stanford Spring Hack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Starts in 3 days • \$5k Prizes', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeerProjects(BuildContext context) {
    return Column(
      children: [
        _buildProjectCard(
          userName: 'Alex Chen',
          userTitle: 'CS Junior • 2h ago',
          projectTitle: 'Autonomous Drone Pathfinding',
          projectDesc: 'A project exploring SLAM algorithms for indoor drone navigation using lightweight sensors. Looking for a collaborator familiar with ROS.',
          tags: ['AI & Robotics', 'C++', 'Hiring Member'],
          isCampusExclusive: true,
        ),
        const SizedBox(height: 16),
        _buildProjectCard(
          userName: 'Sarah Williams',
          userTitle: 'Design Senior • 5h ago',
          projectTitle: 'Campus Food Waste Tracker',
          projectDesc: 'Redesigning how dining halls track and manage excess food. Built with React Native and Supabase.',
          tags: ['Sustainability', 'UI/UX'],
          isCampusExclusive: false,
        ),
      ],
    );
  }

  Widget _buildProjectCard({
    required String userName,
    required String userTitle,
    required String projectTitle,
    required String projectDesc,
    required List<String> tags,
    bool isCampusExclusive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 18, backgroundColor: Colors.grey[200]),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(userTitle, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                    ],
                  ),
                ],
              ),
              if (isCampusExclusive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(4), border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1))),
                  child: const Text('CAMPUS EXCLUSIVE', style: TextStyle(color: AppTheme.primaryColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(projectTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textMain)),
          const SizedBox(height: 8),
          Text(projectDesc, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: tag.contains('Hiring') ? Colors.orange[50] : Colors.grey[100], borderRadius: BorderRadius.circular(6)),
              child: Text(tag, style: TextStyle(color: tag.contains('Hiring') ? Colors.orange[800] : AppTheme.textSecondary, fontSize: 11, fontWeight: tag.contains('Hiring') ? FontWeight.bold : FontWeight.normal)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.thumb_up_alt_outlined, size: 18, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text('24', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text('8', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('Details →', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('14', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    const SizedBox(width: 12),
                    CircleAvatar(radius: 12, backgroundColor: Colors.grey[300]),
                    const SizedBox(width: 12),
                    const Text('You', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('840 pts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('TOP 15%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          _buildLeaderboardItem(1, 'David Miller', '2,450 pts', true),
          _buildLeaderboardItem(2, 'James Wilson', '2,120 pts', false),
          _buildLeaderboardItem(3, 'Emily Davis', '1,980 pts', false),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String name, String pts, bool isFirst) {
    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 24,
        child: isFirst 
          ? const Icon(Icons.emoji_events, color: Colors.amber, size: 18)
          : Text(rank.toString(), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[400])),
      ),
      title: Row(
        children: [
          CircleAvatar(radius: 14, backgroundColor: Colors.grey[200]),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
      trailing: Text(pts, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textMain)),
    );
  }
}
