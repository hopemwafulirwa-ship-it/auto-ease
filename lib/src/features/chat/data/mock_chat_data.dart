import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:auto_ease/src/features/chat/domain/message.dart';

final kMockChatRooms = [
  ChatRoom(
    id: 'chat_001',
    participantName: 'AutoCare Plus',
    participantAvatarUrl:
        'https://ui-avatars.com/api/?name=AutoCare+Plus&background=1565C0&color=fff',
    lastMessage: Message(
      id: 'msg_001',
      senderId: 'center_001',
      content: 'Your vehicle is ready for pickup.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: false,
    ),
    unreadCount: 1,
    isOnline: true,
  ),
  ChatRoom(
    id: 'chat_002',
    participantName: 'QuickFix Auto',
    participantAvatarUrl:
        'https://ui-avatars.com/api/?name=QuickFix+Auto&background=FFA726&color=fff',
    lastMessage: Message(
      id: 'msg_002',
      senderId: 'user_001',
      content: 'Can I reschedule my appointment?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isMe: true,
    ),
    unreadCount: 0,
    isOnline: false,
  ),
  ChatRoom(
    id: 'chat_003',
    participantName: 'Elite Motors Service',
    participantAvatarUrl:
        'https://ui-avatars.com/api/?name=Elite+Motors&background=4CAF50&color=fff',
    lastMessage: Message(
      id: 'msg_003',
      senderId: 'center_003',
      content: 'We have received your booking request.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isMe: false,
    ),
    unreadCount: 0,
    isOnline: true,
  ),
];

final kMockMessages = {
  'chat_001': [
    Message(
      id: 'msg_001',
      senderId: 'center_001',
      content: 'Your vehicle is ready for pickup.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: false,
    ),
    Message(
      id: 'msg_001_1',
      senderId: 'user_001',
      content: 'Great! I will be there in 30 minutes.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isMe: true,
    ),
    Message(
      id: 'msg_001_2',
      senderId: 'center_001',
      content: 'The oil change and tire rotation are complete.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isMe: false,
    ),
  ],
  'chat_002': [
    Message(
      id: 'msg_002',
      senderId: 'user_001',
      content: 'Can I reschedule my appointment?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isMe: true,
    ),
    Message(
      id: 'msg_002_1',
      senderId: 'center_002',
      content: 'Sure, what time works best for you?',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isMe: false,
    ),
  ],
};
