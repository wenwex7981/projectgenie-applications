import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import 'add_service_screen.dart';
import 'add_project_screen.dart';
import 'add_hackathon_screen.dart';
class VendorServicesScreen extends StatefulWidget {
  final String vendorId;
  const VendorServicesScreen({super.key, required this.vendorId});

  @override
  State<VendorServicesScreen> createState() => _VendorServicesScreenState();
}

class _VendorServicesScreenState extends State<VendorServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<dynamic> _services = [];
  List<dynamic> _projects = [];
  List<dynamic> _hackathons = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final services = await ApiService.getVendorServices(widget.vendorId);
      final projects = await ApiService.getVendorProjects(widget.vendorId);
      final hackathons = await ApiService.getVendorHackathons(widget.vendorId);
      if (mounted) setState(() { _services = services; _projects = projects; _hackathons = hackathons; _loading = false; });
    } catch (e) {
      // Offline fallback
      if (mounted) setState(() {
        _services = [
          {'id': '1', 'title': 'Breast Cancer Detection CNN', 'price': 4999, 'rating': 4.9, 'reviewCount': 128, 'status': 'Active', 'category': {'title': 'CNN Projects'}, '_count': {'orders': 45, 'reviews': 128}},
          {'id': '2', 'title': 'E-Commerce MERN Stack', 'price': 5500, 'rating': 4.8, 'reviewCount': 340, 'status': 'Active', 'category': {'title': 'Web Dev'}, '_count': {'orders': 120, 'reviews': 340}},
          {'id': '3', 'title': 'Stock Price Prediction LSTM', 'price': 3500, 'rating': 4.6, 'reviewCount': 112, 'status': 'Active', 'category': {'title': 'Deep Learning'}, '_count': {'orders': 38, 'reviews': 112}},
        ];
        _projects = [
          {'id': '1', 'title': 'AI Plant Disease Detection', 'domain': 'AI/ML', 'price': '₹4,999', 'rating': 4.9, 'enrollees': 1250, 'isActive': true},
          {'id': '2', 'title': 'Sentiment Analysis on Twitter', 'domain': 'Data Science', 'price': '₹2,999', 'rating': 4.4, 'enrollees': 680, 'isActive': true},
        ];
        _hackathons = [
          {'id': '1', 'title': 'Global AI Hackathon 2026', 'organizer': 'TechVision', 'prizePool': '₹5,00,000', 'teamSize': '2-4 Members', 'isActive': true},
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              color: Colors.white,
              child: Column(children: [
                Row(children: [
                  Text('My Listings', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: VC.text)),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Widget target;
                      if (_tabCtrl.index == 0) target = AddServiceScreen(vendorId: widget.vendorId);
                      else if (_tabCtrl.index == 1) target = AddProjectScreen(vendorId: widget.vendorId);
                      else target = AddHackathonScreen(vendorId: widget.vendorId);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => target)).then((_) => _loadData());
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text('Add New', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VC.accent, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabCtrl,
                  labelColor: VC.accent, unselectedLabelColor: VC.textSec,
                  labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                  indicatorColor: VC.accent, indicatorWeight: 3, dividerColor: VC.border,
                  tabs: [
                    Tab(text: 'Services (${_services.length})'),
                    Tab(text: 'Projects (${_projects.length})'),
                    Tab(text: 'Hackathons (${_hackathons.length})'),
                  ],
                ),
              ]),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(controller: _tabCtrl, children: [
                      _buildServicesList(),
                      _buildProjectsList(),
                      _buildHackathonsList(),
                    ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    if (_services.isEmpty) return _empty('No services yet', 'Add your first service to start earning');
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final s = _services[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: VC.border), boxShadow: VC.softShadow),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(s['title'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text), maxLines: 2, overflow: TextOverflow.ellipsis)),
                PopupMenuButton<String>(
                  onSelected: (v) => _handleServiceAction(v, s),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: const Icon(Icons.more_vert_rounded, color: VC.textTer),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(6)),
                  child: Text(s['category']?['title'] ?? '', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: VC.accent)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                Text(' ${s['rating'] ?? 0}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: VC.text)),
                Text(' (${s['reviewCount'] ?? s['_count']?['reviews'] ?? 0})', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('₹${s['price']}', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: VC.accent)),
                Row(children: [
                  _miniStat(Icons.shopping_bag_rounded, '${s['_count']?['orders'] ?? 0}', 'Orders'),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: VC.successBg, borderRadius: BorderRadius.circular(6)),
                    child: Text('Active', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: VC.success)),
                  ),
                ]),
              ]),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildProjectsList() {
    if (_projects.isEmpty) return _empty('No projects yet', 'Add your first project listing');
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final p = _projects[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: VC.border), boxShadow: VC.softShadow),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(p['title'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text))),
                PopupMenuButton<String>(
                  onSelected: (v) => _handleProjectAction(v, p),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: const Icon(Icons.more_vert_rounded, color: VC.textTer),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: VC.purpleBg, borderRadius: BorderRadius.circular(6)),
                  child: Text(p['domain'] ?? '', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: VC.purple)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                Text(' ${p['rating'] ?? 0}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Icon(Icons.people_rounded, size: 14, color: VC.textTer),
                Text(' ${p['enrollees'] ?? 0}', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(p['price'] ?? '', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: VC.accent)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: (p['isActive'] ?? true) ? VC.successBg : VC.errorBg, borderRadius: BorderRadius.circular(6)),
                  child: Text((p['isActive'] ?? true) ? 'Active' : 'Inactive', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: (p['isActive'] ?? true) ? VC.success : VC.error)),
                ),
              ]),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildHackathonsList() {
    if (_hackathons.isEmpty) return _empty('No hackathons yet', 'Host your first hackathon');
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _hackathons.length,
        itemBuilder: (context, index) {
          final h = _hackathons[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: VC.border), boxShadow: VC.softShadow),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(h['title'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text))),
                PopupMenuButton<String>(
                  onSelected: (v) => _handleHackathonAction(v, h),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: const Icon(Icons.more_vert_rounded, color: VC.textTer),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                  child: Text(h['organizer'] ?? 'Unknown', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFFD97706))),
                ),
                const SizedBox(width: 8),
                Icon(Icons.emoji_events_rounded, size: 14, color: VC.accent),
                Text(' Pool: ${h['prizePool'] ?? 'TBA'}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: VC.accent)),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                   Icon(Icons.group_rounded, size: 14, color: VC.textTer),
                   Text(' ${h['teamSize'] ?? '1-4'}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: VC.textSec)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: (h['isActive'] ?? true) ? VC.successBg : VC.errorBg, borderRadius: BorderRadius.circular(6)),
                  child: Text((h['isActive'] ?? true) ? 'Active' : 'Inactive', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: (h['isActive'] ?? true) ? VC.success : VC.error)),
                ),
              ]),
            ]),
          );
        },
      ),
    );
  }

  Widget _miniStat(IconData icon, String val, String label) {
    return Row(children: [
      Icon(icon, size: 14, color: VC.textTer),
      const SizedBox(width: 4),
      Text(val, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: VC.textSec)),
    ]);
  }

  Widget _empty(String title, String sub) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 72, height: 72, decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.inventory_2_rounded, size: 32, color: VC.accent)),
      const SizedBox(height: 16),
      Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: VC.text)),
      const SizedBox(height: 4),
      Text(sub, style: GoogleFonts.inter(fontSize: 13, color: VC.textTer)),
    ]));
  }

  void _handleServiceAction(String action, dynamic service) async {
    if (action == 'delete') {
      try { await ApiService.deleteService(service['id']); _loadData(); } catch (_) {}
    }
  }

  void _handleProjectAction(String action, dynamic project) async {
    if (action == 'delete') {
      try { await ApiService.deleteProject(project['id']); _loadData(); } catch (_) {}
    }
  }

  void _handleHackathonAction(String action, dynamic hackathon) async {
    if (action == 'delete') {
      try { await ApiService.deleteHackathon(hackathon['id']); _loadData(); } catch (_) {}
    }
  }
}
