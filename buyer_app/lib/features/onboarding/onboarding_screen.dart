import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.school_rounded,
      title: 'Academic Excellence\nMade Simple',
      subtitle:
          'Browse thousands of academic services from verified vendors. From assignments to full projects — find exactly what you need.',
      gradientColors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
    ),
    _OnboardingData(
      icon: Icons.verified_user_rounded,
      title: 'Trusted &\nVerified Vendors',
      subtitle:
          'Every vendor is verified with ratings, reviews, and portfolios. Choose with confidence and get guaranteed quality work.',
      gradientColors: [Color(0xFF14B8A6), Color(0xFF2563EB)],
    ),
    _OnboardingData(
      icon: Icons.rocket_launch_rounded,
      title: 'Fast Delivery.\nFair Pricing.',
      subtitle:
          'Get your academic work delivered on time with transparent pricing. Track progress in real-time with our smart order system.',
      gradientColors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        },
        transitionDuration: AppConstants.animMedium,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    'Skip',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingXXL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: AppConstants.animFast,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.accent
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingXXL,
                0,
                AppConstants.spacingXXL,
                AppConstants.spacing4XL,
              ),
              child: CustomButton(
                label: _currentPage == _pages.length - 1
                    ? 'Get Started'
                    : 'Continue',
                onPressed: _nextPage,
                size: CustomButtonSize.large,
                icon: _currentPage == _pages.length - 1
                    ? Icons.arrow_forward_rounded
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing3XL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradientColors,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: data.gradientColors[0].withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing5XL),
          Text(
            data.title,
            style: AppTypography.displayMedium.copyWith(
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Text(
            data.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });
}
