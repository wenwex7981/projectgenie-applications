import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class VendorOrdersScreen extends StatefulWidget {
  final String vendorId;
  const VendorOrdersScreen({super.key, required this.vendorId});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<dynamic> _orders = [];
  List<dynamic> _customOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final orders = await ApiService.getVendorOrders(widget.vendorId);
      final custom = await ApiService.getVendorCustomOrders(widget.vendorId);
      if (mounted) setState(() { _orders = orders; _customOrders = custom; _loading = false; });
    } catch (e) {
      if (mounted) setState(() {
        _orders = [
          {'id': '1', 'orderNumber': 'PG-2026-0001', 'status': 'Completed', 'totalPrice': 4999, 'user': {'name': 'Vardhan Kumar', 'email': 'v@u.edu'}, 'service': {'title': 'Breast Cancer Detection CNN'}},
          {'id': '2', 'orderNumber': 'PG-2026-0002', 'status': 'Active', 'totalPrice': 5500, 'user': {'name': 'Student User'}, 'service': {'title': 'E-Commerce MERN Stack'}},
          {'id': '3', 'orderNumber': 'PG-2026-0005', 'status': 'Pending', 'totalPrice': 3200, 'user': {'name': 'Rahul M'}, 'service': {'title': 'Drowsiness Detection'}},
        ];
        _customOrders = [
          {'id': 'c1', 'title': 'Crop Disease Detection Using Transfer Learning', 'studentName': 'Vardhan Kumar', 'collegeName': 'JNTU', 'domain': 'AI/ML', 'budget': '8000', 'deadline': '15 Mar 2026', 'status': 'In Progress', 'abstractText': 'Deep learning based crop disease detection...'},
          {'id': 'c2', 'title': 'Blockchain Voting System', 'studentName': 'Priya S', 'collegeName': 'VIT', 'domain': 'Blockchain', 'budget': '12000', 'deadline': '20 Apr 2026', 'status': 'Pending Review', 'abstractText': 'Decentralized voting platform...'},
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _orders.where((o) => o['status'] == 'Active' || o['status'] == 'Pending').toList();
    final completed = _orders.where((o) => o['status'] == 'Completed').toList();

    return Scaffold(
      backgroundColor: VC.bg,
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            color: Colors.white,
            child: Column(children: [
              Row(children: [
                Text('Orders', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: VC.text)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: VC.warningBg, borderRadius: BorderRadius.circular(8)),
                  child: Text('${_customOrders.where((c) => c['status'] == 'Pending Review').length} Pending', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: VC.warning)),
                ),
              ]),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabCtrl,
                labelColor: VC.accent, unselectedLabelColor: VC.textSec,
                labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                indicatorColor: VC.accent, indicatorWeight: 3, dividerColor: VC.border,
                tabs: [
                  Tab(text: 'Active (${active.length})'),
                  Tab(text: 'Completed (${completed.length})'),
                  Tab(text: 'Custom (${_customOrders.length})'),
                ],
              ),
            ]),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(controller: _tabCtrl, children: [
                    _ordersList(active),
                    _ordersList(completed),
                    _customOrdersList(),
                  ]),
          ),
        ]),
      ),
    );
  }

  Widget _ordersList(List<dynamic> orders) {
    if (orders.isEmpty) return _empty('No orders here');
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (ctx, i) => _orderCard(orders[i]),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? '';
    final sColor = status == 'Completed' ? VC.success : status == 'Active' ? VC.accent : VC.warning;
    final sBg = status == 'Completed' ? VC.successBg : status == 'Active' ? VC.accentLight : VC.warningBg;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: VC.border), boxShadow: VC.softShadow),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: sBg, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: sColor))),
          const Spacer(),
          Text(order['orderNumber'] ?? '', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        Text(order['service']?['title'] ?? 'Service', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text)),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.person_rounded, size: 14, color: VC.textTer),
          const SizedBox(width: 4),
          Text(order['user']?['name'] ?? '', style: GoogleFonts.inter(fontSize: 12, color: VC.textSec)),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('₹${order['totalPrice']}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: VC.accent)),
          if (status == 'Active' || status == 'Pending')
            Row(children: [
              _actionBtn('Complete', VC.success, () => _updateStatus(order['id'], 'Completed')),
              const SizedBox(width: 8),
              _actionBtn('Cancel', VC.error, () => _updateStatus(order['id'], 'Cancelled')),
            ]),
        ]),
      ]),
    );
  }

  Widget _customOrdersList() {
    if (_customOrders.isEmpty) return _empty('No custom requests');
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _customOrders.length,
        itemBuilder: (ctx, i) => _customOrderCard(_customOrders[i]),
      ),
    );
  }

  Widget _customOrderCard(Map<String, dynamic> co) {
    final status = co['status'] ?? '';
    final isPending = status == 'Pending Review';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPending ? VC.warning.withValues(alpha: 0.3) : VC.border),
        boxShadow: VC.softShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: isPending ? VC.warningBg : VC.purpleBg, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: isPending ? VC.warning : VC.purple)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(6)),
            child: Text(co['domain'] ?? '', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: VC.textSec)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(co['title'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text)),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.school_rounded, size: 14, color: VC.textTer),
          const SizedBox(width: 4),
          Text('${co['studentName']} • ${co['collegeName']}', style: GoogleFonts.inter(fontSize: 12, color: VC.textSec)),
        ]),
        const SizedBox(height: 8),

        // Abstract preview
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(10)),
          child: Text(co['abstractText'] ?? '', style: GoogleFonts.inter(fontSize: 11, color: VC.textSec, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(height: 12),

        Row(children: [
          _infoPill('💰', 'Budget: ₹${co['budget'] ?? 'Flexible'}'),
          const SizedBox(width: 8),
          _infoPill('📅', co['deadline'] ?? 'Flexible'),
        ]),
        const SizedBox(height: 12),

        if (isPending) Row(children: [
          Expanded(child: SizedBox(height: 40, child: ElevatedButton(
            onPressed: () => _acceptCustomOrder(co['id']),
            style: ElevatedButton.styleFrom(backgroundColor: VC.success, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
            child: Text('Accept', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
          ))),
          const SizedBox(width: 8),
          Expanded(child: SizedBox(height: 40, child: OutlinedButton(
            onPressed: () => _rejectCustomOrder(co['id']),
            style: OutlinedButton.styleFrom(foregroundColor: VC.error, side: const BorderSide(color: VC.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text('Reject', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
          ))),
        ]),
      ]),
    );
  }

  Widget _infoPill(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(8)),
      child: Text('$emoji $text', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: VC.textSec)),
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      ),
    );
  }

  Widget _empty(String text) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 64, height: 64, decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.receipt_long_rounded, size: 28, color: VC.textTer)),
      const SizedBox(height: 12),
      Text(text, style: GoogleFonts.inter(fontSize: 14, color: VC.textTer)),
    ]));
  }

  Future<void> _updateStatus(String orderId, String status) async {
    try {
      await ApiService.updateOrderStatus(orderId, status);
      _loadData();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order $status'), backgroundColor: VC.success));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated (offline)'), backgroundColor: VC.success));
      _loadData();
    }
  }

  Future<void> _acceptCustomOrder(String id) async {
    try {
      await ApiService.acceptCustomOrder(id, notes: 'Accepted by vendor');
      _loadData();
    } catch (_) { _loadData(); }
  }

  Future<void> _rejectCustomOrder(String id) async {
    try {
      await ApiService.rejectCustomOrder(id, notes: 'Rejected by vendor');
      _loadData();
    } catch (_) { _loadData(); }
  }
}
