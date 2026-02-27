import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ExpertChatScreen extends StatelessWidget {
  const ExpertChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF64748B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAZSo4cTUTvLJK172JnNHls3SnFKLkQGou4BlyiWD3n5JRXL8Esn2jHlZ3D_DMY278m3lpl9zU2HUOk7mlRE3HwFINEqCHP5-S6TbiU0Dc2bzGlfuy7aArZ0tEuhY4qJay13LhpevJwPERca24c0PTpwQJOigt5hhZuc5NO5H-2JIJl6_NrJrDQhqXdjQ2BOwIMVGFjdE0ZfZghPm1WXsc3xiuVFNM8ZsAJ5KRPD62rhU5-_Utftj_UsyBqqgVMZXTtHIO8wiGst8c"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Rivera',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDateDivider('Today'),
                _buildExpertMessage(
                  'Hello! How is the project coming along? I saw you were working on the methodology section yesterday.',
                  '10:24 AM',
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuA1g_sm1UExLvVgdFYmkYD1kx5P8_RGbkzN4-Z3Vu-fMb0k9VKvufdji2BPBZ8xtNWXN2m6-p-FYEbVoty0dcYjP6KVIzDqH8yA7qCu9H4UvbSumK50K8UTi5A-RyfatCuTeZ-BTh0E0-yhnEC-6CjD6NgfnQo4hSWmvzrim92bxclQ86eSXFi9vPzuLFh2HQNxygNAhhOR75KP6UEaxrgvK7u0ZTFXDxb-V2KenGm6JmMqGTd5qGaN02bxILzYH3txl7gJ0Pv2B6o",
                ),
                _buildUserMessage(
                  "Hi Alex, I've finished the initial draft for that section. Can you take a look? I'm a bit unsure about the data collection part.",
                  '10:26 AM',
                ),
                _buildUserFileMessage(
                  'Project_Draft_v1.pdf',
                  '2.4 MB • PDF',
                  '10:26 AM',
                ),
                _buildExpertMessage(
                  "Of course. I'll review it and get back to you by this evening with some detailed feedback.",
                  '10:28 AM',
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDi3uKxEITLCycmPWttJPbGVqdfUFs0r84yEZIGMYsukI5FlRWXPS74Dv0qfdqU3fDqY8gKWhnUI8M65lkac4RFMz7M2HVXvpPMci8gLABI3VJKwmk2kCZxvHlO_Lc7KGriE75wXui-i_S7f0I6N5PHbrO8HbiDaMw8fJnBEDmhXYevUVHD6TfgGvXK1j_NO2jQvnMbvqEpkRoLcSCcC_7JCMYfs-zWUjGQ3DLV1dfW5umMFsC8r51-XZPBjCoXAjiO4AzLSfI2a9E",
                ),
                _buildExpertVoiceMessage(
                  '0:42',
                  '10:29 AM',
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuAEWUQSJI9tjKTIcVu2RZvNLIzURSpeWeojGpQ1C4ljKDwlgEmTDILh9cDRIw-NO1lims-Bhaevf-hjFxIiWf3-l52TKN2Ize-AwLhz_sOZWbLDC9U_GlOe0B4kR_21SjJhSf7jt-JdPya8EQFuaVe2sAHVloXmcReGv0qrLCDKVEB7sQ7NjrSrqAPPl_upBXvmWEUVZxshkdNGuuJcfKVtn-2YgSW9xiNPpb9Gsz0_uWK96AOGIb0JXs3Ws426L4xSmRlSpT-uczQ",
                ),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String label) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildExpertMessage(String text, String time, String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, height: 1.5),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    time,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    time,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserFileMessage(String fileName, String fileSize, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Container(
            width: 280,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              fileSize,
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.download, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.done_all, color: AppTheme.primaryColor, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertVoiceMessage(String duration, String time, String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildWaveBar(16, 0.4),
                              _buildWaveBar(24, 0.6),
                              _buildWaveBar(12, 0.3),
                              _buildWaveBar(20, 0.5),
                              _buildWaveBar(28, 1.0),
                              _buildWaveBar(16, 0.4),
                              _buildWaveBar(24, 0.6),
                              _buildWaveBar(8, 0.2),
                              _buildWaveBar(20, 0.5),
                              _buildWaveBar(16, 0.4),
                              _buildWaveBar(32, 0.8),
                              _buildWaveBar(12, 0.3),
                              _buildWaveBar(20, 0.5),
                              _buildWaveBar(8, 0.2),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        duration,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    time,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildWaveBar(double height, double opacity) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(opacity),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          _buildCircleButton(Icons.attach_file, const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Color(0xFF64748B), size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildCircleButton(Icons.mic_outlined, const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
