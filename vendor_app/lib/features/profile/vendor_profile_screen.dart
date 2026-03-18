import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import '../auth/vendor_login_screen.dart';
import 'edit_profile_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  final String vendorId;
  const VendorProfileScreen({super.key, required this.vendorId});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  Map<String, dynamic> _vendor = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ApiService.getProfile(widget.vendorId);
      if (mounted) setState(() { _vendor = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() {
        _vendor = {
          'name': 'Dr. Priya Sharma', 'businessName': 'AI Research Lab',
          'email': 'ailab@projectgenie.com', 'phone': '+91 98765 43210',
          'bio': 'PhD in ML from IIT Delhi. 8+ years building AI/ML projects.',
          'rating': 4.9, 'isVerified': true,
          'totalEarnings': 450000, 'totalOrders': 328,
          '_count': {'services': 8, 'projects': 5, 'orders': 328, 'customOrders': 12},
        };
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  _buildMenuSection(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 80),
                ]),
              ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: VC.heroGrad, borderRadius: BorderRadius.circular(24), boxShadow: VC.medShadow),
      child: Column(children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
          ),
          child: Center(child: Text(
            (_vendor['name'] ?? 'V').substring(0, 1).toUpperCase(),
            style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
          )),
        ),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_vendor['name'] ?? '', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          if (_vendor['isVerified'] == true) ...[
            const SizedBox(width: 6),
            const Icon(Icons.verified_rounded, size: 18, color: Color(0xFF60A5FA)),
          ],
        ]),
        const SizedBox(height: 4),
        Text(_vendor['businessName'] ?? '', style: GoogleFonts.inter(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFBBF24)),
          const SizedBox(width: 4),
          Text('${_vendor['rating'] ?? 0}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(' rating', style: GoogleFonts.inter(fontSize: 12, color: Colors.white60)),
        ]),
        if (_vendor['bio'] != null) ...[
          const SizedBox(height: 12),
          Text(_vendor['bio'], style: GoogleFonts.inter(fontSize: 12, color: Colors.white70, height: 1.4), textAlign: TextAlign.center),
        ],
      ]),
    );
  }

  Widget _buildStatsRow() {
    final counts = _vendor['_count'] ?? {};
    return Row(children: [
      _statTile('Services', '${counts['services'] ?? 0}', VC.accent),
      const SizedBox(width: 12),
      _statTile('Projects', '${counts['projects'] ?? 0}', VC.purple),
      const SizedBox(width: 12),
      _statTile('Orders', '${counts['orders'] ?? 0}', VC.success),
    ]);
  }

  Widget _statTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: VC.border), boxShadow: VC.softShadow),
        child: Column(children: [
          Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: VC.textSec)),
        ]),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: VC.border)),
      child: Column(children: [
        _menuItem(Icons.person_rounded, 'Edit Profile', 'Update your info', () async {
          final changed = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditProfileScreen(vendorId: widget.vendorId, currentData: _vendor)),
          );
          if (changed == true) _loadProfile();
        }),
        _menuDivider(),
        _menuItem(Icons.account_balance_rounded, 'Bank Details', 'Manage payout accounts', () {}),
        _menuDivider(),
        _menuItem(Icons.notifications_rounded, 'Notifications', 'Manage alert preferences', () {}),
        _menuDivider(),
        _menuItem(Icons.security_rounded, 'Security', 'Password & 2FA', () {}),
        _menuDivider(),
        _menuItem(Icons.help_rounded, 'Help & Support', 'Contact seller support', () {}),
        _menuDivider(),
        _menuItem(Icons.description_rounded, 'Terms & Policies', 'Seller guidelines', () {}),
      ]),
    );
  }

  Widget _menuItem(IconData icon, String title, String sub, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: VC.textSec),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: VC.text)),
            Text(sub, style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: VC.textTer, size: 20),
        ]),
      ),
    );
  }

  Widget _menuDivider() => Divider(height: 1, color: VC.border, indent: 68);

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const VendorLoginScreen()), (_) => false),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text('Sign Out', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          foregroundColor: VC.error,
          side: const BorderSide(color: VC.error),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
