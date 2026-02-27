import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/api_service.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import '../services/service_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'search_results_screen.dart';
import 'advanced_filters_screen.dart';
import 'package:shimmer/shimmer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  final List<Map<String, dynamic>> _tabs = [
    {'label': 'All', 'icon': Icons.apps_rounded},
    {'label': 'Python', 'icon': Icons.code_rounded},
    {'label': 'Web', 'icon': Icons.language_rounded},
    {'label': 'App', 'icon': Icons.phone_android_rounded},
    {'label': 'AI/ML', 'icon': Icons.psychology_rounded},
    {'label': 'Design', 'icon': Icons.design_services_rounded},
    {'label': 'Marketing', 'icon': Icons.campaign_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Premium Header ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Explore', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.5)),
                            Text('Discover services & projects', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                          ],
                        ),
                      ),
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
                        child: IconButton(
                          icon: const Icon(Icons.tune_rounded, size: 20, color: AppColors.textSecondary),
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvancedFiltersScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // ─── Search Bar ──────────────────────────────────
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, size: 22, color: AppColors.textTertiary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onSubmitted: (query) {
                              if (query.trim().isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsScreen(query: query.trim())));
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Search projects, services, experts...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textTertiary, fontWeight: FontWeight.w400),
                            ),
                            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _searchCtrl.clear()),
                            child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textTertiary),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // ─── Tabs ────────────────────────────────────────
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: _tabs.map((t) => Tab(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(t['icon'], size: 16),
                        const SizedBox(width: 6),
                        Text(t['label']),
                      ]),
                    )).toList(),
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textTertiary,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: AppColors.border,
                    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
                    unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ],
              ),
            ),
            // ─── Content ────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((t) => _ServiceGrid(category: t['label'])).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceGrid extends StatefulWidget {
  final String category;
  const _ServiceGrid({required this.category});

  @override
  State<_ServiceGrid> createState() => _ServiceGridState();
}

class _ServiceGridState extends State<_ServiceGrid> with AutomaticKeepAliveClientMixin {
  List<ServiceModel>? _services;
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getServices(category: widget.category == 'All' ? null : widget.category);
      if (mounted) setState(() { _services = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _services = []; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) return _buildShimmer();
    if (_services == null || _services!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.search_off_rounded, size: 32, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text('No results in ${widget.category}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Try a different category', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.65,
          crossAxisSpacing: 14, mainAxisSpacing: 14,
        ),
        itemCount: _services!.length,
        itemBuilder: (context, index) => _ExploreCard(service: _services![index]),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 14, mainAxisSpacing: 14),
        itemCount: 6,
        itemBuilder: (_, __) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final ServiceModel service;
  const _ExploreCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: service))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: service.imageUrl ?? '',
                      width: double.infinity, fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primary.withOpacity(0.06),
                        child: Center(child: Icon(Icons.code_rounded, size: 32, color: AppColors.primary.withOpacity(0.3))),
                      ),
                    ),
                  ),
                  // Rating pill
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                      ),
                      child: Row(children: [
                        const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 2),
                        Text('${service.rating}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                  ),
                  // Category
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.9), borderRadius: BorderRadius.circular(6)),
                      child: Text(service.category.toUpperCase(), style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
            // Info section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary, height: 1.3)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.person_rounded, size: 12, color: AppColors.textTertiary),
                    const SizedBox(width: 3),
                    Expanded(child: Text(service.vendorName, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${service.price}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(6)),
                        child: Text('View', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
