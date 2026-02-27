import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/data/mock_data.dart';

class ChatScreen extends StatefulWidget {
  final String vendorName;
  final bool isOnline;

  const ChatScreen({
    super.key,
    required this.vendorName,
    this.isOnline = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.accent.withOpacity(0.1),
                  child: Text(
                    widget.vendorName.substring(0, 2).toUpperCase(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (widget.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vendorName,
                    style: AppTypography.subheadingMedium,
                  ),
                  Text(
                    widget.isOnline ? 'Online' : 'Last seen 2h ago',
                    style: AppTypography.caption.copyWith(
                      color: widget.isOnline
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              itemCount: MockData.chatMessages.length,
              itemBuilder: (context, index) {
                final message = MockData.chatMessages[index];
                final showAvatar = index == 0 ||
                    MockData.chatMessages[index - 1].isSender !=
                        message.isSender;

                return _MessageBubble(
                  message: message,
                  showAvatar: showAvatar,
                  vendorInitials:
                      widget.vendorName.substring(0, 2).toUpperCase(),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLG,
              vertical: AppConstants.spacingMD,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Attachment
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSM,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.attach_file_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text Field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXXL,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Send Button
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSM,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _messageController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message;
  final bool showAvatar;
  final String vendorInitials;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.vendorInitials,
  });

  @override
  Widget build(BuildContext context) {
    final isSender = message.isSender;

    return Padding(
      padding: EdgeInsets.only(
        bottom: showAvatar ? 12 : 4,
        left: isSender ? 48 : 0,
        right: isSender ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender && showAvatar) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.accent.withOpacity(0.1),
              child: Text(
                vendorInitials,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (!isSender && !showAvatar) const SizedBox(width: 36),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSender ? AppColors.accent : AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSender ? 16 : 4),
                  bottomRight: Radius.circular(isSender ? 4 : 16),
                ),
                boxShadow: [
                  if (!isSender)
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSender ? Colors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSender
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
