import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class AddHackathonScreen extends StatefulWidget {
  final Map<String, dynamic>? existingItem;
  final String? vendorId;
  const AddHackathonScreen({super.key, this.existingItem, this.vendorId});

  @override
  State<AddHackathonScreen> createState() => _AddHackathonScreenState();
}

class _AddHackathonScreenState extends State<AddHackathonScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _organizerCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _teamSizeCtrl = TextEditingController();
  final _prizePoolCtrl = TextEditingController();
  final _registrationFeeCtrl = TextEditingController();

  PlatformFile? _thumbnailImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _titleCtrl.text = item['title'] ?? '';
      _descCtrl.text = item['description'] ?? '';
      _organizerCtrl.text = item['organizer'] ?? '';
      _dateCtrl.text = item['date'] ?? '';
      _teamSizeCtrl.text = item['teamSize'] ?? '';
      _prizePoolCtrl.text = item['prizePool'] ?? '';
      _registrationFeeCtrl.text = item['registrationFee'] ?? '';
    }
  }

  Future<String?> _uploadToSupabase(String bucket, String folder, PlatformFile file) async {
    try {
      if (file.bytes == null) return null;
      final ext = file.name.split('.').last.toLowerCase();
      final path = '$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name.replaceAll(' ', '_')}';

      await Supabase.instance.client.storage
          .from(bucket)
          .uploadBinary(path, file.bytes!, fileOptions: const FileOptions(contentType: 'image/jpeg'));

      return Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null) setState(() => _thumbnailImage = result.files.first);
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty || _dateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields (Title, Desc, Date)')));
      return;
    }

    setState(() => _loading = true);

    String? imageUrl = widget.existingItem?['imageUrl'];

    if (_thumbnailImage != null) {
      imageUrl = await _uploadToSupabase('vendor_assets', 'hackathons', _thumbnailImage!) ?? imageUrl;
    }

    final data = {
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'organizer': _organizerCtrl.text.trim(),
      'date': _dateCtrl.text.trim(),
      'teamSize': _teamSizeCtrl.text.trim(),
      'prizePool': _prizePoolCtrl.text.trim(),
      'registrationFee': _registrationFeeCtrl.text.trim(),
      'imageUrl': imageUrl,
      'isFeatured': false,
      'isActive': true,
    };

    try {
      if (widget.existingItem != null) {
        await ApiService.updateHackathon(widget.existingItem!['id'], data);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hackathon Updated!')));
      } else {
        await ApiService.createHackathon(data);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hackathon Created!')));
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        title: Text(widget.existingItem != null ? 'Edit Hackathon' : 'List Hackathon'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: _loading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('Publish', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: VC.accent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Hackathon Title *'),
          _textField(_titleCtrl, 'e.g. AI Innovation Summit 2026'),
          const SizedBox(height: 16),

          _label('Description *'),
          _textField(_descCtrl, 'Detailed description...', maxLines: 5),
          const SizedBox(height: 16),

          _label('Organizer Name'),
          _textField(_organizerCtrl, 'e.g. ProjectGenie Dev Team'),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Date & Time *'),
              _textField(_dateCtrl, 'e.g. Oct 24, 2026 10 AM'),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Team Size'),
              _textField(_teamSizeCtrl, 'e.g. 1-4 Members'),
            ])),
          ]),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Prize Pool'),
              _textField(_prizePoolCtrl, 'e.g. ₹1,00,000'),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Registration Fee'),
              _textField(_registrationFeeCtrl, 'e.g. Free or ₹499'),
            ])),
          ]),
          const SizedBox(height: 24),

          _label('Banner Image'),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120, width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VC.border, style: BorderStyle.solid),
              ),
              child: _thumbnailImage != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.memory(_thumbnailImage!.bytes!, fit: BoxFit.cover))
                  : widget.existingItem?['imageUrl'] != null && widget.existingItem!['imageUrl'].isNotEmpty
                      ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(widget.existingItem!['imageUrl'], fit: BoxFit.cover))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload_outlined, color: VC.textTer, size: 32),
                            const SizedBox(height: 8),
                            Text('Upload Event Banner', style: GoogleFonts.inter(fontSize: 12, color: VC.textTer)),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: VC.text)),
  );

  Widget _textField(TextEditingController controller, String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: VC.primary)),
      ),
    );
  }
}
