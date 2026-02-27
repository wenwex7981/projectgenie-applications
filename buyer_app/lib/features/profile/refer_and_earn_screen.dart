import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter/services.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Refer & Earn',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            _buildHeroSection(),
            _buildProgressTracker(),
            _buildReferralCodeCard(context),
            _buildSocialShareBar(),
            _buildReferralHistory(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gift Magic, Get Rewards', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(20)),
              child: const Text('LIMITED TIME OFFER', style: TextStyle(color: AppTheme.primaryColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 16),
            Text(
              'Earn \$10 for every friend who joins Project Genie and starts their first magic project.',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2)))),
              child: Row(
                children: [
                   _buildHeroStat('\$120', 'TOTAL EARNED'),
                   _buildHeroStatDivider(),
                   _buildHeroStat('12', 'INVITED'),
                   _buildHeroStatDivider(),
                   _buildHeroStat('\$20', 'PENDING'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildHeroStatDivider() {
    return Container(height: 32, width: 1, color: Colors.white.withOpacity(0.2));
  }

  Widget _buildProgressTracker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                  child: const Text('SILVER TIER', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Refer 3 friends to unlock ', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      TextSpan(text: 'Gold status', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                const Text('2/3 Friends', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.66,
                minHeight: 10,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Just 1 more to reach Gold and double your rewards!', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCodeCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), style: BorderStyle.none), // Border is handled via background decoration
        ),
        child: Column(
          children: [
            const Text('Your Unique Invite Code', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('GENIE-99X', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryColor, letterSpacing: 4)),
                  IconButton(
                    icon: const Icon(Icons.content_copy, color: AppTheme.primaryColor),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'GENIE-99X'));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code copied to clipboard!')));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tap to copy or use the share buttons below', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialShareBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
           _buildShareButton(Icons.chat_bubble_outline, 'WhatsApp', const Color(0xFF25D366)),
           const SizedBox(width: 8),
           _buildShareButton(Icons.send_outlined, 'Telegram', const Color(0xFF0088CC)),
           const SizedBox(width: 8),
           _buildShareButton(Icons.mail_outline, 'Email', AppTheme.primaryColor),
           const SizedBox(width: 8),
           _buildShareButton(Icons.more_horiz, 'More', const Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildShareButton(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralHistory() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Referral History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppTheme.primaryColor))),
            ],
          ),
          const SizedBox(height: 8),
          _buildHistoryItem('John Doe', 'Joined Oct 24, 2026', '+\$10.00', 'COMPLETED', Colors.green),
          const SizedBox(height: 12),
          _buildHistoryItem('Sarah Klein', 'Invited Oct 26, 2026', '\$10.00', 'PENDING', Colors.amber),
          const SizedBox(height: 12),
          _buildHistoryItem('Mike Peters', 'Invited Oct 28, 2026', '-', 'INVITED', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String name, String sub, String reward, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(child: Text(name[0], style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(reward, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: reward.startsWith('+') ? Colors.green : const Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(status, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
