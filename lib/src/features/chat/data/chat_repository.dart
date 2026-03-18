import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:auto_ease/src/features/chat/data/mock_chat_data.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  Future<ChatRoom?> fetchChatRoom(String id) async {
    return kMockChatRooms.firstWhere((room) => room.id == id);
  }

  Stream<ChatRoom?> watchChatRoom(String id) {
    return Stream.value(kMockChatRooms.firstWhere((room) => room.id == id));
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository();
}

@riverpod
Stream<ChatRoom?> chatRoom(ChatRoomRef ref, String id) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchChatRoom(id);
}

@riverpod
Future<ChatRoom?> chatRoomFuture(ChatRoomFutureRef ref, String id) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.fetchChatRoom(id);
}
