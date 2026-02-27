import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MyCertificatesScreen extends StatefulWidget {
  const MyCertificatesScreen({super.key});

  @override
  State<MyCertificatesScreen> createState() => _MyCertificatesScreenState();
}

class _MyCertificatesScreenState extends State<MyCertificatesScreen> {
  int _activeFilterIndex = 0;
  final List<String> _filters = ['All', 'Internships', 'Training', 'Workshops'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8).withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'My Certificates',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCertificateCard(
                  'Full Stack Development Internship',
                  'TechCorp Solutions • Oct 2023',
                  'TC-2023-8842',
                  Icons.workspace_premium,
                  Colors.blue,
                  isVerified: false,
                ),
                _buildCertificateCard(
                  'Placement Readiness Training',
                  'CareerBridge Academy • Dec 2023',
                  'CB-PR-9921',
                  Icons.school,
                  Colors.green,
                  isVerified: true,
                ),
                _buildCertificateCard(
                  'Cloud Architecture Workshop',
                  'AWS Community • Jan 2024',
                  'AWS-WS-1120',
                  Icons.pending_actions,
                  Colors.amber,
                  isProcessing: true,
                ),
              ],
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

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search certificates...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => _buildFilterChip(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index) {
    bool isSelected = _activeFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.1)),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 4)] : null,
        ),
        child: Center(
          child: Text(
            _filters[index],
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateCard(
    String title,
    String subtitle,
    String id,
    IconData icon,
    Color color, {
    bool isVerified = false,
    bool isProcessing = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    if (!isProcessing) ...[
                      const SizedBox(height: 2),
                      Text('ID: $id', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, letterSpacing: 0.5)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isProcessing)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Text('PROCESSING', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 10)),
                )
              else if (isVerified)
                const Row(
                  children: [
                    Icon(Icons.verified, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('Verified', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                )
              else
                const Row(
                  children: [
                    CircleAvatar(radius: 10, backgroundColor: Color(0xFFF1F5F9), child: Text('JS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
                    SizedBox(width: 4),
                    CircleAvatar(radius: 10, backgroundColor: Color(0xFFF1F5F9), child: Text('PY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
                  ],
                ),
              ElevatedButton.icon(
                onPressed: isProcessing ? null : () {},
                icon: const Icon(Icons.download, size: 16),
                label: Text(isProcessing ? 'Pending' : 'Download PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFF1F5F9),
                  disabledForegroundColor: const Color(0xFFCBD5E1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  minimumSize: const Size(0, 36),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
