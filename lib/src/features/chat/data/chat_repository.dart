import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_ease/src/features/chat/domain/chat_room.dart';
import 'package:auto_ease/src/features/chat/domain/message.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final SupabaseClient _supabase;
  final String _currentUserId;

  ChatRepository(this._supabase, this._currentUserId);

  Future<ChatRoom?> fetchChatRoom(String id) async {
    final data = await _supabase
        .from('chat_rooms')
        .select('*, participant1:profiles!participant1_id(*), participant2:profiles!participant2_id(*)')
        .eq('id', id)
        .single();
    
    final lastMessageData = await _supabase
        .from('messages')
        .select()
        .eq('room_id', id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final lastMessage = lastMessageData != null 
        ? Message.fromJson(lastMessageData, _currentUserId)
        : Message(
            id: 'n/a',
            senderId: '',
            content: 'No messages yet',
            timestamp: DateTime.now(),
            isMe: false,
          );

    return ChatRoom.fromJson(data, lastMessage, _currentUserId);
  }

  Stream<List<Message>> watchMessages(String roomId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .map((data) => data.map((json) => Message.fromJson(json, _currentUserId)).toList());
  }

  Stream<List<ChatRoom>> watchChatRooms() {
    return _supabase
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .asyncMap((rooms) async {
          final List<ChatRoom> chatRooms = [];
          for (final room in rooms) {
            if (room['participant1_id'] == _currentUserId || 
                room['participant2_id'] == _currentUserId) {
              final fetchedRoom = await fetchChatRoom(room['id']);
              if (fetchedRoom != null) chatRooms.add(fetchedRoom);
            }
          }
          return chatRooms;
        });
  }

  Future<void> sendMessage(String roomId, String content) async {
    await _supabase.from('messages').insert({
      'room_id': roomId,
      'sender_id': _currentUserId,
      'content': content,
    });
    
    await _supabase.from('chat_rooms').update({
      'last_message_at': DateTime.now().toIso8601String(),
    }).eq('id', roomId);
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;
  return ChatRepository(supabase, user?.uid ?? '');
}

@riverpod
Stream<List<Message>> chatMessages(Ref ref, String roomId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchMessages(roomId);
}

@riverpod
Stream<List<ChatRoom>> chatRooms(Ref ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.watchChatRooms();
}

@riverpod
Stream<ChatRoom?> chatRoom(Ref ref, String id) {
  return Stream.fromFuture(ref.watch(chatRepositoryProvider).fetchChatRoom(id));
}
