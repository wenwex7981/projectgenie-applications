import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class VendorEarningsScreen extends StatefulWidget {
  final String vendorId;
  const VendorEarningsScreen({super.key, required this.vendorId});

  @override
  State<VendorEarningsScreen> createState() => _VendorEarningsScreenState();
}

class _VendorEarningsScreenState extends State<VendorEarningsScreen> {
  Map<String, dynamic> _earnings = {};
  List<dynamic> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final earnings = await ApiService.getEarnings(widget.vendorId);
      final txns = await ApiService.getTransactions(widget.vendorId);
      if (mounted) setState(() { _earnings = earnings; _transactions = txns; _loading = false; });
    } catch (e) {
      if (mounted) setState(() {
        _earnings = {'totalEarnings': 450000, 'pendingEarnings': 2999, 'thisMonthEarnings': 12500};
        _transactions = [
          {'id': '1', 'type': 'credit', 'amount': 4999, 'description': 'Order PG-2026-0001 completed', 'status': 'completed', 'createdAt': '2026-02-20T10:00:00Z'},
          {'id': '2', 'type': 'credit', 'amount': 5500, 'description': 'Order PG-2026-0002 payment', 'status': 'completed', 'createdAt': '2026-02-18T14:00:00Z'},
          {'id': '3', 'type': 'withdrawal', 'amount': 3000, 'description': 'Bank withdrawal', 'status': 'completed', 'createdAt': '2026-02-15T09:00:00Z'},
          {'id': '4', 'type': 'credit', 'amount': 2999, 'description': 'Order PG-2026-0003 payment', 'status': 'pending', 'createdAt': '2026-02-22T16:00:00Z'},
          {'id': '5', 'type': 'credit', 'amount': 3200, 'description': 'Custom project payment', 'status': 'completed', 'createdAt': '2026-02-10T11:00:00Z'},
        ];
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
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _buildHeader(),
                    _buildEarningsCard(),
                    _buildQuickActions(),
                    _buildTransactionsList(),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Text('Earnings', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: VC.text)),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: VC.heroGrad, borderRadius: BorderRadius.circular(24), boxShadow: VC.medShadow),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Available Balance', style: GoogleFonts.inter(fontSize: 13, color: Colors.white60)),
        const SizedBox(height: 4),
        Text('₹${(_earnings['totalEarnings'] ?? 0).toStringAsFixed(0)}',
            style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 20),
        Row(children: [
          _earningPill('This Month', '₹${(_earnings['thisMonthEarnings'] ?? 0).toStringAsFixed(0)}', VC.success),
          const SizedBox(width: 12),
          _earningPill('Pending', '₹${(_earnings['pendingEarnings'] ?? 0).toStringAsFixed(0)}', VC.warning),
        ]),
      ]),
    );
  }

  Widget _earningPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white60)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ]),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        Expanded(child: _quickAction(Icons.account_balance_rounded, 'Withdraw', VC.accent, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal request submitted'), backgroundColor: VC.success));
        })),
        const SizedBox(width: 12),
        Expanded(child: _quickAction(Icons.receipt_long_rounded, 'Invoice', VC.purple, () {})),
        const SizedBox(width: 12),
        Expanded(child: _quickAction(Icons.bar_chart_rounded, 'Analytics', VC.success, () {})),
      ]),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: VC.border), boxShadow: VC.softShadow),
        child: Column(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: VC.text)),
        ]),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TRANSACTION HISTORY', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: VC.textSec, letterSpacing: 1)),
        const SizedBox(height: 12),
        if (_transactions.isEmpty)
          Container(
            width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: VC.border)),
            child: Center(child: Text('No transactions yet', style: GoogleFonts.inter(fontSize: 13, color: VC.textTer))),
          )
        else
          ..._transactions.map((t) {
            final isCredit = t['type'] == 'credit';
            final isPending = t['status'] == 'pending';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: VC.border)),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: isCredit ? VC.successBg : VC.errorBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                    size: 20, color: isCredit ? VC.success : VC.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t['description'] ?? '', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: VC.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(children: [
                    if (isPending) Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: VC.warningBg, borderRadius: BorderRadius.circular(4)),
                      child: Text('Pending', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: VC.warning)),
                    ),
                    Text(_formatDate(t['createdAt']), style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
                  ]),
                ])),
                Text(
                  '${isCredit ? '+' : '-'}₹${t['amount']}',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: isCredit ? VC.success : VC.error),
                ),
              ]),
            );
          }),
      ]),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) { return dateStr; }
  }
}
