import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isCredit = transaction['isCredit'] ?? false;
    final Color statusColor = transaction['statusColor'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Transaction Detail',
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF64748B)), onPressed: () {}),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(isCredit, statusColor),
            _buildTransactionInfo(),
            _buildPaymentMethod(),
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(bool isCredit, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Icon(
              transaction['icon'] as IconData,
              color: isCredit ? const Color(0xFF10B981) : AppTheme.primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            transaction['title'] as String,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          Text(
            transaction['date'] as String,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          Text(
            transaction['amount'] as String,
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: isCredit ? const Color(0xFF10B981) : const Color(0xFF0F172A),
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: statusColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  (transaction['type'] as String).toUpperCase(),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return _buildSectionCard([
      _buildInfoRow('Reference ID', 'TRX-1029485736'),
      _buildInfoRow('Transaction Date', 'Oct 24, 2023, 02:45 PM'),
      _buildInfoRow('Category', transaction['title'] as String),
      _buildInfoRow('Type', transaction['isCredit'] == true ? 'Credit' : 'Debit'),
    ]);
  }

  Widget _buildPaymentMethod() {
    return _buildSectionCard([
      const Text('PAYMENT METHOD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
      const SizedBox(height: 16),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.credit_card, color: Color(0xFF64748B), size: 18),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wallet Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                Text('Project Genie Internal Wallet', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
        ],
      ),
    ]);
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_outlined),
            label: const Text('Download Receipt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: AppTheme.primaryColor.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text('Report an issue with this transaction', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
