import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/widgets/glass_card.dart';
import 'package:auto_ease/src/common/utils/animation_extensions.dart';
import 'package:auto_ease/src/features/chat/data/mock_chat_data.dart';
import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: GradientBackground.subtle(
        colorScheme: colorScheme,
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kMockChatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = kMockChatRooms[index];
              return _ChatListItem(chatRoom: chatRoom).staggeredListItem(index);
            },
          ),
        ),
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatRoom chatRoom;

  const _ChatListItem({required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lastMessageTime =
        DateFormat.Hm().format(chatRoom.lastMessage.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: () {
          context.push('/chat/${chatRoom.id}', extra: chatRoom);
        },
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chatRoom.participantAvatarUrl),
                ),
                if (chatRoom.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chatRoom.participantName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        lastMessageTime,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatRoom.lastMessage.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: chatRoom.unreadCount > 0
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                            fontWeight: chatRoom.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (chatRoom.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chatRoom.unreadCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
