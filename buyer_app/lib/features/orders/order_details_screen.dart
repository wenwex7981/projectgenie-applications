import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/app_theme.dart';
import 'order_tracking_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Invoice Detail',
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Color(0xFF64748B)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)), onPressed: () {}),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            _buildHeroSummary(),
            _buildDetailsCard(context),
            _buildActionButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.receipt_long, color: AppTheme.primaryColor, size: 32),
                ),
                const SizedBox(height: 16),
                const Text('Project Genie', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text('Invoice #${order.id.toUpperCase()}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                SizedBox(width: 8),
                Text('PAID', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('TOTAL AMOUNT', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(
            '₹${order.price}',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.primaryColor, letterSpacing: -1),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // Metadata Grid
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              children: [
                _buildMetadataItem('ISSUED DATE', 'Oct 24, 2023'),
                _buildMetadataItem('DUE DATE', 'Nov 07, 2023'),
                _buildMetadataItem('PAYMENT METHOD', 'Visa •••• 1234', icon: Icons.credit_card),
                _buildMetadataItem('CLIENT', 'Alex Johnson', isPrimary: true),
              ],
            ),
          ),
          const Divider(height: 1),
          // Itemized Breakdown
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ITEMIZED BREAKDOWN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
                const SizedBox(height: 20),
                _buildLineItem(order.serviceName, 'Deep technical expertise and delivery', '₹${order.price}'),
                const SizedBox(height: 16),
                _buildLineItem('Platform Fee', 'Project Genie service charge', '₹0.00'),
                const SizedBox(height: 24),
                // Dashed Divider
                Row(
                  children: List.generate(
                    30,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 1,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildFinancialRow('Subtotal', '₹${order.price}'),
                const SizedBox(height: 12),
                _buildFinancialRow('Tax', '₹0.00', tag: '0% GST'),
                const SizedBox(height: 16),
                _buildFinancialRow('Grand Total', '₹${order.price}', isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(String label, String value, {IconData? icon, bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: const Color(0xFF64748B)),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold, 
                  color: isPrimary ? AppTheme.primaryColor : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineItem(String title, String subtitle, String price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildFinancialRow(String label, String value, {String? tag, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, color: isTotal ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
            if (tag != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(tag, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 8)),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14, 
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold, 
            color: isTotal ? AppTheme.primaryColor : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('Download PDF Invoice'),
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
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderTrackingScreen(order: order)));
            },
            icon: const Icon(Icons.track_changes),
            label: const Text('Track Order Status'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 56),
              side: const BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'A copy of this invoice was sent to alex Johnson@university.edu',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
