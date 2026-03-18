import 'package:flutter/material.dart';

class InternshipsScreen extends StatelessWidget {
  const InternshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Career Center', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border_rounded), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved internships coming soon! 🔖'), behavior: SnackBarBehavior.floating),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final intern = _mockInternships[index % _mockInternships.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _InternshipCard(intern: intern),
                  );
                },
                childCount: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'High-Value Opportunities',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Text(
             'Partnering with enterprise leaders to bring you the best career starts.',
             style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTag('All Roles', true),
                _buildTag('Software Dev', false),
                _buildTag('Data Science', false),
                _buildTag('Product Design', false),
                _buildTag('Marketing', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF475569),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  static const List<Map<String, String>> _mockInternships = [
    {
      'title': 'AI Research Intern',
      'company': 'Google DeepMind (Mock)',
      'location': 'Remote / London',
      'duration': '6 Months',
      'stipend': '₹45,000/mo',
      'type': 'Remote',
      'logo': 'G',
      'color': '4285F4', // Google Blue
    },
    {
      'title': 'Full Stack Engineer',
      'company': 'Stripe Connect (Mock)',
      'location': 'Bangalore, IN',
      'duration': '3 Months',
      'stipend': '₹35,000/mo',
      'type': 'On-site',
      'logo': 'S',
      'color': '635BFF', // Stripe Purple
    },
    {
      'title': 'Product Designer',
      'company': 'Figma Design (Mock)',
      'location': 'Hybrid / SF',
      'duration': '4 Months',
      'stipend': '₹40,000/mo',
      'type': 'Hybrid',
      'logo': 'F',
      'color': 'F24E1E', // Figma Orange
    },
  ];
}

class _InternshipCard extends StatelessWidget {
  final Map<String, String> intern;
  const _InternshipCard({required this.intern});

  @override
  Widget build(BuildContext context) {
    final Color companyColor = Color(int.parse('FF${intern['color']}', radix: 16));
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: companyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  intern['logo']!,
                  style: TextStyle(color: companyColor, fontWeight: FontWeight.w900, fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(intern['title']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text(intern['company']!, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert_rounded, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildInfoItem(Icons.location_on_outlined, intern['location']!),
              const SizedBox(width: 16),
              _buildInfoItem(Icons.access_time_outlined, intern['duration']!),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('STIPEND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(intern['stipend']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF10B981))),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Application submitted for ${intern['title']}! 🚀'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF0F172A),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Apply Now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
