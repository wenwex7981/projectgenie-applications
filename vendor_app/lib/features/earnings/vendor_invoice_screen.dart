import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class VendorInvoiceScreen extends StatefulWidget {
  final String vendorId;
  const VendorInvoiceScreen({super.key, required this.vendorId});

  @override
  State<VendorInvoiceScreen> createState() => _VendorInvoiceScreenState();
}

class _VendorInvoiceScreenState extends State<VendorInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameCtrl = TextEditingController();
  final _clientEmailCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _status = 'Unpaid';
  bool _loading = false;
  
  List<dynamic> _recentInvoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  void _loadInvoices() {
    // Mocking recent invoices load since no exact endpoint exists for generated invoices
    setState(() {
      _recentInvoices = [
        {'id': 'INV-001', 'client': 'ABC University', 'amount': 15000, 'date': '2026-03-01', 'status': 'Paid'},
        {'id': 'INV-002', 'client': 'Rahul Tech', 'amount': 8500, 'date': '2026-03-10', 'status': 'Unpaid'},
      ];
    });
  }

  void _generateInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // Simulate API Call to create an invoice
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice generated and sent successfully!'), backgroundColor: VC.success),
      );
      _clientNameCtrl.clear();
      _clientEmailCtrl.clear();
      _amountCtrl.clear();
      _descCtrl.clear();
      
      setState(() {
        _recentInvoices.insert(0, {
          'id': 'INV-00${_recentInvoices.length + 1}',
          'client': _clientNameCtrl.text.isEmpty ? 'New Client' : _clientNameCtrl.text,
          'amount': double.tryParse(_amountCtrl.text) ?? 0,
          'date': DateTime.now().toString().split(' ')[0],
          'status': _status,
        });
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        title: Text('Invoices', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: VC.text)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: VC.text),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generate New Invoice', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: VC.text)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VC.border),
                boxShadow: VC.softShadow,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField('Client Name', _clientNameCtrl, Icons.person_rounded),
                    const SizedBox(height: 12),
                    _buildField('Client Email', _clientEmailCtrl, Icons.email_rounded, isEmail: true),
                    const SizedBox(height: 12),
                    _buildField('Amount (₹)', _amountCtrl, Icons.currency_rupee_rounded, isNumeric: true),
                    const SizedBox(height: 12),
                    _buildField('Description', _descCtrl, Icons.description_rounded, maxLines: 2),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Status:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.textSec)),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _status,
                          items: ['Unpaid', 'Paid'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (v) => setState(() => _status = v!),
                          style: GoogleFonts.inter(fontSize: 14, color: VC.text),
                          underline: const SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _generateInvoice,
                        icon: _loading ? const SizedBox() : const Icon(Icons.send_rounded, size: 18),
                        label: _loading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('Generate & Send Invoice', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VC.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Recent Invoices', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: VC.text)),
            const SizedBox(height: 16),
            if (_recentInvoices.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('No invoices generated yet.', style: GoogleFonts.inter(color: VC.textTer)),
                ),
              )
            else
              ..._recentInvoices.map((inv) => _buildInvoiceCard(inv)),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1, bool isNumeric = false, bool isEmail = false}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      validator: (v) => v!.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: VC.textSec),
        prefixIcon: maxLines == 1 ? Icon(icon, color: VC.textTer, size: 20) : null,
        filled: true,
        fillColor: VC.bg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.accent, width: 2)),
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> inv) {
    final isPaid = inv['status'] == 'Paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VC.border),
        boxShadow: VC.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isPaid ? VC.successBg : VC.warningBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.receipt_long_rounded, color: isPaid ? VC.success : VC.warning, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inv['id'], style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: VC.textTer)),
                const SizedBox(height: 2),
                Text(inv['client'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: VC.text)),
                const SizedBox(height: 4),
                Text(inv['date'], style: GoogleFonts.inter(fontSize: 11, color: VC.textSec)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${inv['amount']}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: VC.text)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? VC.successBg : VC.warningBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(inv['status'], style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: isPaid ? VC.success : VC.warning)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
