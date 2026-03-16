import 'package:flutter_test/flutter_test.dart';
import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:auto_ease/src/features/chat/domain/message.dart';

void main() {
  group('Message', () {
    test('can be instantiated', () {
      final now = DateTime.now();
      final message = Message(
        id: 'm1',
        senderId: 's1',
        content: 'Hello',
        timestamp: now,
        isMe: true,
      );

      expect(message.id, 'm1');
      expect(message.senderId, 's1');
      expect(message.content, 'Hello');
      expect(message.timestamp, now);
      expect(message.isMe, true);
      expect(message.isRead, false);
    });
  });

  group('ChatRoom', () {
    test('can be instantiated', () {
      final now = DateTime.now();
      final lastMessage = Message(
        id: 'm1',
        senderId: 's1',
        content: 'Hello',
        timestamp: now,
        isMe: false,
      );

      final chatRoom = ChatRoom(
        id: 'cr1',
        participantName: 'John Doe',
        participantAvatarUrl: 'https://example.com/avatar.png',
        lastMessage: lastMessage,
      );

      expect(chatRoom.id, 'cr1');
      expect(chatRoom.participantName, 'John Doe');
      expect(chatRoom.participantAvatarUrl, 'https://example.com/avatar.png');
      expect(chatRoom.lastMessage, lastMessage);
      expect(chatRoom.unreadCount, 0);
      expect(chatRoom.isOnline, false);
    });
  });
}
