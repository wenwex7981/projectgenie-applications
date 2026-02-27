import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../categories/final_year_projects_screen.dart';
import '../orders/orders_screen.dart';
import '../account/account_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const CategoriesScreen(),
      const FinalYearProjectsScreen(),
      const OrdersScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 68,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(ref, 0, Icons.home_outlined, Icons.home_rounded, 'Home'),
                _buildNavItem(ref, 1, Icons.category_outlined, Icons.category_rounded, 'Categories'),
                _buildNavItem(ref, 2, Icons.school_outlined, Icons.school_rounded, 'Projects'),
                _buildNavItem(ref, 3, Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Orders'),
                _buildNavItem(ref, 4, Icons.person_outline_rounded, Icons.person_rounded, 'Account'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(WidgetRef ref, int index, IconData icon, IconData activeIcon, String label) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
