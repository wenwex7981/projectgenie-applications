import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HackathonRegistrationScreen extends StatefulWidget {
  const HackathonRegistrationScreen({super.key});

  @override
  State<HackathonRegistrationScreen> createState() => _HackathonRegistrationScreenState();
}

class _HackathonRegistrationScreenState extends State<HackathonRegistrationScreen> {
  bool _isCreateTeam = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PROJECT GENIE',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 24),
                  _buildEventStats(),
                  const SizedBox(height: 32),
                  const Text('Ready to build the future?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  const Text('Join hundreds of developers worldwide in the ultimate coding challenge.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                  const SizedBox(height: 24),
                  _buildSegmentedControl(),
                  const SizedBox(height: 24),
                  _buildForm(),
                  const SizedBox(height: 24),
                  _buildInfoBox(),
                ],
              ),
            ),
          ),
          _buildActionArea(),
          _buildBottomNavMockup(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Stack(
        children: [
          // Geometric pattern mockup
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Text('REGISTRATION OPEN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('GLOBAL HACKATHON', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
                const SizedBox(height: 4),
                const Text('CodeGenie 2024', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventStats() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(Icons.calendar_today, 'DATE', 'Oct 15-17'),
          const SizedBox(width: 12),
          _buildStatCard(Icons.payments, 'PRIZE POOL', '\$10,000'),
          const SizedBox(width: 12),
          _buildStatCard(Icons.hub, 'FORMAT', 'Hybrid'),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: AppTheme.primaryColor.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isCreateTeam = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isCreateTeam ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _isCreateTeam ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
                ),
                alignment: Alignment.center,
                child: Text('Create Team', style: TextStyle(color: _isCreateTeam ? Colors.white : const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isCreateTeam = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isCreateTeam ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: !_isCreateTeam ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
                ),
                alignment: Alignment.center,
                child: Text('Join Team', style: TextStyle(color: !_isCreateTeam ? Colors.white : const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Team Name',
          hint: 'Enter a cool team name',
          count: '0/24',
        ),
        const SizedBox(height: 20),
        Opacity(
          opacity: 0.5,
          child: _buildInputField(
            label: 'Invite Code (Optional)',
            hint: '6-digit code',
            icon: Icons.lock_outline,
            enabled: false,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({required String label, required String hint, String? count, IconData? icon, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        TextField(
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            suffixIcon: count != null 
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(count, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)))])
              : (icon != null ? Icon(icon, color: const Color(0xFFCBD5E1)) : null),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8), // yellow-50
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFEF9C3)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFFCA8A04), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'By registering, you agree to the CodeGenie Code of Conduct and Competition Rules. Teams are limited to 4 members max.',
              style: TextStyle(color: Color(0xFF854D0E), fontSize: 11, height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionArea() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: AppTheme.primaryColor.withOpacity(0.3),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('REGISTER FOR HACKATHON', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                  SizedBox(width: 8),
                  Icon(Icons.rocket_launch, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hackathon Rules & FAQ',
            style: TextStyle(
              color: AppTheme.primaryColor.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavMockup() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          _BottomNavItem(icon: Icons.event, label: 'Register', isSelected: true),
          _BottomNavItem(icon: Icons.groups_outlined, label: 'Team'),
          _BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  const _BottomNavItem({required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? AppTheme.primaryColor : const Color(0xFF94A3B8)),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(color: isSelected ? AppTheme.primaryColor : const Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 24) {
      for (double j = 0; j < size.height; j += 24) {
        canvas.drawCircle(Offset(i, j), 1, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
