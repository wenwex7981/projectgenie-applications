import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'vendor_dashboard_screen.dart';
import '../services/vendor_services_screen.dart';
import '../orders/vendor_orders_screen.dart';
import '../earnings/vendor_earnings_screen.dart';
import '../profile/vendor_profile_screen.dart';

class VendorMainNavigation extends StatefulWidget {
  final String vendorId;
  final String vendorName;
  const VendorMainNavigation({super.key, required this.vendorId, required this.vendorName});

  @override
  State<VendorMainNavigation> createState() => _VendorMainNavigationState();
}

class _VendorMainNavigationState extends State<VendorMainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      VendorDashboardScreen(vendorId: widget.vendorId, vendorName: widget.vendorName),
      VendorServicesScreen(vendorId: widget.vendorId),
      VendorOrdersScreen(vendorId: widget.vendorId),
      VendorEarningsScreen(vendorId: widget.vendorId),
      VendorProfileScreen(vendorId: widget.vendorId),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 68,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
                _navItem(1, Icons.inventory_2_outlined, Icons.inventory_2_rounded, 'Listings'),
                _navItem(2, Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Orders'),
                _navItem(3, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Earnings'),
                _navItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? VC.accent.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(isActive ? activeIcon : icon, size: 22, color: isActive ? VC.accent : VC.textTer),
            ),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: isActive ? FontWeight.w800 : FontWeight.w500, color: isActive ? VC.accent : VC.textTer)),
          ],
        ),
      ),
    );
  }
}
