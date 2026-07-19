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

  factory ChatRoom.fromJson(Map<String, dynamic> json, Message lastMessage, String currentUserId) {
    // Determine which participant is the "other" person
    final isParticipant1 = json['participant1_id'] == currentUserId;
    final otherParticipant = isParticipant1 ? json['participant2'] : json['participant1'];
    
    return ChatRoom(
      id: json['id'] as String,
      participantName: otherParticipant?['name'] as String? ?? 'Unknown',
      participantAvatarUrl: otherParticipant?['avatar_url'] as String? ?? '',
      lastMessage: lastMessage,
      unreadCount: json['unread_count'] as int? ?? 0,
      isOnline: otherParticipant?['is_online'] as bool? ?? false,
    );
  }
}
