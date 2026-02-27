import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/models.dart';
import '../../core/services/api_service.dart';
import '../chat/chat_detail_screen.dart';
import '../profile/agency_profile_screen.dart';

class AgenciesScreen extends StatefulWidget {
  const AgenciesScreen({super.key});

  @override
  State<AgenciesScreen> createState() => _AgenciesScreenState();
}

class _AgenciesScreenState extends State<AgenciesScreen> {
  List<Map<String, dynamic>> _agencies = [];
  bool _loading = true;

  // Fallback demo data when server is offline
  static const List<Map<String, dynamic>> _demoAgencies = [
    {
      'name': 'ProjectGenie Labs',
      'logo': 'PG',
      'tagline': 'India\'s #1 Final Year Project Provider',
      'rating': 4.9,
      'reviews': 2340,
      'projects': 450,
      'verified': true,
      'specialties': ['CNN', 'ML', 'Deep Learning', 'NLP'],
      'location': 'Hyderabad, India',
      'responseTime': '< 1 hour',
      'startingPrice': '₹2,500',
      'color': 0xFF2563EB,
      'image': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&q=80',
      'completionRate': '99%',
    },
    {
      'name': 'DeepTech Solutions',
      'logo': 'DT',
      'tagline': 'AI & Deep Learning Specialists',
      'rating': 4.8,
      'reviews': 1890,
      'projects': 320,
      'verified': true,
      'specialties': ['RNN', 'LSTM', 'GAN', 'TensorFlow'],
      'location': 'Bangalore, India',
      'responseTime': '< 2 hours',
      'startingPrice': '₹3,000',
      'color': 0xFF7C3AED,
      'image': 'https://images.unsplash.com/photo-1553877522-43269d4ea984?w=400&q=80',
      'completionRate': '98%',
    },
    {
      'name': 'VisionAI Studio',
      'logo': 'VA',
      'tagline': 'Computer Vision & Object Detection Experts',
      'rating': 4.7,
      'reviews': 1234,
      'projects': 280,
      'verified': true,
      'specialties': ['YOLO', 'OpenCV', 'Image Processing'],
      'location': 'Chennai, India',
      'responseTime': '< 3 hours',
      'startingPrice': '₹3,500',
      'color': 0xFF14B8A6,
      'image': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=400&q=80',
      'completionRate': '97%',
    },
    {
      'name': 'AcademiaPro Research',
      'logo': 'AP',
      'tagline': 'IEEE & Scopus Research Paper Writing',
      'rating': 4.9,
      'reviews': 3456,
      'projects': 890,
      'verified': true,
      'specialties': ['IEEE Papers', 'Scopus', 'Literature Survey'],
      'location': 'Delhi, India',
      'responseTime': '< 1 hour',
      'startingPrice': '₹2,000',
      'color': 0xFFEC4899,
      'image': 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400&q=80',
      'completionRate': '99%',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadVendors();
  }

  Future<void> _loadVendors() async {
    setState(() => _loading = true);
    try {
      final vendors = await ApiService.getVendors();
      if (vendors.isNotEmpty && mounted) {
        // Map API vendors to agency card format
        final colors = [0xFF2563EB, 0xFF7C3AED, 0xFF14B8A6, 0xFFF59E0B, 0xFFEC4899, 0xFF10B981, 0xFF6366F1];
        setState(() {
          _agencies = vendors.asMap().entries.map((entry) {
            final v = entry.value;
            final colorVal = colors[entry.key % colors.length];
            return {
              'id': v['id'] ?? '',
              'name': v['businessName'] ?? v['name'] ?? 'Vendor',
              'logo': (v['businessName'] ?? v['name'] ?? 'V').toString().substring(0, 2).toUpperCase(),
              'tagline': v['bio'] ?? 'Premium Project Provider',
              'rating': v['rating'] ?? 4.5,
              'reviews': v['_count']?['reviews'] ?? v['totalOrders'] ?? 0,
              'projects': v['_count']?['services'] ?? 0,
              'verified': v['isVerified'] ?? false,
              'specialties': List<String>.from(v['specialties'] ?? ['Projects']),
              'location': v['location'] ?? 'India',
              'responseTime': '< 2 hours',
              'startingPrice': '₹${v['startingPrice'] ?? '2,500'}',
              'color': colorVal,
              'image': v['coverImage'] ?? '',
              'completionRate': '${v['completionRate'] ?? 97}%',
            };
          }).toList();
          _loading = false;
        });
      } else {
        throw Exception('Empty vendors');
      }
    } catch (e) {
      // Fallback to demo data
      if (mounted) setState(() { _agencies = _demoAgencies; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadVendors,
                color: AppColors.primary,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildAgencyCard(context, _agencies[index]),
                          childCount: _agencies.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agencies', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Trusted project providers across India', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.mediumShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('${_agencies.length}+', 'Agencies'),
                Container(width: 1, height: 30, color: Colors.white24),
                _statItem('2,500+', 'Projects'),
                Container(width: 1, height: 30, color: Colors.white24),
                _statItem('12,000+', 'Students'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
      ],
    );
  }

  Widget _buildAgencyCard(BuildContext context, Map<String, dynamic> agency) {
    final color = Color(agency['color'] as int);
    final specs = agency['specialties'] as List<String>;
    final isVerified = agency['verified'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header with cover image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  agency['image'] as String,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 100, color: color.withOpacity(0.2)),
                ),
                Positioned.fill(child: Container(
                  decoration: BoxDecoration(gradient: LinearGradient(
                    colors: [color.withOpacity(0.7), Colors.black.withOpacity(0.5)],
                  )),
                )),
                Positioned(left: 14, bottom: 10, right: 14, child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Text(agency['logo'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Flexible(child: Text(agency['name'] as String, style: AppTypography.subheadingLarge.copyWith(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          if (isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: Colors.lightBlueAccent, size: 18),
                          ],
                        ]),
                        Text(agency['tagline'] as String, style: TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    )),
                  ],
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Stats row
                Row(children: [
                  _infoChip(Icons.star_rounded, '${agency['rating']} (${agency['reviews']})', AppColors.starFilled),
                  const SizedBox(width: 10),
                  _infoChip(Icons.folder_rounded, '${agency['projects']} Projects', color),
                  const SizedBox(width: 10),
                  _infoChip(Icons.location_on_rounded, agency['location'] as String, AppColors.textSecondary),
                ]),
                const SizedBox(height: 12),
                // Specialties
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: specs.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.2))),
                    child: Text(s, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                // Bottom info
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _metricItem('Response', agency['responseTime'] as String),
                      Container(width: 1, height: 25, color: AppColors.border),
                      _metricItem('Starting at', agency['startingPrice'] as String),
                      Container(width: 1, height: 25, color: AppColors.border),
                      _metricItem('Completion', agency['completionRate'] as String),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Buttons
                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AgencyProfileScreen(agency: agency)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                      child: const Center(child: Text('View Projects', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700))),
                    ),
                  )),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatDetailScreen(thread: ChatThread(
                        id: 'new',
                        vendorName: agency['name'] as String,
                        lastMessage: 'Start a conversation',
                        time: 'Now',
                        isOnline: true,
                        unreadCount: 0,
                      ))),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.chat_bubble_outline_rounded, color: color, size: 18),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 3),
          Flexible(child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 9, color: AppColors.textTertiary)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ],
    );
  }
}
