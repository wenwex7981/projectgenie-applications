import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

/// Vendor Banner Management Screen
/// Create, edit, delete banners that appear as carousels in the buyer app.
class ManageBannersScreen extends StatefulWidget {
  const ManageBannersScreen({super.key});

  @override
  State<ManageBannersScreen> createState() => _ManageBannersScreenState();
}

class _ManageBannersScreenState extends State<ManageBannersScreen> {
  List<Map<String, dynamic>> _banners = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    setState(() => _loading = true);
    _banners = await ApiService.getBanners();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VC.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: VC.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Manage Banners', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: VC.text)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded, color: VC.accent), onPressed: _loadBanners),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBannerDialog(),
        backgroundColor: VC.accent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Add Banner', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _banners.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadBanners,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _banners.length,
                    itemBuilder: (ctx, i) => _buildBannerCard(_banners[i]),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.view_carousel_rounded, size: 64, color: VC.textTer),
          const SizedBox(height: 16),
          Text('No Banners Yet', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: VC.text)),
          const SizedBox(height: 8),
          Text('Create banners that appear in the buyer app carousel', style: GoogleFonts.inter(fontSize: 13, color: VC.textSec)),
        ],
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    final gradStart = Color(int.tryParse(banner['gradientStart']?.toString() ?? '0xFF1A56DB') ?? 0xFF1A56DB);
    final gradEnd = Color(int.tryParse(banner['gradientEnd']?.toString() ?? '0xFF7C3AED') ?? 0xFF7C3AED);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [gradStart, gradEnd], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: gradStart.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (banner['tag'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
                        child: Text(banner['tag'], style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (banner['isActive'] == true) ? Colors.green.shade400 : Colors.red.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (banner['isActive'] == true) ? 'ACTIVE' : 'INACTIVE',
                        style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(banner['title'] ?? '', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                if (banner['subtitle'] != null) ...[
                  const SizedBox(height: 4),
                  Text(banner['subtitle'], style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                ],
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('Order: ${banner['sortOrder'] ?? 0}', style: GoogleFonts.inter(fontSize: 11, color: VC.textSec)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 18, color: VC.accent),
                  onPressed: () => _showBannerDialog(banner: banner),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded, size: 18, color: VC.error),
                  onPressed: () => _deleteBanner(banner['id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBanner(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Banner?'),
        content: const Text('This will remove the banner from the buyer app carousel.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.deleteBanner(id);
      _loadBanners();
    }
  }

  Future<void> _showBannerDialog({Map<String, dynamic>? banner}) async {
    final isEdit = banner != null;
    final titleCtrl = TextEditingController(text: banner?['title'] ?? '');
    final subtitleCtrl = TextEditingController(text: banner?['subtitle'] ?? '');
    final tagCtrl = TextEditingController(text: banner?['tag'] ?? '');
    final imageUrlCtrl = TextEditingController(text: banner?['imageUrl'] ?? '');
    final gradStartCtrl = TextEditingController(text: banner?['gradientStart'] ?? '0xFF1A56DB');
    final gradEndCtrl = TextEditingController(text: banner?['gradientEnd'] ?? '0xFF7C3AED');
    final sortCtrl = TextEditingController(text: (banner?['sortOrder'] ?? 0).toString());
    bool isActive = banner?['isActive'] ?? true;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Banner' : 'New Banner'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title *')),
                TextField(controller: subtitleCtrl, decoration: const InputDecoration(labelText: 'Subtitle')),
                TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'Tag (e.g., 🔥 LIMITED)')),
                TextField(controller: imageUrlCtrl, decoration: const InputDecoration(labelText: 'Image URL (optional)')),
                TextField(controller: gradStartCtrl, decoration: const InputDecoration(labelText: 'Gradient Start (hex)')),
                TextField(controller: gradEndCtrl, decoration: const InputDecoration(labelText: 'Gradient End (hex)')),
                TextField(controller: sortCtrl, decoration: const InputDecoration(labelText: 'Sort Order'), keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (v) => setDialogState(() => isActive = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'title': titleCtrl.text,
                  'subtitle': subtitleCtrl.text,
                  'tag': tagCtrl.text,
                  'imageUrl': imageUrlCtrl.text,
                  'gradientStart': gradStartCtrl.text,
                  'gradientEnd': gradEndCtrl.text,
                  'sortOrder': int.tryParse(sortCtrl.text) ?? 0,
                  'isActive': isActive,
                };
                if (isEdit) {
                  await ApiService.updateBanner(banner!['id'], data);
                } else {
                  await ApiService.createBanner(data);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                _loadBanners();
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
