import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _savedCards = [
    {
      'type': 'visa',
      'last4': '4242',
      'expiry': '12/26',
      'holder': 'Student User',
      'isDefault': true,
    },
  ];

  final List<Map<String, dynamic>> _savedUpi = [
    {
      'id': 'student@upi',
      'provider': 'Google Pay',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Payment Methods',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved Cards Section
            _buildSectionTitle('SAVED CARDS'),
            const SizedBox(height: 12),
            ..._savedCards.map((card) => _buildCardItem(card)),
            const SizedBox(height: 12),
            _buildAddButton('Add New Card', Icons.credit_card_rounded, () {
              _showAddCardSheet(context);
            }),
            const SizedBox(height: 28),
            // UPI Section
            _buildSectionTitle('UPI'),
            const SizedBox(height: 12),
            ..._savedUpi.map((upi) => _buildUpiItem(upi)),
            const SizedBox(height: 12),
            _buildAddButton('Add UPI ID', Icons.account_balance_rounded, () {
              _showAddUpiSheet(context);
            }),
            const SizedBox(height: 28),
            // Net Banking Section
            _buildSectionTitle('NET BANKING'),
            const SizedBox(height: 12),
            _buildAddButton('Link Bank Account', Icons.account_balance_outlined,
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Net Banking coming soon! 🏦',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }),
            const SizedBox(height: 32),
            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shield_rounded,
                        color: Color(0xFF3B82F6), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Secure Payments',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(
                            'All payment data is encrypted and securely stored.',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.textTertiary,
            letterSpacing: 1));
  }

  Widget _buildCardItem(Map<String, dynamic> card) {
    final isVisa = card['type'] == 'visa';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: card['isDefault'] == true
            ? const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: card['isDefault'] != true ? Colors.white : null,
        borderRadius: BorderRadius.circular(16),
        border: card['isDefault'] != true
            ? Border.all(color: AppColors.border)
            : null,
        boxShadow: card['isDefault'] == true
            ? [
                BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6))
              ]
            : AppColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 34,
            decoration: BoxDecoration(
              color: card['isDefault'] == true
                  ? Colors.white.withOpacity(0.15)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                child: Text(
              isVisa ? 'VISA' : 'MC',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: card['isDefault'] == true
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
            )),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•••• •••• •••• ${card['last4']}',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: card['isDefault'] == true
                        ? Colors.white
                        : AppColors.textPrimary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Expires ${card['expiry']}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: card['isDefault'] == true
                        ? Colors.white60
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (card['isDefault'] == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Default',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70)),
            )
          else
            IconButton(
              onPressed: () {
                setState(() {
                  for (var c in _savedCards) {
                    c['isDefault'] = false;
                  }
                  card['isDefault'] = true;
                });
              },
              icon: const Icon(Icons.more_vert_rounded,
                  size: 20, color: AppColors.textTertiary),
            ),
        ],
      ),
    );
  }

  Widget _buildUpiItem(Map<String, dynamic> upi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_rounded,
                color: Color(0xFF22C55E), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(upi['id'],
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(upi['provider'],
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textTertiary)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => _savedUpi.remove(upi));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('UPI ID removed',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  backgroundColor: Colors.grey[700],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            icon: const Icon(Icons.delete_outline_rounded,
                size: 20, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }

  void _showAddCardSheet(BuildContext context) {
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Add New Card',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text('Enter your card details below',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textTertiary)),
              const SizedBox(height: 24),
              _buildTextField(numberCtrl, 'Card Number', '1234 5678 9012 3456',
                  TextInputType.number),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(
                          expiryCtrl, 'Expiry', 'MM/YY', TextInputType.datetime)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: _buildTextField(
                          cvvCtrl, 'CVV', '123', TextInputType.number)),
                ],
              ),
              const SizedBox(height: 14),
              _buildTextField(
                  nameCtrl, 'Cardholder Name', 'John Doe', TextInputType.text),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (numberCtrl.text.length >= 4) {
                      setState(() {
                        _savedCards.add({
                          'type': 'visa',
                          'last4': numberCtrl.text
                              .substring(numberCtrl.text.length - 4),
                          'expiry': expiryCtrl.text.isNotEmpty
                              ? expiryCtrl.text
                              : '01/28',
                          'holder':
                              nameCtrl.text.isNotEmpty ? nameCtrl.text : 'User',
                          'isDefault': false,
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Card added successfully! 🎉',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700)),
                          backgroundColor: const Color(0xFF22C55E),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Add Card',
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddUpiSheet(BuildContext context) {
    final upiCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Add UPI ID',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text('Enter your UPI ID',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textTertiary)),
              const SizedBox(height: 24),
              _buildTextField(
                  upiCtrl, 'UPI ID', 'yourname@upi', TextInputType.text),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (upiCtrl.text.contains('@')) {
                      setState(() {
                        _savedUpi.add({
                          'id': upiCtrl.text,
                          'provider': 'UPI',
                          'isDefault': false,
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('UPI ID added! 🎉',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700)),
                          backgroundColor: const Color(0xFF22C55E),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Verify & Add',
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.inter(color: AppColors.textTertiary),
        hintStyle: GoogleFonts.inter(color: AppColors.textTertiary.withOpacity(0.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
