import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SavedServicesScreen extends StatefulWidget {
  const SavedServicesScreen({super.key});

  @override
  State<SavedServicesScreen> createState() => _SavedServicesScreenState();
}

class _SavedServicesScreenState extends State<SavedServicesScreen> {
  int _selectedTabIndex = 0; // 0 for Projects, 1 for Mentors

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8).withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Saved Items',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.sort, color: AppTheme.primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: AppTheme.primaryColor), onPressed: () {}),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: Column(
        children: [
          _buildSegmentedControl(),
          Expanded(
            child: _selectedTabIndex == 0 ? _buildProjectsGrid() : _buildMentorsEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildTabButton(0, Icons.architecture, 'Projects'),
            _buildTabButton(1, Icons.school, 'Mentors'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsGrid() {
    final items = [
      {
        'title': 'SaaS Dashboard UI Kit',
        'subtitle': 'High-quality components for modern apps',
        'price': '\$399',
        'sales': '128 sales',
        'rating': '4.9',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAec_um_j92Qz9YMZJy0BhGFltOGxYxcmfiachAHQBfTKSlJR-YHvVUp4uIof_VPWNcO25VfHsDoJ0biboXIrcyBSBfu-araOB4e11odGipshyK94bTr7sFEB2TpGmwIFE5dT1y1UhOhspuQGs8_0w9t_A5OVLFp5CEEOe5YkjL_qjU40cTGtzz-b5yDzGQOsmDDytc9My6G_oKKLeayj9Jzc9fx6ryLRVjImTBLSe82l3Zjkt5jepZTh7ruyC4XwY6x2oOhRPWess',
        'isFeatured': true,
      },
      {
        'title': 'E-commerce Landing Page',
        'subtitle': 'Optimized for high conversion rates',
        'price': '\$150',
        'sales': '85 sales',
        'rating': '4.8',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDTgZSc90q2E_jmdq5sGBnLoiZoHVo-8Z4_PlUTxUUJpThDv6UhmZFCur7Rn7sTevdJDGJUjWXaCVP8OdBexD98sWS-cwYl5m6Gwb5k4DNENzN6qK6wjK9dJvfWtVrYIdRmm-tn57v6w8p998YNtZwz7bB7kHJJhKC58HQ_55FfS2CCm8CsKqaroDGHmq9ogapcrFtUSTIdr0RVFumbl1o4PfCUBuOr6ybs_fsjJ2RzBuYlrQBo9gdxMSm8e-MarqZYekwA4orUSXM',
        'isFeatured': false,
      },
      {
        'title': 'Custom Brand Illustration',
        'subtitle': 'Unique vector art for your identity',
        'price': '\$75',
        'sales': '42 sales',
        'rating': '5.0',
        'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDvSQeEr0LwsGt9xOh0V4byNi1fixyzjDrx0XVGP2x9MphRKW2UJjw0Kcf0Es3UduhYXhiHQSgI5yvQPKBp9awcOuxocGZR6K-IlWPDVyUiQbV7TfvRlNNjHdwIAcM9mjUW0xGiKL3srK1Vmx_dOL8zoSl_xaByMnTc5D4Ifp8jKZ6zzM4BIyHV3iRzu4TeBcspjDXPRl0ka07eaU0hRmk-FkZs6ALdasqtYh-G5dmG9lf8HKu8DHqEKgyf9-e-7wvoAFmMpVawA2U',
        'isFeatured': false,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildServiceCard(items[index]),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: NetworkImage(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, color: AppTheme.primaryColor, size: 20),
                  ),
                ),
                if (item['isFeatured'])
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
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
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item['rating'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'],
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: AppTheme.primaryColor.withOpacity(0.05)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Starting at ${item['price']}',
                      style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      item['sales'],
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500),
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

  Widget _buildMentorsEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 100, color: AppTheme.primaryColor.withOpacity(0.2)),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.school, color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'No saved mentors yet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Start exploring our network of experts to find the perfect guidance for your creative journey!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: AppTheme.primaryColor.withOpacity(0.3),
            ),
            child: const Text('Browse Mentors', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
