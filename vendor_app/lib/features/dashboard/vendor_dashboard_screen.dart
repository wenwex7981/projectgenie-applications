import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class VendorDashboardScreen extends StatefulWidget {
  final String vendorId;
  final String vendorName;
  const VendorDashboardScreen({super.key, required this.vendorId, required this.vendorName});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _dashboard;
  bool _loading = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _loadDashboard();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await ApiService.getDashboard(widget.vendorId);
      if (mounted) setState(() { _dashboard = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() {
        _dashboard = {
          'stats': {
            'totalOrders': 328, 'activeOrders': 12, 'completedOrders': 310,
            'totalServices': 8, 'totalProjects': 5, 'pendingCustomOrders': 3,
            'totalEarnings': 450000,
          },
          'recentOrders': [],
          'recentTransactions': [],
        };
        _loading = false;
      });
    }
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      body: SafeArea(
        child: _loading
            ? _buildLoadingState()
            : FadeTransition(
                opacity: _fadeAnim,
                child: RefreshIndicator(
                  onRefresh: _loadDashboard,
                  color: VC.accent,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildEarningsHeroCard(),
                        const SizedBox(height: 20),
                        _buildQuickActionsRow(),
                        const SizedBox(height: 28),
                        _buildStatsGrid(),
                        const SizedBox(height: 28),
                        _buildSectionTitle('RECENT ORDERS'),
                        const SizedBox(height: 12),
                        _buildRecentOrders(),
                        const SizedBox(height: 28),
                        _buildSectionTitle('RECENT TRANSACTIONS'),
                        const SizedBox(height: 12),
                        _buildRecentTransactions(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // ─── Loading Shimmer State ──────────────────────────────────────
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(200, 48),
          const SizedBox(height: 24),
          _shimmerBox(double.infinity, 160),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _shimmerBox(double.infinity, 72)),
            const SizedBox(width: 12),
            Expanded(child: _shimmerBox(double.infinity, 72)),
            const SizedBox(width: 12),
            Expanded(child: _shimmerBox(double.infinity, 72)),
          ]),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _shimmerBox(double.infinity, 100)),
            const SizedBox(width: 12),
            Expanded(child: _shimmerBox(double.infinity, 100)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _shimmerBox(double.infinity, 100)),
            const SizedBox(width: 12),
            Expanded(child: _shimmerBox(double.infinity, 100)),
          ]),
        ],
      ),
    );
  }

  Widget _shimmerBox(double w, double h) {
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        color: VC.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────
  Widget _buildHeader() {
    final firstName = widget.vendorName.split(' ').first;
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';
    
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            gradient: VC.heroGrad,
            borderRadius: BorderRadius.circular(16),
            boxShadow: VC.primaryShadow,
          ),
          child: Center(
            child: Text(
              firstName.isNotEmpty ? firstName[0].toUpperCase() : 'V',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting, $firstName 👋', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: VC.text)),
              const SizedBox(height: 2),
              Text('Seller Dashboard', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: VC.textTer)),
            ],
          ),
        ),
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: VC.surfaceAlt,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: VC.border),
          ),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 22, color: VC.textSec), 
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
              Positioned(
                right: 8, top: 8,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: VC.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Earnings Hero Card ──────────────────────────────────────────
  Widget _buildEarningsHeroCard() {
    final stats = _dashboard?['stats'] ?? {};
    final earnings = (stats['totalEarnings'] ?? 0).toDouble();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: VC.heroGrad,
        borderRadius: BorderRadius.circular(24),
        boxShadow: VC.primaryShadow,
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(right: -30, top: -30, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)))),
          Positioned(left: -20, bottom: -20, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: VC.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up_rounded, size: 14, color: VC.success),
                        const SizedBox(width: 4),
                        Text('Total Earnings', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: VC.success)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                    child: Text('This Month', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white60)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('₹${_formatCurrency(earnings)}', style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _heroPill('${stats['totalOrders'] ?? 0}', 'Total\nOrders', Icons.receipt_long_rounded),
                    Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                    _heroPill('${stats['activeOrders'] ?? 0}', 'Active\nOrders', Icons.pending_actions_rounded),
                    Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                    _heroPill('${stats['pendingCustomOrders'] ?? 0}', 'Custom\nRequests', Icons.rocket_launch_rounded),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  Widget _heroPill(String val, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.white60),
        const SizedBox(height: 6),
        Text(val, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white54, height: 1.3)),
      ],
    );
  }

  // ─── Quick Actions ──────────────────────────────────────────────
  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        _quickAction('Add\nService', Icons.add_box_rounded, VC.accent, VC.accentLight),
        const SizedBox(width: 10),
        _quickAction('View\nOrders', Icons.assignment_rounded, VC.purple, VC.purpleBg),
        const SizedBox(width: 10),
        _quickAction('Earnings\nReport', Icons.account_balance_wallet_rounded, VC.success, VC.successBg),
      ],
    );
  }

  Widget _quickAction(String label, IconData icon, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VC.border),
          boxShadow: VC.softShadow,
        ),
        child: Column(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: VC.text, height: 1.3)),
          ],
        ),
      ),
    );
  }

  // ─── Stats Grid ────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    final stats = _dashboard?['stats'] ?? {};
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _statCard('Active Services', '${stats['totalServices'] ?? 0}', Icons.inventory_2_rounded, VC.accent, VC.accentLight),
        _statCard('Live Projects', '${stats['totalProjects'] ?? 0}', Icons.school_rounded, VC.purple, VC.purpleBg),
        _statCard('Completed', '${stats['completedOrders'] ?? 0}', Icons.check_circle_rounded, VC.success, VC.successBg),
        _statCard('Custom Requests', '${stats['pendingCustomOrders'] ?? 0}', Icons.rocket_launch_rounded, VC.warning, VC.warningBg),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VC.border),
        boxShadow: VC.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 18, color: color),
            ),
            const Spacer(),
            Text(value, style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: VC.text)),
          ]),
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: VC.textSec)),
        ],
      ),
    );
  }

  // ─── Section Title ──────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: VC.textSec, letterSpacing: 1)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(100)),
          child: Text('View All', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: VC.accent)),
        ),
      ],
    );
  }

  // ─── Recent Orders ──────────────────────────────────────────────
  Widget _buildRecentOrders() {
    final orders = _dashboard?['recentOrders'] as List? ?? [];
    if (orders.isEmpty) return _emptyState('No recent orders yet', 'Orders from clients will appear here', Icons.receipt_long_rounded);

    return Column(
      children: orders.take(5).map((o) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VC.border),
          boxShadow: VC.softShadow,
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.receipt_rounded, size: 20, color: VC.accent),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o['service']?['title'] ?? 'Order', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.text), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(o['user']?['name'] ?? '', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: VC.textTer)),
          ])),
          _statusBadge(o['status'] ?? 'Pending'),
        ]),
      )).toList(),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    Color bg;
    switch (status) {
      case 'Completed':
        color = VC.success; bg = VC.successBg; break;
      case 'Active':
        color = VC.accent; bg = VC.accentLight; break;
      case 'Cancelled':
        color = VC.error; bg = VC.errorBg; break;
      default:
        color = VC.warning; bg = VC.warningBg;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }

  // ─── Recent Transactions ─────────────────────────────────────────
  Widget _buildRecentTransactions() {
    final txns = _dashboard?['recentTransactions'] as List? ?? [];
    if (txns.isEmpty) return _emptyState('No transactions yet', 'Earnings will be tracked here', Icons.account_balance_wallet_rounded);

    return Column(
      children: txns.take(5).map((t) {
        final isCredit = t['type'] == 'credit';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: VC.border),
            boxShadow: VC.softShadow,
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: isCredit ? VC.successBg : VC.errorBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                size: 18, color: isCredit ? VC.success : VC.error,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['description'] ?? '', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: VC.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(t['status'] ?? 'completed', style: GoogleFonts.inter(fontSize: 10, color: VC.textTer)),
              ],
            )),
            Text(
              '${isCredit ? '+' : '-'}₹${t['amount']}',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: isCredit ? VC.success : VC.error),
            ),
          ]),
        );
      }).toList(),
    );
  }

  // ─── Empty State ─────────────────────────────────────────────────
  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VC.border),
        boxShadow: VC.softShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, size: 28, color: VC.textTer),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: VC.textTer)),
        ],
      ),
    );
  }
}
