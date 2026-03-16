import 'package:flutter/material.dart';
import 'package:buyer_app/core/models/models.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  final ServiceModel service;
  const CheckoutScreen({super.key, required this.service});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'Wallet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Checkout',
          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
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
                  _buildSectionHeader('PAYMENT METHOD'),
                  const SizedBox(height: 12),
                  _buildPaymentOption('Wallet', 'Pay using Project Genie Credits', Icons.account_balance_wallet_outlined, true),
                  _buildPaymentOption('UPI', 'Google Pay, PhonePe, Paytm', Icons.payments_outlined, true),
                  _buildPaymentOption('Card', 'Credit or Debit Card', Icons.credit_card_outlined, false),
                  const SizedBox(height: 32),
                  _buildSectionHeader('ORDER DETAILS'),
                  const SizedBox(height: 12),
                  _buildOrderInfo(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('BILLING DETAILS'),
                  const SizedBox(height: 12),
                  _buildBillingSummary(),
                ],
              ),
            ),
          ),
          _buildPaymentFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textTertiary, letterSpacing: 1.2),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon, bool isAvailable) {
    final bool isSelected = _selectedPayment == title;
    return GestureDetector(
      onTap: () {
        if (isAvailable) setState(() => _selectedPayment = title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary)),
                  Text(subtitle, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
            if (!isAvailable) Text('Unavailable', style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network((widget.service.imageUrl != null && widget.service.imageUrl!.isNotEmpty) ? widget.service.imageUrl! : "https://via.placeholder.com/60", width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.service.title, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
                Text('Vendor: ${widget.service.vendorName}', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text('₹${widget.service.price}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildBillingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _buildBillRow('Item Total', '₹${widget.service.price}'),
          const SizedBox(height: 12),
          _buildBillRow('Service Fee', '₹0.00'),
          const SizedBox(height: 12),
          _buildBillRow('GST (0%)', '₹0.00'),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grand Total', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text('₹${widget.service.price}', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(value, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildPaymentFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.5))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text('Secure SSL Encryption', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('Total:', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(width: 4),
              Text('₹${widget.service.price}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text('Pay Securely', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text('Payment Successful', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Your order has been placed successfully.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Pop Checkout
                Navigator.pop(context); // Pop Cart
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Back to Home', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
