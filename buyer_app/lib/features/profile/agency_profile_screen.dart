import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/service_card.dart';
import '../../core/models/models.dart';
import '../../core/services/api_service.dart';
import '../services/service_detail_screen.dart';

class AgencyProfileScreen extends StatefulWidget {
  final Map<String, dynamic> agency;

  const AgencyProfileScreen({super.key, required this.agency});

  @override
  State<AgencyProfileScreen> createState() => _AgencyProfileScreenState();
}

class _AgencyProfileScreenState extends State<AgencyProfileScreen> {
  bool _isLoading = true;
  List<ServiceModel> _agencyServices = [];

  @override
  void initState() {
    super.initState();
    _loadAgencyServices();
  }

  Future<void> _loadAgencyServices() async {
    // In a real app, we'd filter by vendorId. For now, we'll fetch all and filter client-side or just show all for demo
    // Or we can mock it by showing random services
    try {
      final services = await ApiService.getServices();
      // Mock filtering: just take some
      if (mounted) {
        setState(() {
          _agencyServices = services.take(4).toList(); // Mock data for demo
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final agency = widget.agency;
    final color = Color(agency['color'] ?? 0xFF2563EB);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    agency['image'] ?? 'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            agency['logo'] ?? 'AG',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                agency['name'] ?? 'Agency Name',
                                style: AppTypography.headingMedium.copyWith(color: Colors.white),
                              ),
                              Text(
                                agency['location'] ?? 'Location',
                                style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Rating', '${agency['rating']} ★'),
                        _buildStat('Projects', '${agency['projects']}+'),
                        _buildStat('Response', agency['responseTime'] ?? '1h'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description / Tagline
                  Text('About', style: AppTypography.headingSmall),
                  const SizedBox(height: 8),
                  Text(
                    agency['tagline'] ?? 'We provide high quality projects.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  
                  // Services List
                  Text('Available Projects', style: AppTypography.headingSmall),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          _isLoading
              ? const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final service = _agencyServices[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ServiceCard(
                            service: service,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: service)),
                            ),
                          ),
                        );
                      },
                      childCount: _agencyServices.length,
                    ),
                  ),
                ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Contact Agency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.headingSmall),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
      ],
    );
  }
}
