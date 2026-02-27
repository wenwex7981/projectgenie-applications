import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/data/mock_data.dart';
import 'package:buyer_app/core/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transaction_details_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {
  String _balance = '0';
  bool _loading = true;
  String _selectedFilter = 'Today';
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _loadWallet();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadWallet() async {
    setState(() => _loading = true);
    try {
      final wallet = await ApiService.getWallet();
      if (mounted) {
        setState(() {
          _balance = (wallet?['balance'] ?? wallet?['walletBalance'] ?? 0).toString();
          _loading = false;
        });
        _animCtrl.forward(from: 0);
      }
    } catch (e) {
      if (mounted) setState(() { _balance = '1,24,500'; _loading = false; });
      _animCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadWallet,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceCard(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 32),
                      _buildTransactionsHeader(),
                      const SizedBox(height: 16),
                      _buildDateFilters(),
                      const SizedBox(height: 16),
                      _buildTransactionList(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      title: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wallet', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w900)),
              Text('Project Genie', style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.history_rounded, size: 20, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.mediumShadow,
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(top: -60, right: -60, child: Container(width: 200, height: 200, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle))),
          Positioned(bottom: -40, left: -20, child: Container(width: 140, height: 140, decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle))),
          // Crosshatch pattern
          Positioned(top: 20, right: 30, child: Icon(Icons.grid_4x4_rounded, size: 60, color: Colors.white.withOpacity(0.04))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Balance', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        _loading
                            ? Container(width: 180, height: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)))
                            : Text('₹$_balance', style: GoogleFonts.inter(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ACCOUNT ID', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.5), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('**** ${(ApiService.userId ?? '5678').substring((ApiService.userId ?? '5678').length > 4 ? (ApiService.userId ?? '5678').length - 4 : 0)}',
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()])),
                      ],
                    ),
                    // Card brand indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                      child: Text('PRO', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(Icons.add_circle_outline_rounded, 'Top Up', true, () => _showTopUp()),
        _buildActionItem(Icons.send_rounded, 'Transfer', false, () {}),
        _buildActionItem(Icons.payments_outlined, 'Withdraw', false, () {}),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              gradient: isPrimary ? AppColors.heroGradient : null,
              color: isPrimary ? null : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: !isPrimary ? Border.all(color: AppColors.border) : null,
              boxShadow: isPrimary ? AppColors.mediumShadow : AppColors.softShadow,
            ),
            child: Icon(icon, color: isPrimary ? Colors.white : AppColors.textSecondary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13, color: isPrimary ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Recent Transactions', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        TextButton(
          onPressed: () {},
          child: Row(children: [
            Text('See All', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
          ]),
        ),
      ],
    );
  }

  Widget _buildDateFilters() {
    final filters = ['Today', 'This Week', 'This Month', 'Custom'];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = filters[index] == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filters[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.heroGradient : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: AppColors.border),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 6)] : null,
              ),
              child: Center(child: Text(
                filters[index],
                style: GoogleFonts.inter(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700),
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    final transactions = MockData.transactions;
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.receipt_long_rounded, size: 28, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 14),
            Text('No transactions yet', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text('Your payment history will appear here', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
          ]),
        ),
      );
    }

    return Column(children: transactions.map((tx) => _buildTransactionItem(context, tx)).toList());
  }

  Widget _buildTransactionItem(BuildContext context, Map<String, dynamic> tx) {
    final bool isCredit = tx['isCredit'] ?? false;
    final Color statusColor = tx['statusColor'] as Color;

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionDetailsScreen(transaction: tx))),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                gradient: isCredit ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]) : null,
                color: isCredit ? null : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(tx['icon'] as IconData, color: isCredit ? Colors.white : AppColors.textSecondary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx['title'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text(tx['date'] as String, style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(tx['type'] as String, style: GoogleFonts.inter(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900)),
                    ),
                  ]),
                ],
              ),
            ),
            Text(
              tx['amount'] as String,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w900, fontSize: 16,
                color: isCredit ? const Color(0xFF10B981) : AppColors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopUp() {
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Top Up Wallet', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text('Add funds to your ProjectGenie wallet', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
              const SizedBox(height: 24),
              // Quick amount chips
              Row(
                children: [500, 1000, 2000, 5000].map((amount) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => amountCtrl.text = amount.toString(),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Center(child: Text('₹$amount', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  prefixText: '₹ ',
                  labelStyle: GoogleFonts.inter(color: AppColors.textTertiary),
                  prefixStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                ),
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(amountCtrl.text);
                    if (amount != null && amount > 0) {
                      Navigator.pop(ctx);
                      await ApiService.topupWallet(amount);
                      _loadWallet();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('₹${amountCtrl.text} added to wallet!', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Add Money', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
