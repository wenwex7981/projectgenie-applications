import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'advanced_filters_screen.dart';
import '../services/expert_profile_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Services', 'Projects', 'Experts'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: _buildResultContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.transparent)),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.query,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.tune, color: AppTheme.primaryColor),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvancedFiltersScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  Widget _buildResultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterChips(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Showing 42 results for \'${widget.query}\'',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
          _buildServiceCard(),
          _buildExpertCard(),
          _buildProjectCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = ['Top Rated', 'Under ₹8,000', 'Fast Delivery', 'Verified'];
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: index == 0 ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: index == 0 ? null : Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: index == 0 ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 4)] : null,
          ),
          child: Row(
            children: [
              Text(
                chips[index],
                style: TextStyle(color: index == 0 ? Colors.white : const Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: index == 0 ? Colors.white : const Color(0xFF64748B), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuBkt6Rg_EKS3tsWdPdfJwYdjQ9T0P7yIDXhZL61LamRhcTaxB9g2Uua7d4oHJeeAac8PMc4WG8UvFIJpIA8TPFme9cE5Kb7_tcXEE-wRF4pLDCt8uwC0cK9z6zsc4yyLxCrw_w7G1Dobz9jY6RjC4s3gAPrE3wmlwmzKFAj-LWYS7BS9zmZ2EGk6Z84sFMGLjO41Xwo-Fhd11Hobn_5oUphTIDyT6vPNrStp72Q49QWAZsI_3Vd1ChCv76MyhpSc9qXKblUbOTgfV4",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: const Text('SERVICE', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
                        SizedBox(width: 4),
                        Text('4.9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                        Text(' (124)', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Advanced Python Web Scraper with Proxy Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 6),
                const Text('Complete enterprise-grade scraper for complex data extraction projects.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('STARTING AT', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const Text('₹8,500', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primaryColor)),
                      ],
                    ),
                    Row(
                      children: [
                         Column(
                           children: [
                              const Icon(Icons.bolt, color: Color(0xFF94A3B8), size: 20),
                              const Text('2 Days', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                           ],
                         ),
                         const SizedBox(width: 16),
                         ElevatedButton(
                           onPressed: () {},
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppTheme.primaryColor,
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                           ),
                           child: const Text('View details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                         ),
                      ],
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

  Widget _buildExpertCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 2),
                  image: const DecorationImage(
                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAnS3Fc1DR4wLL7qAi2MazDg1XpWFvo0v2kpwCpI9fQwoxQSO9bwpTb488mAA8SDkO6qSox3n_LNic8RwjRYLW6rCJPMZKE-FKkuHUG4JeUI7SIJDUxLJZmB4a2u057KgrkWM22qVSNuvbAl17-ir1IJqhVLKHo1qDcvg0C9vddwzamYzUaD8SCKhG2eR9XDocsKXzo4ZI6K5c4A4taRIQFwfRNITUUJFdX1BXwBwUTj2pyZmaEGJa92mLzV0a-ZLH-wYAfPTy_8ws"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.verified, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dr. Sarah L.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    const Text('₹6,000/hr', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryColor)),
                  ],
                ),
                const SizedBox(height: 2),
                const Text('Python & ML Specialist', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Row(
                  children: ['Django', 'PyQt5', 'Automation'].map((tag) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                    child: Text(tag, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         const Icon(Icons.work_outline, size: 14, color: AppTheme.primaryColor),
                         const SizedBox(width: 4),
                         const Text('500+ projects', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                         const SizedBox(width: 12),
                         const Icon(Icons.star, size: 14, color: Color(0xFFFBBF24)),
                         const SizedBox(width: 4),
                         const Text('5.0', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpertProfileScreen(expert: {
                          'name': 'Dr. Sarah L.',
                          'title': 'Python & ML Specialist',
                          'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnS3Fc1DR4wLL7qAi2MazDg1XpWFvo0v2kpwCpI9fQwoxQSO9bwpTb488mAA8SDkO6qSox3n_LNic8RwjRYLW6rCJPMZKE-FKkuHUG4JeUI7SIJDUxLJZmB4a2u057KgrkWM22qVSNuvbAl17-ir1IJqhVLKHo1qDcvg0C9vddwzamYzUaD8SCKhG2eR9XDocsKXzo4ZI6K5c4A4taRIQFwfRNITUUJFdX1BXwBwUTj2pyZmaEGJa92mLzV0a-ZLH-wYAfPTy_8ws'
                        })));
                      },
                      child: const Row(
                        children: [
                          Text('Hire Expert', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                          Icon(Icons.arrow_forward, size: 16, color: AppTheme.primaryColor),
                        ],
                      ),
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

  Widget _buildProjectCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Text('PROJECT TEMPLATE', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              const SizedBox(width: 8),
              const Text('Posted 3h ago', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Open Source Django E-commerce Template with Python', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PRICE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1)),
                      Text('₹4,500', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LICENSE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1)),
                      Text('Commercial', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.download, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text('2.4k sales', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              SizedBox(width: 16),
              Icon(Icons.history, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 4),
              Text('v2.1.0 updated', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
