import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class AddProjectScreen extends StatefulWidget {
  final String vendorId;
  const AddProjectScreen({super.key, required this.vendorId});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _domainCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    
    try {
      await ApiService.createProject({
        'title': _titleCtrl.text,
        'domain': _domainCtrl.text,
        'price': '₹${_priceCtrl.text}',
        'description': _descCtrl.text,
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        title: Text('Add Project', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: VC.text)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: VC.text),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField('Project Title', _titleCtrl, Icons.title_rounded, maxLines: 2),
              const SizedBox(height: 16),
              _buildField('Domain (e.g., AI/ML, Web)', _domainCtrl, Icons.category_rounded),
              const SizedBox(height: 16),
              _buildField('Price (in ₹)', _priceCtrl, Icons.currency_rupee_rounded, isNumeric: true),
              const SizedBox(height: 16),
              _buildField('Description', _descCtrl, Icons.description_rounded, maxLines: 5),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: VC.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _loading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Publish Project', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.textSec)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          validator: (v) => v!.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, color: VC.textTer) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.accent, width: 2)),
          ),
        ),
      ],
    );
  }
}
