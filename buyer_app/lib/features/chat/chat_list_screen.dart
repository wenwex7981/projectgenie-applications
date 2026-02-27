import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../core/models/models.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> _threads = [];
  bool _loading = true;
  String _activeTab = 'All';

  @override
  void initState() {
    super.initState();
    _loadThreads();
  }

  Future<void> _loadThreads() async {
    setState(() => _loading = true);
    try {
      final threads = await ApiService.getChatThreads();
      if (threads.isNotEmpty && mounted) {
        setState(() { _threads = threads; _loading = false; });
      } else {
        throw Exception('No threads');
      }
    } catch (e) {
      // Fallback to demo data
      if (mounted) setState(() {
        _threads = [
          {
            'vendorId': 'v1',
            'vendorName': 'ProjectGenie Labs',
            'lastMessage': 'Your project files have been sent! Check your downloads.',
            'time': '2m ago',
            'unread': 1,
            'isOnline': true,
            'avatar': 'https://i.pravatar.cc/150?u=pgsupport',
            'verified': true,
          },
          {
            'vendorId': 'v2',
            'vendorName': 'DeepTech Solutions',
            'lastMessage': 'We have reviewed your request. Could you clarify the API usage?',
            'time': '1h ago',
            'unread': 0,
            'isOnline': true,
            'avatar': 'https://i.pravatar.cc/150?u=deeptech',
            'verified': true,
          },
          {
            'vendorId': 'v3',
            'vendorName': 'VisionAI Studio',
            'lastMessage': 'The new model architecture is ready for your review.',
            'time': 'Yesterday',
            'unread': 0,
            'isOnline': false,
            'avatar': 'https://i.pravatar.cc/150?u=visionai',
            'verified': true,
          },
          {
            'vendorId': 'v4',
            'vendorName': 'Support Team',
            'lastMessage': 'How can we help you today?',
            'time': '2 days ago',
            'unread': 0,
            'isOnline': false,
            'avatar': 'https://i.pravatar.cc/150?u=support',
            'verified': false,
          },
        ];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _threads.where((t) => (t['unread'] ?? 0) > 0).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        title: Row(
          children: [
            Text('Messages', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 22, color: AppColors.textPrimary)),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
                child: Text('$unreadCount', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ],
          ],
        ),
        actions: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
              padding: EdgeInsets.zero,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Tab filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildTab('All', _threads.length),
                const SizedBox(width: 8),
                _buildTab('Vendors', _threads.where((t) => t['verified'] == true).length),
                const SizedBox(width: 8),
                _buildTab('Support', _threads.where((t) => t['verified'] != true).length),
              ],
            ),
          ),
          // Chat list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredThreads.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadThreads,
                        color: AppColors.primary,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: _filteredThreads.length,
                          separatorBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(left: 88, right: 20),
                            child: Divider(height: 1, color: Colors.grey[100]),
                          ),
                          itemBuilder: (context, index) => _ChatTile(
                            chat: _filteredThreads[index],
                            onTap: () => _openChat(_filteredThreads[index]),
                          ),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredThreads {
    if (_activeTab == 'All') return _threads;
    if (_activeTab == 'Vendors') return _threads.where((t) => t['verified'] == true).toList();
    return _threads.where((t) => t['verified'] != true).toList();
  }

  void _openChat(Map<String, dynamic> thread) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ChatDetailScreen(
        thread: ChatThread(
          id: thread['vendorId'] ?? '',
          vendorName: thread['vendorName'] ?? '',
          lastMessage: thread['lastMessage'] ?? '',
          time: thread['time'] ?? '',
          isOnline: thread['isOnline'] ?? false,
          unreadCount: thread['unread'] ?? 0,
        ),
      ),
    ));
  }

  Widget _buildTab(String text, int count) {
    final isSelected = _activeTab == text;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.heroGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(text, style: GoogleFonts.inter(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700, fontSize: 13,
            )),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$count', style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textTertiary,
                )),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.chat_bubble_outline_rounded, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text('No Messages Yet', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text('Start chatting with vendors', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;
  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = (chat['unread'] ?? 0) > 0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primarySurface,
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      chat['avatar'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          (chat['vendorName'] ?? 'V').toString().substring(0, 1).toUpperCase(),
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
                if (chat['isOnline'] == true)
                  Positioned(
                    bottom: 2, right: 2,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Row(children: [
                        Flexible(child: Text(
                          chat['vendorName'] ?? chat['name'] ?? '',
                          style: GoogleFonts.inter(fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600, fontSize: 15, color: AppColors.textPrimary),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),
                        if (chat['verified'] == true) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF3B82F6)),
                        ],
                      ])),
                      Text(chat['time'] ?? '', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: hasUnread ? AppColors.primary : AppColors.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    Expanded(child: Text(
                      chat['lastMessage'] ?? chat['message'] ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                      ),
                    )),
                    if (hasUnread)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 22, height: 22,
                        decoration: BoxDecoration(gradient: AppColors.heroGradient, shape: BoxShape.circle),
                        child: Center(child: Text('${chat['unread']}', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
