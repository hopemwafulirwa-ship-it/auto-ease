import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_ease/src/common/widgets/gradient_background.dart';
import 'package:auto_ease/src/common/utils/animation_extensions.dart';
import 'package:auto_ease/src/features/chat/application/chat_controller.dart';
import 'package:auto_ease/src/features/chat/data/chat_repository.dart';
import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:auto_ease/src/features/chat/domain/message.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    await ref.read(chatControllerProvider.notifier).sendMessage(
          widget.chatId,
          content,
        );

    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chatRoomValue = ref.watch(chatRoomProvider(widget.chatId));
    final messagesValue = ref.watch(chatMessagesProvider(widget.chatId));

    return chatRoomValue.when(
      data: (chatRoom) {
        if (chatRoom == null) {
          return const Scaffold(body: Center(child: Text('Chat not found')));
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(theme, colorScheme, chatRoom),
          body: GradientBackground.subtle(
            colorScheme: colorScheme,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: messagesValue.when(
                      data: (messages) {
                        // Scroll to bottom when new messages arrive
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                        
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final showTime = index == 0 ||
                                message.timestamp
                                        .difference(messages[index - 1].timestamp)
                                        .inMinutes >
                                    15;

                            return Column(
                              children: [
                                if (showTime)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      DateFormat.jm().format(message.timestamp),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                _MessageBubble(message: message).fadeInSlideUp(
                                  delay: Duration(milliseconds: index * 50),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Error loading messages: $e')),
                    ),
                  ),
                  _buildInputArea(theme, colorScheme),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorScheme colorScheme, ChatRoom chatRoom) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(chatRoom.participantAvatarUrl),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatRoom.participantName,
                style: theme.textTheme.titleMedium,
              ),
              if (chatRoom.isOnline)
                Text(
                  'Online',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: colorScheme.surface.withOpacity(0.8),
      elevation: 0,
    );
  }

  Widget _buildInputArea(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isMe ? 20 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 20),
          ),
        ),
        child: Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: message.isMe ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
