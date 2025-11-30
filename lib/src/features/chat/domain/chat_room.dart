import 'package:auto_ease/src/features/chat/domain/message.dart';

class ChatRoom {
  final String id;
  final String participantName;
  final String participantAvatarUrl;
  final Message lastMessage;
  final int unreadCount;
  final bool isOnline;

  const ChatRoom({
    required this.id,
    required this.participantName,
    required this.participantAvatarUrl,
    required this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}
