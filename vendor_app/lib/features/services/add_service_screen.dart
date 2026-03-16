import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class AddServiceScreen extends StatefulWidget {
  final String vendorId;
  final bool isProject;
  const AddServiceScreen({super.key, required this.vendorId, this.isProject = false});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _origPriceCtrl = TextEditingController();
  final _deliveryCtrl = TextEditingController(text: 'Instant');
  final _featuresCtrl = TextEditingController();
  final _techStackCtrl = TextEditingController();
  String _selectedCategory = 'Machine Learning';
  String _selectedDomain = 'AI/ML';
  String _difficulty = 'Intermediate';
  bool _isFeatured = false;
  bool _loading = false;
  String _uploadStatus = '';

  PlatformFile? _thumbnailImage;
  PlatformFile? _abstractDoc;
  PlatformFile? _videoFile;
  List<PlatformFile> _galleryImages = [];

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null) setState(() => _thumbnailImage = result.files.first);
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video, withData: true);
    if (result != null) setState(() => _videoFile = result.files.first);
  }

  Future<void> _pickDoc() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
      withData: true,
    );
    if (result != null) setState(() => _abstractDoc = result.files.first);
  }

  Future<void> _pickGalleryImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() => _galleryImages = result.files.take(5).toList());
    }
  }

  final _categories = ['Machine Learning', 'Deep Learning', 'CNN Projects', 'Web Development', 'Mobile Apps', 'IoT Projects', 'Data Science', 'Mini Project', 'Resume'];
  final _domains = ['AI/ML', 'Computer Science', 'IoT', 'Data Science', 'Web Development', 'Blockchain', 'Cyber Security', 'Mobile App'];
  final _difficulties = ['Beginner', 'Intermediate', 'Advanced'];

  /// Upload a file to Supabase storage and return the public URL
  Future<String?> _uploadToSupabase(String bucket, String folder, PlatformFile file) async {
    try {
      if (file.bytes == null) return null;
      final ext = file.name.split('.').last.toLowerCase();
      final path = '$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name.replaceAll(' ', '_')}';

      await Supabase.instance.client.storage
          .from(bucket)
          .uploadBinary(path, file.bytes!, fileOptions: FileOptions(contentType: _getContentType(ext)));

      final url = Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      print('Upload error ($bucket/$folder): $e');
      // Fallback: try via backend API
      try {
        if (file.bytes == null) return null;
        final base64Data = base64Encode(file.bytes!);
        final ext = file.name.split('.').last.toLowerCase();
        final path = '$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name.replaceAll(' ', '_')}';

        final response = await ApiService.uploadBase64(
          bucket: bucket,
          path: path,
          base64Data: base64Data,
          contentType: _getContentType(ext),
        );
        return response?['publicUrl'];
      } catch (e2) {
        print('Backend upload fallback error: $e2');
        return null;
      }
    }
  }

  String _getContentType(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        title: Text(widget.isProject ? 'Add Project' : 'Add Service'),
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
          _label('Title *'),
          _textField(_titleCtrl, 'e.g. AI Plant Disease Detection System'),
          const SizedBox(height: 20),

          _label('Description *'),
          _textField(_descCtrl, 'Describe your service/project in detail...', maxLines: 5),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Price (₹) *'),
              _textField(_priceCtrl, '4999', keyboardType: TextInputType.number),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Original Price'),
              _textField(_origPriceCtrl, '7999', keyboardType: TextInputType.number),
            ])),
          ]),
          const SizedBox(height: 20),

          if (!widget.isProject) ...[
            _label('Category *'),
            _dropdown(_selectedCategory, _categories, (v) => setState(() => _selectedCategory = v!)),
            const SizedBox(height: 20),
            _label('Delivery Time'),
            _textField(_deliveryCtrl, 'Instant'),
          ],

          if (widget.isProject) ...[
            _label('Domain *'),
            _dropdown(_selectedDomain, _domains, (v) => setState(() => _selectedDomain = v!)),
            const SizedBox(height: 20),
            _label('Difficulty'),
            _dropdown(_difficulty, _difficulties, (v) => setState(() => _difficulty = v!)),
            const SizedBox(height: 20),
            _label('Tech Stack (comma-separated)'),
            _textField(_techStackCtrl, 'Python, TensorFlow, Flask, React'),
          ],
          const SizedBox(height: 20),

          _label('Features / Highlights (comma-separated)'),
          _textField(_featuresCtrl, 'Full Source Code, Documentation, PPT'),
          const SizedBox(height: 20),

          // Upload Section
          _label('Media & Documents'),
          const SizedBox(height: 8),

          // Row 1: Thumbnail + Video
          Row(children: [
            Expanded(child: _uploadTile(
              icon: Icons.image_rounded,
              label: _thumbnailImage != null ? 'Image Picked ✓' : 'Upload Thumbnail',
              picked: _thumbnailImage != null,
              onTap: _pickImage,
            )),
            const SizedBox(width: 12),
            Expanded(child: _uploadTile(
              icon: Icons.videocam_rounded,
              label: _videoFile != null ? 'Video Picked ✓' : 'Upload Video',
              picked: _videoFile != null,
              onTap: _pickVideo,
            )),
          ]),
          const SizedBox(height: 12),

          // Row 2: Document + Gallery
          Row(children: [
            Expanded(child: _uploadTile(
              icon: Icons.picture_as_pdf_rounded,
              label: _abstractDoc != null ? 'Doc Picked ✓' : 'Upload Abstract/Doc',
              picked: _abstractDoc != null,
              onTap: _pickDoc,
            )),
            const SizedBox(width: 12),
            Expanded(child: _uploadTile(
              icon: Icons.photo_library_rounded,
              label: _galleryImages.isNotEmpty ? '${_galleryImages.length} Images ✓' : 'Gallery Images',
              picked: _galleryImages.isNotEmpty,
              onTap: _pickGalleryImages,
            )),
          ]),
          const SizedBox(height: 20),

          // Upload status
          if (_uploadStatus.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: VC.accentLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: VC.accent)),
                const SizedBox(width: 12),
                Expanded(child: Text(_uploadStatus, style: GoogleFonts.inter(fontSize: 12, color: VC.accent, fontWeight: FontWeight.w600))),
              ]),
            ),

          const SizedBox(height: 20),

          // Featured toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: VC.border)),
            child: Row(children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 20),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Featured Listing', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: VC.text)),
                Text('Appears in featured section on home', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
              ])),
              Switch(value: _isFeatured, onChanged: (v) => setState(() => _isFeatured = v), activeColor: VC.accent),
            ]),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: VC.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _loading
                  ? const CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)
                  : Text('Publish ${widget.isProject ? 'Project' : 'Service'}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _uploadTile({required IconData icon, required String label, required bool picked, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: picked ? VC.successBg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: picked ? VC.success : VC.border),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: picked ? VC.success : VC.textTer, size: 32),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: picked ? VC.success : VC.textTer, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.text)),
    );
  }

  Widget _textField(TextEditingController ctrl, String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: VC.textTer),
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: VC.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: VC.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: VC.accent, width: 2)),
      ),
    );
  }

  Widget _dropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: VC.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: GoogleFonts.inter(fontSize: 14, color: VC.text),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty || _priceCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields'), backgroundColor: VC.error));
      return;
    }
    setState(() { _loading = true; _uploadStatus = ''; });

    try {
      final features = _featuresCtrl.text.isNotEmpty ? _featuresCtrl.text.split(',').map((e) => e.trim()).toList() : <String>[];

      String? thumbnailUrl;
      String? videoUrl;
      String? documentUrl;
      List<String> galleryUrls = [];

      // Upload thumbnail
      if (_thumbnailImage != null && _thumbnailImage!.bytes != null) {
        setState(() => _uploadStatus = 'Uploading thumbnail...');
        thumbnailUrl = await _uploadToSupabase('vendor_assets', 'images', _thumbnailImage!);
      }

      // Upload video
      if (_videoFile != null && _videoFile!.bytes != null) {
        setState(() => _uploadStatus = 'Uploading video...');
        videoUrl = await _uploadToSupabase('vendor_assets', 'videos', _videoFile!);
      }

      // Upload document
      if (_abstractDoc != null && _abstractDoc!.bytes != null) {
        setState(() => _uploadStatus = 'Uploading document...');
        documentUrl = await _uploadToSupabase('documents', 'abstracts', _abstractDoc!);
      }

      // Upload gallery images
      for (int i = 0; i < _galleryImages.length; i++) {
        final gImg = _galleryImages[i];
        if (gImg.bytes != null) {
          setState(() => _uploadStatus = 'Uploading gallery image ${i + 1}/${_galleryImages.length}...');
          final url = await _uploadToSupabase('vendor_assets', 'gallery', gImg);
          if (url != null) galleryUrls.add(url);
        }
      }

      setState(() => _uploadStatus = 'Publishing...');

      if (widget.isProject) {
        final techStack = _techStackCtrl.text.isNotEmpty ? _techStackCtrl.text.split(',').map((e) => e.trim()).toList() : <String>[];
        await ApiService.createProject({
          'title': _titleCtrl.text,
          'description': _descCtrl.text,
          'price': '₹${_priceCtrl.text}',
          'originalPrice': _origPriceCtrl.text.isNotEmpty ? '₹${_origPriceCtrl.text}' : null,
          'domain': _selectedDomain,
          'difficulty': _difficulty,
          'techStack': jsonEncode(techStack),
          'features': jsonEncode(features),
          'isFeatured': _isFeatured,
          'vendorId': widget.vendorId,
          if (thumbnailUrl != null) 'imageUrl': thumbnailUrl,
          if (videoUrl != null) 'videoUrl': videoUrl,
          if (documentUrl != null) 'documentUrl': documentUrl,
          if (galleryUrls.isNotEmpty) 'galleryImages': jsonEncode(galleryUrls),
        });
      } else {
        final cats = await ApiService.getCategories();
        final catId = cats.isNotEmpty
            ? (cats.firstWhere((c) => c['title'] == _selectedCategory, orElse: () => cats.first))['id']
            : null;

        await ApiService.createService({
          'title': _titleCtrl.text,
          'description': _descCtrl.text,
          'vendorName': 'Vendor',
          'price': double.tryParse(_priceCtrl.text) ?? 0,
          'originalPrice': double.tryParse(_origPriceCtrl.text),
          'deliveryDays': _deliveryCtrl.text,
          'categoryId': catId,
          'vendorId': widget.vendorId,
          'features': jsonEncode(features),
          'isFeatured': _isFeatured,
          if (thumbnailUrl != null) 'imageUrl': thumbnailUrl,
          if (videoUrl != null) 'videoUrl': videoUrl,
          if (documentUrl != null) 'documentUrl': documentUrl,
          if (galleryUrls.isNotEmpty) 'galleryImages': jsonEncode(galleryUrls),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${widget.isProject ? 'Project' : 'Service'} published successfully! 🎉'),
          backgroundColor: VC.success,
        ));
        Navigator.pop(context, true); // Return true to signal data changed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: VC.error));
      }
    }
    if (mounted) setState(() { _loading = false; _uploadStatus = ''; });
  }
}
