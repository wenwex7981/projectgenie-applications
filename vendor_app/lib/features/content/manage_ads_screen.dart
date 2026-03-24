import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

/// Vendor Advertisement Management Screen
/// Full CRUD for ads that appear in the buyer app.
class ManageAdsScreen extends StatefulWidget {
  const ManageAdsScreen({super.key});

  @override
  State<ManageAdsScreen> createState() => _ManageAdsScreenState();
}

class _ManageAdsScreenState extends State<ManageAdsScreen> {
  List<Map<String, dynamic>> _ads = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    setState(() => _loading = true);
    _ads = await ApiService.getAdvertisements();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: VC.text), onPressed: () => Navigator.pop(context)),
        title: Text('Manage Advertisements', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: VC.text)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh_rounded, color: VC.accent), onPressed: _loadAds)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdDialog(),
        backgroundColor: VC.accent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('New Ad', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _ads.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.campaign_rounded, size: 64, color: VC.textTer),
                  const SizedBox(height: 16),
                  Text('No Advertisements', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: VC.text)),
                  const SizedBox(height: 8),
                  Text('Create ads that appear in the buyer app', style: GoogleFonts.inter(fontSize: 13, color: VC.textSec)),
                ]))
              : RefreshIndicator(
                  onRefresh: _loadAds,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _ads.length,
                    itemBuilder: (ctx, i) => _buildAdCard(_ads[i]),
                  ),
                ),
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ad['imageUrl'] != null && ad['imageUrl'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(ad['imageUrl'], height: 140, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 140, color: VC.surface, child: const Center(child: Icon(Icons.image_not_supported)))),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(ad['title'] ?? '', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.text))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (ad['isActive'] == true) ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      (ad['isActive'] == true) ? 'ACTIVE' : 'INACTIVE',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: (ad['isActive'] == true) ? Colors.green : Colors.red),
                    ),
                  ),
                ]),
                if (ad['description'] != null) ...[
                  const SizedBox(height: 6),
                  Text(ad['description'], style: GoogleFonts.inter(fontSize: 12, color: VC.textSec), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.visibility_rounded, size: 14, color: VC.textTer),
                  const SizedBox(width: 4),
                  Text('${ad['impressions'] ?? 0} views', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
                  const SizedBox(width: 12),
                  Icon(Icons.touch_app_rounded, size: 14, color: VC.textTer),
                  const SizedBox(width: 4),
                  Text('${ad['clicks'] ?? 0} clicks', style: GoogleFonts.inter(fontSize: 11, color: VC.textTer)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(4)),
                    child: Text(ad['placement'] ?? 'home', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: VC.accent)),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.edit_rounded, size: 18, color: VC.accent), onPressed: () => _showAdDialog(ad: ad)),
                  IconButton(icon: const Icon(Icons.delete_rounded, size: 18, color: VC.error), onPressed: () => _deleteAd(ad['id'])),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAd(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Advertisement?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.deleteAdvertisement(id);
      _loadAds();
    }
  }

  Future<void> _showAdDialog({Map<String, dynamic>? ad}) async {
    final isEdit = ad != null;
    final titleCtrl = TextEditingController(text: ad?['title'] ?? '');
    final descCtrl = TextEditingController(text: ad?['description'] ?? '');
    final imageUrlCtrl = TextEditingController(text: ad?['imageUrl'] ?? '');
    final linkUrlCtrl = TextEditingController(text: ad?['linkUrl'] ?? '');
    String placement = ad?['placement'] ?? 'home';
    bool isActive = ad?['isActive'] ?? true;
    Uint8List? pickedImage;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState2) => AlertDialog(
          title: Text(isEdit ? 'Edit Ad' : 'New Advertisement'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title *')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: imageUrlCtrl, decoration: const InputDecoration(labelText: 'Image URL'))),
              IconButton(
                icon: const Icon(Icons.upload_rounded, color: VC.accent),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    final path = 'ads/${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
                    final url = await ApiService.uploadFile(bucket: 'advertisement-media', path: path, fileBytes: bytes);
                    if (url != null) {
                      setState2(() => imageUrlCtrl.text = url);
                    }
                  }
                },
              ),
            ]),
            TextField(controller: linkUrlCtrl, decoration: const InputDecoration(labelText: 'Link URL (optional)')),
            DropdownButtonFormField<String>(
              value: placement,
              decoration: const InputDecoration(labelText: 'Placement'),
              items: ['home', 'explore', 'category', 'detail'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState2(() => placement = v!),
            ),
            SwitchListTile(title: const Text('Active'), value: isActive, onChanged: (v) => setState2(() => isActive = v)),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'title': titleCtrl.text,
                  'description': descCtrl.text,
                  'imageUrl': imageUrlCtrl.text,
                  'linkUrl': linkUrlCtrl.text,
                  'placement': placement,
                  'isActive': isActive,
                };
                if (isEdit) {
                  await ApiService.updateAdvertisement(ad!['id'], data);
                } else {
                  await ApiService.createAdvertisement(data);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                _loadAds();
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
