class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool isMe;

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json, String currentUserUid) {
    return Message(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      isMe: json['sender_id'] == currentUserUid,
    );
  }
}
