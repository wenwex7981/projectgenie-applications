import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/api_service.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_colors.dart';
import 'service_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.apps_rounded},
    {'label': 'Web', 'icon': Icons.language_rounded},
    {'label': 'Mobile', 'icon': Icons.phone_android_rounded},
    {'label': 'AI', 'icon': Icons.psychology_rounded},
    {'label': 'ML', 'icon': Icons.model_training_rounded},
    {'label': 'IoT', 'icon': Icons.sensors_rounded},
    {'label': 'Cloud', 'icon': Icons.cloud_rounded},
    {'label': 'Data', 'icon': Icons.analytics_rounded},
    {'label': 'Internships', 'icon': Icons.work_rounded},
  ];
  String _selectedFilter = 'All';
  bool _isGridView = true;
  String _sortBy = 'Popularity';
  List<ServiceModel> _services = [];
  bool _loading = true;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _loadServices();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getServices(
        category: _selectedFilter == 'All' ? null : _selectedFilter,
      );
      if (mounted) {
        setState(() { _services = _sortServices(data); _loading = false; });
        _fadeCtrl.forward(from: 0);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<ServiceModel> _sortServices(List<ServiceModel> list) {
    final sorted = List<ServiceModel>.from(list);
    switch (_sortBy) {
      case 'Price: Low to High':
        sorted.sort((a, b) => (double.tryParse(a.price) ?? 0).compareTo(double.tryParse(b.price) ?? 0));
        break;
      case 'Price: High to Low':
        sorted.sort((a, b) => (double.tryParse(b.price) ?? 0).compareTo(double.tryParse(a.price) ?? 0));
        break;
      case 'Top Rated':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Most Reviews':
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      default:
        break;
    }
    return sorted;
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
                            Text('Services', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -0.5)),
                            Text('Marketplace', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      _headerAction(
                        _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                        () => setState(() => _isGridView = !_isGridView),
                      ),
                      const SizedBox(width: 8),
                      _headerAction(Icons.tune_rounded, _showSortOptions),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ─── Filter Chips ────────────────────────────────
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final f = _filters[index];
                        final isSelected = f['label'] == _selectedFilter;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedFilter = f['label']);
                            _loadServices();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.heroGradient : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
                              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
                            ),
                            child: Row(
                              children: [
                                Icon(f['icon'], size: 16, color: isSelected ? Colors.white : AppColors.textTertiary),
                                const SizedBox(width: 6),
                                Text(
                                  f['label'],
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            // ─── Results Bar ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(text: TextSpan(children: [
                    TextSpan(text: '${_loading ? '...' : _services.length} ', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    TextSpan(text: 'results', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textTertiary)),
                    TextSpan(text: ' • $_selectedFilter', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ])),
                  GestureDetector(
                    onTap: _showSortOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        const Icon(Icons.sort_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(_sortBy, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            // ─── Content ────────────────────────────────────────────
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _headerAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return _buildShimmerLoading();
    if (_services.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.search_off_rounded, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('No Services Found', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text('Try changing the filter or search term', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
        ],
      ));
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: RefreshIndicator(
        onRefresh: _loadServices,
        color: AppColors.primary,
        child: _isGridView
            ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.62,
                  crossAxisSpacing: 14, mainAxisSpacing: 14,
                ),
                itemCount: _services.length,
                itemBuilder: (context, index) => _ServiceCardGrid(service: _services[index]),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                itemCount: _services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _ServiceCardList(service: _services[index]),
              ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: _isGridView
          ? GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.62, crossAxisSpacing: 14, mainAxisSpacing: 14),
              itemCount: 6,
              itemBuilder: (_, __) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 5,
              itemBuilder: (_, __) => Container(height: 110, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Sort By', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              ...['Popularity', 'Price: Low to High', 'Price: High to Low', 'Top Rated', 'Most Reviews'].map((option) {
                final isSelected = _sortBy == option;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(option, style: GoogleFonts.inter(fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                  trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    setState(() { _sortBy = option; _services = _sortServices(_services); });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceCardGrid extends StatelessWidget {
  final ServiceModel service;
  const _ServiceCardGrid({required this.service});

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
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: service.imageUrl ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primary.withOpacity(0.06),
                        child: Center(child: Icon(Icons.code_rounded, size: 32, color: AppColors.primary.withOpacity(0.3))),
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                      ),
                      child: Row(children: [
                        const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 2),
                        Text('${service.rating}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      ]),
                    ),
                  ),
                  // Category badge
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
            // Info
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
                      Text('${service.reviewCount} sold', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
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

class _ServiceCardList extends StatelessWidget {
  final ServiceModel service;
  const _ServiceCardList({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: service))),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: service.imageUrl ?? '',
                width: 120, height: 120,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 120, color: AppColors.primary.withOpacity(0.06),
                  child: Center(child: Icon(Icons.code_rounded, size: 28, color: AppColors.primary.withOpacity(0.3))),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(4)),
                      child: Text(service.category.toUpperCase(), style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 6),
                    Text(service.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹${service.price}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            Text('View', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Colors.white),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
