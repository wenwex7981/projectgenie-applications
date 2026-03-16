import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class AddHackathonScreen extends StatefulWidget {
  final String vendorId;
  const AddHackathonScreen({super.key, required this.vendorId});

  @override
  State<AddHackathonScreen> createState() => _AddHackathonScreenState();
}

class _AddHackathonScreenState extends State<AddHackathonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _orgCtrl = TextEditingController();
  final _prizeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _teamCtrl = TextEditingController();
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    
    try {
      await ApiService.createHackathon({
        'title': _titleCtrl.text,
        'organizer': _orgCtrl.text,
        'prizePool': '₹${_prizeCtrl.text}',
        'description': _descCtrl.text,
        'date': _dateCtrl.text,
        'teamSize': _teamCtrl.text,
        'vendorId': widget.vendorId,
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
        title: Text('Add Hackathon', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: VC.text)),
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
              _buildField('Hackathon Title', _titleCtrl, Icons.emoji_events_rounded, maxLines: 2),
              const SizedBox(height: 16),
              _buildField('Organizer Name', _orgCtrl, Icons.business_rounded),
              const SizedBox(height: 16),
              _buildField('Prize Pool (in ₹)', _prizeCtrl, Icons.card_giftcard_rounded, isNumeric: true),
              const SizedBox(height: 16),
              _buildField('Date / Duration (e.g., 20 Nov - 22 Nov 2026)', _dateCtrl, Icons.calendar_today_rounded),
              const SizedBox(height: 16),
              _buildField('Team Size (e.g., 1-4 Members)', _teamCtrl, Icons.groups_rounded),
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
                  : Text('Publish Hackathon', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
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
