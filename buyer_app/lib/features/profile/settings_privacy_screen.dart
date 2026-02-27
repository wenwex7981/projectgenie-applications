import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'edit_profile_screen.dart';

class SettingsPrivacyScreen extends StatefulWidget {
  const SettingsPrivacyScreen({super.key});

  @override
  State<SettingsPrivacyScreen> createState() => _SettingsPrivacyScreenState();
}

class _SettingsPrivacyScreenState extends State<SettingsPrivacyScreen> {
  bool _pushNotifications = true;
  bool _biometricLogin = false;
  int _appearanceIndex = 0; // 0: Light, 1: Dark, 2: System

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8).withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Settings & Privacy',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserHeader(),
            _buildSectionHeader('Preferences'),
            _buildPreferencesCard(),
            _buildSectionHeader('Security'),
            _buildSecurityCard(),
            _buildSectionHeader('Support & Legal'),
            _buildSupportLegalCard(),
            _buildDangerZone(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBDY7_oJDmWGRLG-BJdgZlFRFCojWnLVQtLG6MwkF3TZtCz03_yovC2-42xKHR_MG8xUi3GiOkgmhEgqVeMu4g7NugKfrn60fmSIJs-NvAPVPLvWdW5m6x6oLAzdAKw0bwY49GYKLpbaNhc-4WdgHReYawnm0K_kWwO0ZJtHve289tO64QH_YJo1248WeiQ4j53Xw8l9GMi7gYkCQBCyQT4E2JLuBqH0JiB8x1xTVu26LBQ_VxS1O338rTbzO1QN_k0ITASM7lbiVQ"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alex Genie', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A))),
                  Text('alex.genie@example.com', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
              },
              child: const Text('Edit', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 12),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Column(
          children: [
            _buildSwitchItem(Icons.notifications, 'Push Notifications', _pushNotifications, (val) => setState(() => _pushNotifications = val)),
            _buildAppearanceSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.palette, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              const Text('Appearance', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                _buildAppearanceButton(0, Icons.light_mode, 'Light'),
                _buildAppearanceButton(1, Icons.dark_mode, 'Dark'),
                _buildAppearanceButton(2, Icons.devices, 'System'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceButton(int index, IconData icon, String label) {
    bool isSelected = _appearanceIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _appearanceIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? AppTheme.primaryColor : const Color(0xFF64748B)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppTheme.primaryColor : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.fingerprint, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Biometric Login', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                    Text('FaceID or Fingerprint', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _biometricLogin,
                onChanged: (val) => setState(() => _biometricLogin = val),
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportLegalCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Column(
          children: [
            _buildNavigationItem(Icons.gavel, 'Privacy Policy'),
            _buildNavigationItem(Icons.description, 'Terms of Service', isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
      child: Column(
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            label: const Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              side: const BorderSide(color: Color(0xFFFEE2E2)),
              backgroundColor: const Color(0xFFFEF2F2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Once you delete your account, there is no going back. Please be certain.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
